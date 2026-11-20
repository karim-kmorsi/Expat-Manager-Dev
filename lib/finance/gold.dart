part of 'ledger.dart';

typedef GoldPurchase = ({int minor, String currency});

class GoldDetails {
  const GoldDetails({
    required this.label,
    required this.kind,
    required this.weightMg,
    required this.karatHundredths,
    required this.owner,
    this.purchaseDay,
    this.purchase,
    this.notes,
  });

  factory GoldDetails.fromPiece(GoldPiece piece) => GoldDetails(
    label: piece.label,
    kind: piece.kind,
    weightMg: piece.weightMg,
    karatHundredths: piece.karatHundredths,
    owner: piece.owner,
    purchaseDay: piece.purchaseDay,
    purchase: piece.purchaseMinor == null
        ? null
        : (minor: piece.purchaseMinor!, currency: piece.purchaseCurrency!),
    notes: piece.notes,
  );

  final String label;
  final GoldKind kind;
  final int weightMg;
  final int karatHundredths;
  final String owner;
  final int? purchaseDay;
  final GoldPurchase? purchase;
  final String? notes;
}

typedef GoldItem = ({GoldPiece piece, GoldSale? sale});
typedef GoldRecord = ({
  GoldItem item,
  IncomeReceipt? receipt,
  List<GoldEvent> events,
});

enum GoldIssue { invalid, samePerson, missing, stale, sold, notSold }

class GoldException implements Exception {
  const GoldException(this.issue);
  final GoldIssue issue;
}

Map<int, BigInt> goldWeightByKarat(Iterable<GoldItem> items) {
  final totals = <int, BigInt>{};
  for (final item in items) {
    if (item.sale != null) continue;
    final weight = BigInt.from(item.piece.weightMg);
    totals.update(
      item.piece.karatHundredths,
      (value) => value + weight,
      ifAbsent: () => weight,
    );
  }
  return totals;
}

bool _pastGoldDay(int day) =>
    _supportedDay(day) && day <= leaveDay(DateTime.now());

Map<String, Object?> _goldDetails(GoldPiece piece) => {
  'label': piece.label,
  'kind': piece.kind.name,
  'weight': piece.weightMg,
  'karat': piece.karatHundredths,
  'owner': piece.owner,
  'purchaseDay': piece.purchaseDay,
  'purchase': piece.purchaseMinor == null
      ? null
      : [piece.purchaseMinor, piece.purchaseCurrency],
  'notes': piece.notes,
};

Map<String, Object?> _goldSaleDetails(GoldSale? sale) => {
  'saleDay': sale?.saleDay,
  'salePrice': sale?.priceMinor == null
      ? null
      : [sale!.priceMinor, sale.priceCurrency],
};

Map<String, List<Object?>> _goldChanges(
  Map<String, Object?> before,
  Map<String, Object?> after,
) => {
  for (final entry in after.entries)
    if (jsonEncode(before[entry.key]) != jsonEncode(entry.value))
      entry.key: [before[entry.key], entry.value],
};

extension PhysicalGold on Ledger {
  Future<List<GoldItem>> goldInventory() => _db.transaction(() async {
    final sales = {
      for (final sale in await _db.select(_db.goldSales).get())
        sale.pieceId: sale,
    };
    final pieces = await (_db.select(
      _db.goldPieces,
    )..orderBy([(row) => OrderingTerm.desc(row.id)])).get();
    return [for (final piece in pieces) (piece: piece, sale: sales[piece.id])];
  });

  Future<GoldRecord> goldRecord(int pieceId) => _db.transaction(() async {
    final piece = await _goldPiece(pieceId);
    final sale = await _goldSale(pieceId);
    final events =
        await (_db.select(_db.goldEvents)
              ..where((row) => row.pieceId.equals(pieceId))
              ..orderBy([(row) => OrderingTerm.desc(row.id)]))
            .get();
    return (
      item: (piece: piece, sale: sale),
      receipt: sale?.receiptId == null
          ? null
          : await _readIncomeReceipt(sale!.receiptId!),
      events: events,
    );
  });

  Future<int> addGold({
    required String operationId,
    required GoldDetails details,
    required String custodian,
  }) => _db.transaction(() async {
    if (operationId.trim().isEmpty || operationId.length > 200) {
      throw const GoldException(GoldIssue.invalid);
    }
    final holder = _goldPerson(details.owner, custodian);
    final existing = await (_db.select(
      _db.goldPieces,
    )..where((row) => row.creationKey.equals(operationId))).getSingleOrNull();
    final values = await _goldPieceValues(operationId, details, holder);
    if (existing != null) {
      if (_sameGoldPiece(existing, details, holder)) return existing.id;
      throw const GoldException(GoldIssue.stale);
    }
    final id = await _db.into(_db.goldPieces).insert(values);
    await _goldEvent(id, GoldEventKind.added);
    return id;
  });

  Future<void> editGold(GoldPiece expected, GoldDetails details) =>
      _db.transaction(() async {
        final current = await _goldPiece(expected.id);
        if (current != expected) throw const GoldException(GoldIssue.stale);
        final sale = await _goldSale(current.id);
        if (details.purchaseDay != null &&
            sale != null &&
            details.purchaseDay! > sale.saleDay) {
          throw const GoldException(GoldIssue.invalid);
        }
        final holder = _goldPerson(details.owner, current.custodian);
        final values = await _goldPieceValues(
          current.creationKey,
          details,
          holder,
        );
        if (_sameGoldPiece(current, details, holder)) return;
        await (_db.update(
          _db.goldPieces,
        )..where((row) => row.id.equals(current.id))).write(values);
        final changes = _goldChanges(
          _goldDetails(current),
          _goldDetails(await _goldPiece(current.id)),
        );
        await _goldEvent(current.id, GoldEventKind.edited, changes: changes);
      });

  Future<void> moveGold(GoldPiece expected, String custodian) =>
      _db.transaction(() async {
        final current = await _goldPiece(expected.id);
        if (await _goldSale(current.id) != null) {
          throw const GoldException(GoldIssue.sold);
        }
        final holder = _goldPerson(current.owner, custodian);
        if (holder == current.custodian) return;
        if (current != expected) throw const GoldException(GoldIssue.stale);
        await (_db.update(_db.goldPieces)
              ..where((row) => row.id.equals(current.id)))
            .write(GoldPiecesCompanion(custodian: Value(holder)));
        await _goldEvent(
          current.id,
          GoldEventKind.moved,
          changes: {
            'custodian': [current.custodian, holder],
          },
        );
      });

  Future<void> saveGoldSale({
    required int pieceId,
    required GoldSale? expected,
    required int saleDay,
    GoldPurchase? price,
  }) => _db.transaction(() async {
    final piece = await _goldPiece(pieceId);
    if (!_pastGoldDay(saleDay) ||
        (piece.purchaseDay != null && saleDay < piece.purchaseDay!)) {
      throw const GoldException(GoldIssue.invalid);
    }
    await _checkGoldPrice(price);
    final current = await _goldSale(pieceId);
    final sale = GoldSale(
      pieceId: pieceId,
      saleDay: saleDay,
      priceMinor: price?.minor,
      priceCurrency: price?.currency,
      receiptId: current?.receiptId,
      receiptRevision: current?.receiptRevision ?? 0,
    );
    if (current == sale) return;
    if (current != expected) throw const GoldException(GoldIssue.stale);
    await _db
        .into(_db.goldSales)
        .insertOnConflictUpdate(sale.toCompanion(false));
    await _goldEvent(
      pieceId,
      current == null ? GoldEventKind.sold : GoldEventKind.saleEdited,
      changes: _goldChanges(_goldSaleDetails(current), _goldSaleDetails(sale)),
    );
  });

  Future<void> confirmGoldReceipt({
    required int pieceId,
    required int expectedRevision,
    required IncomeReceipt? receipt,
    String? reason,
  }) => _db.transaction(() async {
    final sale = await _goldSale(pieceId);
    if (sale == null) throw const GoldException(GoldIssue.notSold);
    final originalId = sale.receiptId;
    final active = originalId == null
        ? null
        : await _readIncomeReceipt(originalId);
    if (sale.receiptRevision == expectedRevision + 1 && active == receipt) {
      return;
    }
    if (sale.receiptRevision != expectedRevision) {
      throw const GoldException(GoldIssue.stale);
    }
    if (active == receipt) return;
    final key = 't015-gold:$pieceId:$expectedRevision';
    final explanation = originalId == null ? null : _reason(reason ?? '');
    final reverseId = originalId == null
        ? null
        : await _reverseManagedIncome('$key:reverse', originalId, explanation!);
    final replacement = receipt == null
        ? null
        : await _postManagedIncome(
            '$key:receipt',
            JournalKind.goldSaleIncome,
            receipt,
            correctionOf: originalId,
            reason: explanation,
          );

    await (_db.update(
      _db.goldSales,
    )..where((row) => row.pieceId.equals(pieceId))).write(
      GoldSalesCompanion(
        receiptId: Value(replacement),
        receiptRevision: Value(expectedRevision + 1),
      ),
    );
    await _goldEvent(
      pieceId,
      originalId == null
          ? GoldEventKind.received
          : receipt == null
          ? GoldEventKind.receiptReversed
          : GoldEventKind.receiptCorrected,
      journalId: replacement ?? reverseId,
    );
  });

  Future<GoldPiece> _goldPiece(int id) async {
    final piece = await (_db.select(
      _db.goldPieces,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (piece == null) throw const GoldException(GoldIssue.missing);
    return piece;
  }

  Future<GoldSale?> _goldSale(int id) => (_db.select(
    _db.goldSales,
  )..where((row) => row.pieceId.equals(id))).getSingleOrNull();

  String _goldPerson(String owner, String custodian) {
    final holder = custodian.trim();
    if (holder.isEmpty || holder.length > 100) {
      throw const GoldException(GoldIssue.invalid);
    }
    if (holder.toLowerCase() == owner.trim().toLowerCase()) {
      throw const GoldException(GoldIssue.samePerson);
    }
    return holder;
  }

  Future<void> _checkGoldPrice(GoldPurchase? price) async {
    if (price == null) return;
    if (price.minor < 0 ||
        await (_db.select(_db.currencies)
                  ..where((row) => row.code.equals(price.currency)))
                .getSingleOrNull() ==
            null) {
      throw const GoldException(GoldIssue.invalid);
    }
  }

  bool _sameGoldPiece(GoldPiece piece, GoldDetails details, String holder) =>
      piece.label == details.label.trim() &&
      piece.kind == details.kind &&
      piece.weightMg == details.weightMg &&
      piece.karatHundredths == details.karatHundredths &&
      piece.owner == details.owner.trim() &&
      piece.custodian == holder &&
      piece.purchaseDay == details.purchaseDay &&
      piece.purchaseMinor == details.purchase?.minor &&
      piece.purchaseCurrency == details.purchase?.currency &&
      (piece.notes ?? '') == (details.notes ?? '').trim();

  Future<GoldPiecesCompanion> _goldPieceValues(
    String creationKey,
    GoldDetails details,
    String holder,
  ) async {
    final label = details.label.trim();
    final owner = details.owner.trim();
    final notes = (details.notes ?? '').trim();
    if (label.isEmpty ||
        label.length > 120 ||
        owner.isEmpty ||
        owner.length > 100 ||
        notes.length > 500 ||
        details.weightMg <= 0 ||
        details.karatHundredths < 1 ||
        details.karatHundredths > 2400 ||
        (details.purchaseDay != null && !_pastGoldDay(details.purchaseDay!))) {
      throw const GoldException(GoldIssue.invalid);
    }
    await _checkGoldPrice(details.purchase);
    return GoldPiecesCompanion.insert(
      creationKey: creationKey,
      label: label,
      kind: details.kind,
      weightMg: details.weightMg,
      karatHundredths: details.karatHundredths,
      owner: owner,
      custodian: holder,
      purchaseDay: Value(details.purchaseDay),
      purchaseMinor: Value(details.purchase?.minor),
      purchaseCurrency: Value(details.purchase?.currency),
      notes: Value(notes.isEmpty ? null : notes),
    );
  }

  Future<void> _goldEvent(
    int pieceId,
    GoldEventKind kind, {
    Map<String, List<Object?>> changes = const {},
    int? journalId,
  }) async {
    await _db
        .into(_db.goldEvents)
        .insert(
          GoldEventsCompanion.insert(
            pieceId: pieceId,
            kind: kind,
            recordedMicros: DateTime.now().microsecondsSinceEpoch,
            changes: jsonEncode(changes),
            journalId: Value(journalId),
          ),
        );
  }
}
