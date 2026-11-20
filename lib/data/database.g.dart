// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CurrenciesTable extends Currencies
    with TableInfo<$CurrenciesTable, Currency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scaleMeta = const VerificationMeta('scale');
  @override
  late final GeneratedColumn<int> scale = GeneratedColumn<int>(
    'scale',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [code, scale];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Currency> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('scale')) {
      context.handle(
        _scaleMeta,
        scale.isAcceptableOrUnknown(data['scale']!, _scaleMeta),
      );
    } else if (isInserting) {
      context.missing(_scaleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Currency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Currency(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      scale: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scale'],
      )!,
    );
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(attachedDatabase, alias);
  }
}

class Currency extends DataClass implements Insertable<Currency> {
  final String code;
  final int scale;
  const Currency({required this.code, required this.scale});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['scale'] = Variable<int>(scale);
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(code: Value(code), scale: Value(scale));
  }

  factory Currency.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Currency(
      code: serializer.fromJson<String>(json['code']),
      scale: serializer.fromJson<int>(json['scale']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'scale': serializer.toJson<int>(scale),
    };
  }

  Currency copyWith({String? code, int? scale}) =>
      Currency(code: code ?? this.code, scale: scale ?? this.scale);
  Currency copyWithCompanion(CurrenciesCompanion data) {
    return Currency(
      code: data.code.present ? data.code.value : this.code,
      scale: data.scale.present ? data.scale.value : this.scale,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('code: $code, ')
          ..write('scale: $scale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, scale);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Currency &&
          other.code == this.code &&
          other.scale == this.scale);
}

class CurrenciesCompanion extends UpdateCompanion<Currency> {
  final Value<String> code;
  final Value<int> scale;
  final Value<int> rowid;
  const CurrenciesCompanion({
    this.code = const Value.absent(),
    this.scale = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    required String code,
    required int scale,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       scale = Value(scale);
  static Insertable<Currency> custom({
    Expression<String>? code,
    Expression<int>? scale,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (scale != null) 'scale': scale,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrenciesCompanion copyWith({
    Value<String>? code,
    Value<int>? scale,
    Value<int>? rowid,
  }) {
    return CurrenciesCompanion(
      code: code ?? this.code,
      scale: scale ?? this.scale,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (scale.present) {
      map['scale'] = Variable<int>(scale.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('code: $code, ')
          ..write('scale: $scale, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LedgerAccountsTable extends LedgerAccounts
    with TableInfo<$LedgerAccountsTable, LedgerAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES currencies (code)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AccountKind>($LedgerAccountsTable.$converterkind);
  @override
  List<GeneratedColumn> get $columns => [id, name, currency, kind];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LedgerAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      kind: $LedgerAccountsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
    );
  }

  @override
  $LedgerAccountsTable createAlias(String alias) {
    return $LedgerAccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountKind, String, String> $converterkind =
      const EnumNameConverter<AccountKind>(AccountKind.values);
}

class LedgerAccount extends DataClass implements Insertable<LedgerAccount> {
  final int id;
  final String name;
  final String currency;
  final AccountKind kind;
  const LedgerAccount({
    required this.id,
    required this.name,
    required this.currency,
    required this.kind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['currency'] = Variable<String>(currency);
    {
      map['kind'] = Variable<String>(
        $LedgerAccountsTable.$converterkind.toSql(kind),
      );
    }
    return map;
  }

  LedgerAccountsCompanion toCompanion(bool nullToAbsent) {
    return LedgerAccountsCompanion(
      id: Value(id),
      name: Value(name),
      currency: Value(currency),
      kind: Value(kind),
    );
  }

  factory LedgerAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerAccount(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      currency: serializer.fromJson<String>(json['currency']),
      kind: $LedgerAccountsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'currency': serializer.toJson<String>(currency),
      'kind': serializer.toJson<String>(
        $LedgerAccountsTable.$converterkind.toJson(kind),
      ),
    };
  }

  LedgerAccount copyWith({
    int? id,
    String? name,
    String? currency,
    AccountKind? kind,
  }) => LedgerAccount(
    id: id ?? this.id,
    name: name ?? this.name,
    currency: currency ?? this.currency,
    kind: kind ?? this.kind,
  );
  LedgerAccount copyWithCompanion(LedgerAccountsCompanion data) {
    return LedgerAccount(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      currency: data.currency.present ? data.currency.value : this.currency,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerAccount(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currency: $currency, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, currency, kind);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerAccount &&
          other.id == this.id &&
          other.name == this.name &&
          other.currency == this.currency &&
          other.kind == this.kind);
}

class LedgerAccountsCompanion extends UpdateCompanion<LedgerAccount> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> currency;
  final Value<AccountKind> kind;
  const LedgerAccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.currency = const Value.absent(),
    this.kind = const Value.absent(),
  });
  LedgerAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String currency,
    required AccountKind kind,
  }) : name = Value(name),
       currency = Value(currency),
       kind = Value(kind);
  static Insertable<LedgerAccount> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? currency,
    Expression<String>? kind,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (currency != null) 'currency': currency,
      if (kind != null) 'kind': kind,
    });
  }

  LedgerAccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? currency,
    Value<AccountKind>? kind,
  }) {
    return LedgerAccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      kind: kind ?? this.kind,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $LedgerAccountsTable.$converterkind.toSql(kind.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerAccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currency: $currency, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<JournalKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<JournalKind>($JournalEntriesTable.$converterkind);
  static const VerificationMeta _effectiveMicrosMeta = const VerificationMeta(
    'effectiveMicros',
  );
  @override
  late final GeneratedColumn<int> effectiveMicros = GeneratedColumn<int>(
    'effective_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingAccountIdMeta = const VerificationMeta(
    'openingAccountId',
  );
  @override
  late final GeneratedColumn<int> openingAccountId = GeneratedColumn<int>(
    'opening_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES ledger_accounts (id)',
    ),
  );
  static const VerificationMeta _reversalOfMeta = const VerificationMeta(
    'reversalOf',
  );
  @override
  late final GeneratedColumn<int> reversalOf = GeneratedColumn<int>(
    'reversal_of',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES journal_entries (id)',
    ),
  );
  static const VerificationMeta _correctionOfMeta = const VerificationMeta(
    'correctionOf',
  );
  @override
  late final GeneratedColumn<int> correctionOf = GeneratedColumn<int>(
    'correction_of',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES journal_entries (id)',
    ),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operationId,
    kind,
    effectiveMicros,
    openingAccountId,
    reversalOf,
    correctionOf,
    reason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('effective_micros')) {
      context.handle(
        _effectiveMicrosMeta,
        effectiveMicros.isAcceptableOrUnknown(
          data['effective_micros']!,
          _effectiveMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveMicrosMeta);
    }
    if (data.containsKey('opening_account_id')) {
      context.handle(
        _openingAccountIdMeta,
        openingAccountId.isAcceptableOrUnknown(
          data['opening_account_id']!,
          _openingAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('reversal_of')) {
      context.handle(
        _reversalOfMeta,
        reversalOf.isAcceptableOrUnknown(data['reversal_of']!, _reversalOfMeta),
      );
    }
    if (data.containsKey('correction_of')) {
      context.handle(
        _correctionOfMeta,
        correctionOf.isAcceptableOrUnknown(
          data['correction_of']!,
          _correctionOfMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      kind: $JournalEntriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      effectiveMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}effective_micros'],
      )!,
      openingAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_account_id'],
      ),
      reversalOf: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reversal_of'],
      ),
      correctionOf: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correction_of'],
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<JournalKind, String, String> $converterkind =
      const EnumNameConverter<JournalKind>(JournalKind.values);
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final int id;
  final String operationId;
  final JournalKind kind;
  final int effectiveMicros;
  final int? openingAccountId;
  final int? reversalOf;
  final int? correctionOf;
  final String? reason;
  const JournalEntry({
    required this.id,
    required this.operationId,
    required this.kind,
    required this.effectiveMicros,
    this.openingAccountId,
    this.reversalOf,
    this.correctionOf,
    this.reason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation_id'] = Variable<String>(operationId);
    {
      map['kind'] = Variable<String>(
        $JournalEntriesTable.$converterkind.toSql(kind),
      );
    }
    map['effective_micros'] = Variable<int>(effectiveMicros);
    if (!nullToAbsent || openingAccountId != null) {
      map['opening_account_id'] = Variable<int>(openingAccountId);
    }
    if (!nullToAbsent || reversalOf != null) {
      map['reversal_of'] = Variable<int>(reversalOf);
    }
    if (!nullToAbsent || correctionOf != null) {
      map['correction_of'] = Variable<int>(correctionOf);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      operationId: Value(operationId),
      kind: Value(kind),
      effectiveMicros: Value(effectiveMicros),
      openingAccountId: openingAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(openingAccountId),
      reversalOf: reversalOf == null && nullToAbsent
          ? const Value.absent()
          : Value(reversalOf),
      correctionOf: correctionOf == null && nullToAbsent
          ? const Value.absent()
          : Value(correctionOf),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
    );
  }

  factory JournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      operationId: serializer.fromJson<String>(json['operationId']),
      kind: $JournalEntriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      effectiveMicros: serializer.fromJson<int>(json['effectiveMicros']),
      openingAccountId: serializer.fromJson<int?>(json['openingAccountId']),
      reversalOf: serializer.fromJson<int?>(json['reversalOf']),
      correctionOf: serializer.fromJson<int?>(json['correctionOf']),
      reason: serializer.fromJson<String?>(json['reason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operationId': serializer.toJson<String>(operationId),
      'kind': serializer.toJson<String>(
        $JournalEntriesTable.$converterkind.toJson(kind),
      ),
      'effectiveMicros': serializer.toJson<int>(effectiveMicros),
      'openingAccountId': serializer.toJson<int?>(openingAccountId),
      'reversalOf': serializer.toJson<int?>(reversalOf),
      'correctionOf': serializer.toJson<int?>(correctionOf),
      'reason': serializer.toJson<String?>(reason),
    };
  }

  JournalEntry copyWith({
    int? id,
    String? operationId,
    JournalKind? kind,
    int? effectiveMicros,
    Value<int?> openingAccountId = const Value.absent(),
    Value<int?> reversalOf = const Value.absent(),
    Value<int?> correctionOf = const Value.absent(),
    Value<String?> reason = const Value.absent(),
  }) => JournalEntry(
    id: id ?? this.id,
    operationId: operationId ?? this.operationId,
    kind: kind ?? this.kind,
    effectiveMicros: effectiveMicros ?? this.effectiveMicros,
    openingAccountId: openingAccountId.present
        ? openingAccountId.value
        : this.openingAccountId,
    reversalOf: reversalOf.present ? reversalOf.value : this.reversalOf,
    correctionOf: correctionOf.present ? correctionOf.value : this.correctionOf,
    reason: reason.present ? reason.value : this.reason,
  );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      kind: data.kind.present ? data.kind.value : this.kind,
      effectiveMicros: data.effectiveMicros.present
          ? data.effectiveMicros.value
          : this.effectiveMicros,
      openingAccountId: data.openingAccountId.present
          ? data.openingAccountId.value
          : this.openingAccountId,
      reversalOf: data.reversalOf.present
          ? data.reversalOf.value
          : this.reversalOf,
      correctionOf: data.correctionOf.present
          ? data.correctionOf.value
          : this.correctionOf,
      reason: data.reason.present ? data.reason.value : this.reason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('operationId: $operationId, ')
          ..write('kind: $kind, ')
          ..write('effectiveMicros: $effectiveMicros, ')
          ..write('openingAccountId: $openingAccountId, ')
          ..write('reversalOf: $reversalOf, ')
          ..write('correctionOf: $correctionOf, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    operationId,
    kind,
    effectiveMicros,
    openingAccountId,
    reversalOf,
    correctionOf,
    reason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.operationId == this.operationId &&
          other.kind == this.kind &&
          other.effectiveMicros == this.effectiveMicros &&
          other.openingAccountId == this.openingAccountId &&
          other.reversalOf == this.reversalOf &&
          other.correctionOf == this.correctionOf &&
          other.reason == this.reason);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String> operationId;
  final Value<JournalKind> kind;
  final Value<int> effectiveMicros;
  final Value<int?> openingAccountId;
  final Value<int?> reversalOf;
  final Value<int?> correctionOf;
  final Value<String?> reason;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.operationId = const Value.absent(),
    this.kind = const Value.absent(),
    this.effectiveMicros = const Value.absent(),
    this.openingAccountId = const Value.absent(),
    this.reversalOf = const Value.absent(),
    this.correctionOf = const Value.absent(),
    this.reason = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String operationId,
    required JournalKind kind,
    required int effectiveMicros,
    this.openingAccountId = const Value.absent(),
    this.reversalOf = const Value.absent(),
    this.correctionOf = const Value.absent(),
    this.reason = const Value.absent(),
  }) : operationId = Value(operationId),
       kind = Value(kind),
       effectiveMicros = Value(effectiveMicros);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? operationId,
    Expression<String>? kind,
    Expression<int>? effectiveMicros,
    Expression<int>? openingAccountId,
    Expression<int>? reversalOf,
    Expression<int>? correctionOf,
    Expression<String>? reason,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operationId != null) 'operation_id': operationId,
      if (kind != null) 'kind': kind,
      if (effectiveMicros != null) 'effective_micros': effectiveMicros,
      if (openingAccountId != null) 'opening_account_id': openingAccountId,
      if (reversalOf != null) 'reversal_of': reversalOf,
      if (correctionOf != null) 'correction_of': correctionOf,
      if (reason != null) 'reason': reason,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? operationId,
    Value<JournalKind>? kind,
    Value<int>? effectiveMicros,
    Value<int?>? openingAccountId,
    Value<int?>? reversalOf,
    Value<int?>? correctionOf,
    Value<String?>? reason,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      operationId: operationId ?? this.operationId,
      kind: kind ?? this.kind,
      effectiveMicros: effectiveMicros ?? this.effectiveMicros,
      openingAccountId: openingAccountId ?? this.openingAccountId,
      reversalOf: reversalOf ?? this.reversalOf,
      correctionOf: correctionOf ?? this.correctionOf,
      reason: reason ?? this.reason,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $JournalEntriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (effectiveMicros.present) {
      map['effective_micros'] = Variable<int>(effectiveMicros.value);
    }
    if (openingAccountId.present) {
      map['opening_account_id'] = Variable<int>(openingAccountId.value);
    }
    if (reversalOf.present) {
      map['reversal_of'] = Variable<int>(reversalOf.value);
    }
    if (correctionOf.present) {
      map['correction_of'] = Variable<int>(correctionOf.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('operationId: $operationId, ')
          ..write('kind: $kind, ')
          ..write('effectiveMicros: $effectiveMicros, ')
          ..write('openingAccountId: $openingAccountId, ')
          ..write('reversalOf: $reversalOf, ')
          ..write('correctionOf: $correctionOf, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }
}

class $JournalPostingsTable extends JournalPostings
    with TableInfo<$JournalPostingsTable, JournalPosting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalPostingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id)',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_accounts (id)',
    ),
  );
  static const VerificationMeta _minorMeta = const VerificationMeta('minor');
  @override
  late final GeneratedColumn<int> minor = GeneratedColumn<int>(
    'minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [entryId, accountId, minor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_postings';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalPosting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('minor')) {
      context.handle(
        _minorMeta,
        minor.isAcceptableOrUnknown(data['minor']!, _minorMeta),
      );
    } else if (isInserting) {
      context.missing(_minorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId, accountId};
  @override
  JournalPosting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalPosting(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      minor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minor'],
      )!,
    );
  }

  @override
  $JournalPostingsTable createAlias(String alias) {
    return $JournalPostingsTable(attachedDatabase, alias);
  }
}

class JournalPosting extends DataClass implements Insertable<JournalPosting> {
  final int entryId;
  final int accountId;
  final int minor;
  const JournalPosting({
    required this.entryId,
    required this.accountId,
    required this.minor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<int>(entryId);
    map['account_id'] = Variable<int>(accountId);
    map['minor'] = Variable<int>(minor);
    return map;
  }

  JournalPostingsCompanion toCompanion(bool nullToAbsent) {
    return JournalPostingsCompanion(
      entryId: Value(entryId),
      accountId: Value(accountId),
      minor: Value(minor),
    );
  }

  factory JournalPosting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalPosting(
      entryId: serializer.fromJson<int>(json['entryId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      minor: serializer.fromJson<int>(json['minor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<int>(entryId),
      'accountId': serializer.toJson<int>(accountId),
      'minor': serializer.toJson<int>(minor),
    };
  }

  JournalPosting copyWith({int? entryId, int? accountId, int? minor}) =>
      JournalPosting(
        entryId: entryId ?? this.entryId,
        accountId: accountId ?? this.accountId,
        minor: minor ?? this.minor,
      );
  JournalPosting copyWithCompanion(JournalPostingsCompanion data) {
    return JournalPosting(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      minor: data.minor.present ? data.minor.value : this.minor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalPosting(')
          ..write('entryId: $entryId, ')
          ..write('accountId: $accountId, ')
          ..write('minor: $minor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entryId, accountId, minor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalPosting &&
          other.entryId == this.entryId &&
          other.accountId == this.accountId &&
          other.minor == this.minor);
}

class JournalPostingsCompanion extends UpdateCompanion<JournalPosting> {
  final Value<int> entryId;
  final Value<int> accountId;
  final Value<int> minor;
  final Value<int> rowid;
  const JournalPostingsCompanion({
    this.entryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.minor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalPostingsCompanion.insert({
    required int entryId,
    required int accountId,
    required int minor,
    this.rowid = const Value.absent(),
  }) : entryId = Value(entryId),
       accountId = Value(accountId),
       minor = Value(minor);
  static Insertable<JournalPosting> custom({
    Expression<int>? entryId,
    Expression<int>? accountId,
    Expression<int>? minor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (accountId != null) 'account_id': accountId,
      if (minor != null) 'minor': minor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalPostingsCompanion copyWith({
    Value<int>? entryId,
    Value<int>? accountId,
    Value<int>? minor,
    Value<int>? rowid,
  }) {
    return JournalPostingsCompanion(
      entryId: entryId ?? this.entryId,
      accountId: accountId ?? this.accountId,
      minor: minor ?? this.minor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (minor.present) {
      map['minor'] = Variable<int>(minor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalPostingsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('accountId: $accountId, ')
          ..write('minor: $minor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalaryReceiptsTable extends SalaryReceipts
    with TableInfo<$SalaryReceiptsTable, SalaryReceipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalaryReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id)',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_accounts (id)',
    ),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [entryId, accountId, reference];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'salary_receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalaryReceipt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {accountId, reference},
  ];
  @override
  SalaryReceipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalaryReceipt(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
    );
  }

  @override
  $SalaryReceiptsTable createAlias(String alias) {
    return $SalaryReceiptsTable(attachedDatabase, alias);
  }
}

class SalaryReceipt extends DataClass implements Insertable<SalaryReceipt> {
  final int entryId;
  final int accountId;
  final String? reference;
  const SalaryReceipt({
    required this.entryId,
    required this.accountId,
    this.reference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<int>(entryId);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    return map;
  }

  SalaryReceiptsCompanion toCompanion(bool nullToAbsent) {
    return SalaryReceiptsCompanion(
      entryId: Value(entryId),
      accountId: Value(accountId),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
    );
  }

  factory SalaryReceipt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalaryReceipt(
      entryId: serializer.fromJson<int>(json['entryId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      reference: serializer.fromJson<String?>(json['reference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<int>(entryId),
      'accountId': serializer.toJson<int>(accountId),
      'reference': serializer.toJson<String?>(reference),
    };
  }

  SalaryReceipt copyWith({
    int? entryId,
    int? accountId,
    Value<String?> reference = const Value.absent(),
  }) => SalaryReceipt(
    entryId: entryId ?? this.entryId,
    accountId: accountId ?? this.accountId,
    reference: reference.present ? reference.value : this.reference,
  );
  SalaryReceipt copyWithCompanion(SalaryReceiptsCompanion data) {
    return SalaryReceipt(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      reference: data.reference.present ? data.reference.value : this.reference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalaryReceipt(')
          ..write('entryId: $entryId, ')
          ..write('accountId: $accountId, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entryId, accountId, reference);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalaryReceipt &&
          other.entryId == this.entryId &&
          other.accountId == this.accountId &&
          other.reference == this.reference);
}

class SalaryReceiptsCompanion extends UpdateCompanion<SalaryReceipt> {
  final Value<int> entryId;
  final Value<int> accountId;
  final Value<String?> reference;
  const SalaryReceiptsCompanion({
    this.entryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.reference = const Value.absent(),
  });
  SalaryReceiptsCompanion.insert({
    this.entryId = const Value.absent(),
    required int accountId,
    this.reference = const Value.absent(),
  }) : accountId = Value(accountId);
  static Insertable<SalaryReceipt> custom({
    Expression<int>? entryId,
    Expression<int>? accountId,
    Expression<String>? reference,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (accountId != null) 'account_id': accountId,
      if (reference != null) 'reference': reference,
    });
  }

  SalaryReceiptsCompanion copyWith({
    Value<int>? entryId,
    Value<int>? accountId,
    Value<String?>? reference,
  }) {
    return SalaryReceiptsCompanion(
      entryId: entryId ?? this.entryId,
      accountId: accountId ?? this.accountId,
      reference: reference ?? this.reference,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalaryReceiptsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('accountId: $accountId, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }
}

class $SalaryPlansTable extends SalaryPlans
    with TableInfo<$SalaryPlansTable, SalaryPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalaryPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _salaryIdMeta = const VerificationMeta(
    'salaryId',
  );
  @override
  late final GeneratedColumn<int> salaryId = GeneratedColumn<int>(
    'salary_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES salary_receipts (entry_id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [salaryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'salary_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalaryPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('salary_id')) {
      context.handle(
        _salaryIdMeta,
        salaryId.isAcceptableOrUnknown(data['salary_id']!, _salaryIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {salaryId};
  @override
  SalaryPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalaryPlan(
      salaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}salary_id'],
      )!,
    );
  }

  @override
  $SalaryPlansTable createAlias(String alias) {
    return $SalaryPlansTable(attachedDatabase, alias);
  }
}

class SalaryPlan extends DataClass implements Insertable<SalaryPlan> {
  final int salaryId;
  const SalaryPlan({required this.salaryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['salary_id'] = Variable<int>(salaryId);
    return map;
  }

  SalaryPlansCompanion toCompanion(bool nullToAbsent) {
    return SalaryPlansCompanion(salaryId: Value(salaryId));
  }

  factory SalaryPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalaryPlan(salaryId: serializer.fromJson<int>(json['salaryId']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'salaryId': serializer.toJson<int>(salaryId)};
  }

  SalaryPlan copyWith({int? salaryId}) =>
      SalaryPlan(salaryId: salaryId ?? this.salaryId);
  SalaryPlan copyWithCompanion(SalaryPlansCompanion data) {
    return SalaryPlan(
      salaryId: data.salaryId.present ? data.salaryId.value : this.salaryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalaryPlan(')
          ..write('salaryId: $salaryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => salaryId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalaryPlan && other.salaryId == this.salaryId);
}

class SalaryPlansCompanion extends UpdateCompanion<SalaryPlan> {
  final Value<int> salaryId;
  const SalaryPlansCompanion({this.salaryId = const Value.absent()});
  SalaryPlansCompanion.insert({this.salaryId = const Value.absent()});
  static Insertable<SalaryPlan> custom({Expression<int>? salaryId}) {
    return RawValuesInsertable({if (salaryId != null) 'salary_id': salaryId});
  }

  SalaryPlansCompanion copyWith({Value<int>? salaryId}) {
    return SalaryPlansCompanion(salaryId: salaryId ?? this.salaryId);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (salaryId.present) {
      map['salary_id'] = Variable<int>(salaryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalaryPlansCompanion(')
          ..write('salaryId: $salaryId')
          ..write(')'))
        .toString();
  }
}

class $SalaryAllocationsTable extends SalaryAllocations
    with TableInfo<$SalaryAllocationsTable, SalaryAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalaryAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _salaryIdMeta = const VerificationMeta(
    'salaryId',
  );
  @override
  late final GeneratedColumn<int> salaryId = GeneratedColumn<int>(
    'salary_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES salary_plans (salary_id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedMinorMeta = const VerificationMeta(
    'plannedMinor',
  );
  @override
  late final GeneratedColumn<int> plannedMinor = GeneratedColumn<int>(
    'planned_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, salaryId, label, plannedMinor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'salary_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalaryAllocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('salary_id')) {
      context.handle(
        _salaryIdMeta,
        salaryId.isAcceptableOrUnknown(data['salary_id']!, _salaryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_salaryIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('planned_minor')) {
      context.handle(
        _plannedMinorMeta,
        plannedMinor.isAcceptableOrUnknown(
          data['planned_minor']!,
          _plannedMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalaryAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalaryAllocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      salaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}salary_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      plannedMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_minor'],
      )!,
    );
  }

  @override
  $SalaryAllocationsTable createAlias(String alias) {
    return $SalaryAllocationsTable(attachedDatabase, alias);
  }
}

class SalaryAllocation extends DataClass
    implements Insertable<SalaryAllocation> {
  final int id;
  final int salaryId;
  final String label;
  final int plannedMinor;
  const SalaryAllocation({
    required this.id,
    required this.salaryId,
    required this.label,
    required this.plannedMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['salary_id'] = Variable<int>(salaryId);
    map['label'] = Variable<String>(label);
    map['planned_minor'] = Variable<int>(plannedMinor);
    return map;
  }

  SalaryAllocationsCompanion toCompanion(bool nullToAbsent) {
    return SalaryAllocationsCompanion(
      id: Value(id),
      salaryId: Value(salaryId),
      label: Value(label),
      plannedMinor: Value(plannedMinor),
    );
  }

  factory SalaryAllocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalaryAllocation(
      id: serializer.fromJson<int>(json['id']),
      salaryId: serializer.fromJson<int>(json['salaryId']),
      label: serializer.fromJson<String>(json['label']),
      plannedMinor: serializer.fromJson<int>(json['plannedMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'salaryId': serializer.toJson<int>(salaryId),
      'label': serializer.toJson<String>(label),
      'plannedMinor': serializer.toJson<int>(plannedMinor),
    };
  }

  SalaryAllocation copyWith({
    int? id,
    int? salaryId,
    String? label,
    int? plannedMinor,
  }) => SalaryAllocation(
    id: id ?? this.id,
    salaryId: salaryId ?? this.salaryId,
    label: label ?? this.label,
    plannedMinor: plannedMinor ?? this.plannedMinor,
  );
  SalaryAllocation copyWithCompanion(SalaryAllocationsCompanion data) {
    return SalaryAllocation(
      id: data.id.present ? data.id.value : this.id,
      salaryId: data.salaryId.present ? data.salaryId.value : this.salaryId,
      label: data.label.present ? data.label.value : this.label,
      plannedMinor: data.plannedMinor.present
          ? data.plannedMinor.value
          : this.plannedMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalaryAllocation(')
          ..write('id: $id, ')
          ..write('salaryId: $salaryId, ')
          ..write('label: $label, ')
          ..write('plannedMinor: $plannedMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, salaryId, label, plannedMinor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalaryAllocation &&
          other.id == this.id &&
          other.salaryId == this.salaryId &&
          other.label == this.label &&
          other.plannedMinor == this.plannedMinor);
}

class SalaryAllocationsCompanion extends UpdateCompanion<SalaryAllocation> {
  final Value<int> id;
  final Value<int> salaryId;
  final Value<String> label;
  final Value<int> plannedMinor;
  const SalaryAllocationsCompanion({
    this.id = const Value.absent(),
    this.salaryId = const Value.absent(),
    this.label = const Value.absent(),
    this.plannedMinor = const Value.absent(),
  });
  SalaryAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int salaryId,
    required String label,
    required int plannedMinor,
  }) : salaryId = Value(salaryId),
       label = Value(label),
       plannedMinor = Value(plannedMinor);
  static Insertable<SalaryAllocation> custom({
    Expression<int>? id,
    Expression<int>? salaryId,
    Expression<String>? label,
    Expression<int>? plannedMinor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (salaryId != null) 'salary_id': salaryId,
      if (label != null) 'label': label,
      if (plannedMinor != null) 'planned_minor': plannedMinor,
    });
  }

  SalaryAllocationsCompanion copyWith({
    Value<int>? id,
    Value<int>? salaryId,
    Value<String>? label,
    Value<int>? plannedMinor,
  }) {
    return SalaryAllocationsCompanion(
      id: id ?? this.id,
      salaryId: salaryId ?? this.salaryId,
      label: label ?? this.label,
      plannedMinor: plannedMinor ?? this.plannedMinor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (salaryId.present) {
      map['salary_id'] = Variable<int>(salaryId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (plannedMinor.present) {
      map['planned_minor'] = Variable<int>(plannedMinor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalaryAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('salaryId: $salaryId, ')
          ..write('label: $label, ')
          ..write('plannedMinor: $plannedMinor')
          ..write(')'))
        .toString();
  }
}

class $SalaryExecutionsTable extends SalaryExecutions
    with TableInfo<$SalaryExecutionsTable, SalaryExecution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalaryExecutionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _allocationIdMeta = const VerificationMeta(
    'allocationId',
  );
  @override
  late final GeneratedColumn<int> allocationId = GeneratedColumn<int>(
    'allocation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES salary_allocations (id)',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id)',
    ),
  );
  static const VerificationMeta _minorMeta = const VerificationMeta('minor');
  @override
  late final GeneratedColumn<int> minor = GeneratedColumn<int>(
    'minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [allocationId, entryId, minor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'salary_executions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalaryExecution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('allocation_id')) {
      context.handle(
        _allocationIdMeta,
        allocationId.isAcceptableOrUnknown(
          data['allocation_id']!,
          _allocationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allocationIdMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('minor')) {
      context.handle(
        _minorMeta,
        minor.isAcceptableOrUnknown(data['minor']!, _minorMeta),
      );
    } else if (isInserting) {
      context.missing(_minorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {allocationId, entryId};
  @override
  SalaryExecution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalaryExecution(
      allocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allocation_id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      minor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minor'],
      )!,
    );
  }

  @override
  $SalaryExecutionsTable createAlias(String alias) {
    return $SalaryExecutionsTable(attachedDatabase, alias);
  }
}

class SalaryExecution extends DataClass implements Insertable<SalaryExecution> {
  final int allocationId;
  final int entryId;
  final int minor;
  const SalaryExecution({
    required this.allocationId,
    required this.entryId,
    required this.minor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['allocation_id'] = Variable<int>(allocationId);
    map['entry_id'] = Variable<int>(entryId);
    map['minor'] = Variable<int>(minor);
    return map;
  }

  SalaryExecutionsCompanion toCompanion(bool nullToAbsent) {
    return SalaryExecutionsCompanion(
      allocationId: Value(allocationId),
      entryId: Value(entryId),
      minor: Value(minor),
    );
  }

  factory SalaryExecution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalaryExecution(
      allocationId: serializer.fromJson<int>(json['allocationId']),
      entryId: serializer.fromJson<int>(json['entryId']),
      minor: serializer.fromJson<int>(json['minor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'allocationId': serializer.toJson<int>(allocationId),
      'entryId': serializer.toJson<int>(entryId),
      'minor': serializer.toJson<int>(minor),
    };
  }

  SalaryExecution copyWith({int? allocationId, int? entryId, int? minor}) =>
      SalaryExecution(
        allocationId: allocationId ?? this.allocationId,
        entryId: entryId ?? this.entryId,
        minor: minor ?? this.minor,
      );
  SalaryExecution copyWithCompanion(SalaryExecutionsCompanion data) {
    return SalaryExecution(
      allocationId: data.allocationId.present
          ? data.allocationId.value
          : this.allocationId,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      minor: data.minor.present ? data.minor.value : this.minor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalaryExecution(')
          ..write('allocationId: $allocationId, ')
          ..write('entryId: $entryId, ')
          ..write('minor: $minor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(allocationId, entryId, minor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalaryExecution &&
          other.allocationId == this.allocationId &&
          other.entryId == this.entryId &&
          other.minor == this.minor);
}

class SalaryExecutionsCompanion extends UpdateCompanion<SalaryExecution> {
  final Value<int> allocationId;
  final Value<int> entryId;
  final Value<int> minor;
  final Value<int> rowid;
  const SalaryExecutionsCompanion({
    this.allocationId = const Value.absent(),
    this.entryId = const Value.absent(),
    this.minor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalaryExecutionsCompanion.insert({
    required int allocationId,
    required int entryId,
    required int minor,
    this.rowid = const Value.absent(),
  }) : allocationId = Value(allocationId),
       entryId = Value(entryId),
       minor = Value(minor);
  static Insertable<SalaryExecution> custom({
    Expression<int>? allocationId,
    Expression<int>? entryId,
    Expression<int>? minor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (allocationId != null) 'allocation_id': allocationId,
      if (entryId != null) 'entry_id': entryId,
      if (minor != null) 'minor': minor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalaryExecutionsCompanion copyWith({
    Value<int>? allocationId,
    Value<int>? entryId,
    Value<int>? minor,
    Value<int>? rowid,
  }) {
    return SalaryExecutionsCompanion(
      allocationId: allocationId ?? this.allocationId,
      entryId: entryId ?? this.entryId,
      minor: minor ?? this.minor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (allocationId.present) {
      map['allocation_id'] = Variable<int>(allocationId.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (minor.present) {
      map['minor'] = Variable<int>(minor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalaryExecutionsCompanion(')
          ..write('allocationId: $allocationId, ')
          ..write('entryId: $entryId, ')
          ..write('minor: $minor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MovementConfirmationsTable extends MovementConfirmations
    with TableInfo<$MovementConfirmationsTable, MovementConfirmation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovementConfirmationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id)',
    ),
  );
  static const VerificationMeta _evidenceMeta = const VerificationMeta(
    'evidence',
  );
  @override
  late final GeneratedColumn<String> evidence = GeneratedColumn<String>(
    'evidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confirmedMicrosMeta = const VerificationMeta(
    'confirmedMicros',
  );
  @override
  late final GeneratedColumn<int> confirmedMicros = GeneratedColumn<int>(
    'confirmed_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [entryId, evidence, confirmedMicros];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movement_confirmations';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovementConfirmation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    }
    if (data.containsKey('evidence')) {
      context.handle(
        _evidenceMeta,
        evidence.isAcceptableOrUnknown(data['evidence']!, _evidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_evidenceMeta);
    }
    if (data.containsKey('confirmed_micros')) {
      context.handle(
        _confirmedMicrosMeta,
        confirmedMicros.isAcceptableOrUnknown(
          data['confirmed_micros']!,
          _confirmedMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confirmedMicrosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId};
  @override
  MovementConfirmation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovementConfirmation(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      evidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence'],
      )!,
      confirmedMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confirmed_micros'],
      )!,
    );
  }

  @override
  $MovementConfirmationsTable createAlias(String alias) {
    return $MovementConfirmationsTable(attachedDatabase, alias);
  }
}

class MovementConfirmation extends DataClass
    implements Insertable<MovementConfirmation> {
  final int entryId;
  final String evidence;
  final int confirmedMicros;
  const MovementConfirmation({
    required this.entryId,
    required this.evidence,
    required this.confirmedMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<int>(entryId);
    map['evidence'] = Variable<String>(evidence);
    map['confirmed_micros'] = Variable<int>(confirmedMicros);
    return map;
  }

  MovementConfirmationsCompanion toCompanion(bool nullToAbsent) {
    return MovementConfirmationsCompanion(
      entryId: Value(entryId),
      evidence: Value(evidence),
      confirmedMicros: Value(confirmedMicros),
    );
  }

  factory MovementConfirmation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovementConfirmation(
      entryId: serializer.fromJson<int>(json['entryId']),
      evidence: serializer.fromJson<String>(json['evidence']),
      confirmedMicros: serializer.fromJson<int>(json['confirmedMicros']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<int>(entryId),
      'evidence': serializer.toJson<String>(evidence),
      'confirmedMicros': serializer.toJson<int>(confirmedMicros),
    };
  }

  MovementConfirmation copyWith({
    int? entryId,
    String? evidence,
    int? confirmedMicros,
  }) => MovementConfirmation(
    entryId: entryId ?? this.entryId,
    evidence: evidence ?? this.evidence,
    confirmedMicros: confirmedMicros ?? this.confirmedMicros,
  );
  MovementConfirmation copyWithCompanion(MovementConfirmationsCompanion data) {
    return MovementConfirmation(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      evidence: data.evidence.present ? data.evidence.value : this.evidence,
      confirmedMicros: data.confirmedMicros.present
          ? data.confirmedMicros.value
          : this.confirmedMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovementConfirmation(')
          ..write('entryId: $entryId, ')
          ..write('evidence: $evidence, ')
          ..write('confirmedMicros: $confirmedMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entryId, evidence, confirmedMicros);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovementConfirmation &&
          other.entryId == this.entryId &&
          other.evidence == this.evidence &&
          other.confirmedMicros == this.confirmedMicros);
}

class MovementConfirmationsCompanion
    extends UpdateCompanion<MovementConfirmation> {
  final Value<int> entryId;
  final Value<String> evidence;
  final Value<int> confirmedMicros;
  const MovementConfirmationsCompanion({
    this.entryId = const Value.absent(),
    this.evidence = const Value.absent(),
    this.confirmedMicros = const Value.absent(),
  });
  MovementConfirmationsCompanion.insert({
    this.entryId = const Value.absent(),
    required String evidence,
    required int confirmedMicros,
  }) : evidence = Value(evidence),
       confirmedMicros = Value(confirmedMicros);
  static Insertable<MovementConfirmation> custom({
    Expression<int>? entryId,
    Expression<String>? evidence,
    Expression<int>? confirmedMicros,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (evidence != null) 'evidence': evidence,
      if (confirmedMicros != null) 'confirmed_micros': confirmedMicros,
    });
  }

  MovementConfirmationsCompanion copyWith({
    Value<int>? entryId,
    Value<String>? evidence,
    Value<int>? confirmedMicros,
  }) {
    return MovementConfirmationsCompanion(
      entryId: entryId ?? this.entryId,
      evidence: evidence ?? this.evidence,
      confirmedMicros: confirmedMicros ?? this.confirmedMicros,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (evidence.present) {
      map['evidence'] = Variable<String>(evidence.value);
    }
    if (confirmedMicros.present) {
      map['confirmed_micros'] = Variable<int>(confirmedMicros.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovementConfirmationsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('evidence: $evidence, ')
          ..write('confirmedMicros: $confirmedMicros')
          ..write(')'))
        .toString();
  }
}

class $CashSettingsTable extends CashSettings
    with TableInfo<$CashSettingsTable, CashSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cashAccountIdMeta = const VerificationMeta(
    'cashAccountId',
  );
  @override
  late final GeneratedColumn<int> cashAccountId = GeneratedColumn<int>(
    'cash_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_accounts (id)',
    ),
  );
  static const VerificationMeta _withdrawalLimitMinorMeta =
      const VerificationMeta('withdrawalLimitMinor');
  @override
  late final GeneratedColumn<int> withdrawalLimitMinor = GeneratedColumn<int>(
    'withdrawal_limit_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cashAccountId,
    withdrawalLimitMinor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cash_account_id')) {
      context.handle(
        _cashAccountIdMeta,
        cashAccountId.isAcceptableOrUnknown(
          data['cash_account_id']!,
          _cashAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('withdrawal_limit_minor')) {
      context.handle(
        _withdrawalLimitMinorMeta,
        withdrawalLimitMinor.isAcceptableOrUnknown(
          data['withdrawal_limit_minor']!,
          _withdrawalLimitMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_withdrawalLimitMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cashAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cash_account_id'],
      ),
      withdrawalLimitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}withdrawal_limit_minor'],
      )!,
    );
  }

  @override
  $CashSettingsTable createAlias(String alias) {
    return $CashSettingsTable(attachedDatabase, alias);
  }
}

class CashSetting extends DataClass implements Insertable<CashSetting> {
  final int id;
  final int? cashAccountId;
  final int withdrawalLimitMinor;
  const CashSetting({
    required this.id,
    this.cashAccountId,
    required this.withdrawalLimitMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || cashAccountId != null) {
      map['cash_account_id'] = Variable<int>(cashAccountId);
    }
    map['withdrawal_limit_minor'] = Variable<int>(withdrawalLimitMinor);
    return map;
  }

  CashSettingsCompanion toCompanion(bool nullToAbsent) {
    return CashSettingsCompanion(
      id: Value(id),
      cashAccountId: cashAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(cashAccountId),
      withdrawalLimitMinor: Value(withdrawalLimitMinor),
    );
  }

  factory CashSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashSetting(
      id: serializer.fromJson<int>(json['id']),
      cashAccountId: serializer.fromJson<int?>(json['cashAccountId']),
      withdrawalLimitMinor: serializer.fromJson<int>(
        json['withdrawalLimitMinor'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cashAccountId': serializer.toJson<int?>(cashAccountId),
      'withdrawalLimitMinor': serializer.toJson<int>(withdrawalLimitMinor),
    };
  }

  CashSetting copyWith({
    int? id,
    Value<int?> cashAccountId = const Value.absent(),
    int? withdrawalLimitMinor,
  }) => CashSetting(
    id: id ?? this.id,
    cashAccountId: cashAccountId.present
        ? cashAccountId.value
        : this.cashAccountId,
    withdrawalLimitMinor: withdrawalLimitMinor ?? this.withdrawalLimitMinor,
  );
  CashSetting copyWithCompanion(CashSettingsCompanion data) {
    return CashSetting(
      id: data.id.present ? data.id.value : this.id,
      cashAccountId: data.cashAccountId.present
          ? data.cashAccountId.value
          : this.cashAccountId,
      withdrawalLimitMinor: data.withdrawalLimitMinor.present
          ? data.withdrawalLimitMinor.value
          : this.withdrawalLimitMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashSetting(')
          ..write('id: $id, ')
          ..write('cashAccountId: $cashAccountId, ')
          ..write('withdrawalLimitMinor: $withdrawalLimitMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cashAccountId, withdrawalLimitMinor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashSetting &&
          other.id == this.id &&
          other.cashAccountId == this.cashAccountId &&
          other.withdrawalLimitMinor == this.withdrawalLimitMinor);
}

class CashSettingsCompanion extends UpdateCompanion<CashSetting> {
  final Value<int> id;
  final Value<int?> cashAccountId;
  final Value<int> withdrawalLimitMinor;
  const CashSettingsCompanion({
    this.id = const Value.absent(),
    this.cashAccountId = const Value.absent(),
    this.withdrawalLimitMinor = const Value.absent(),
  });
  CashSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.cashAccountId = const Value.absent(),
    required int withdrawalLimitMinor,
  }) : withdrawalLimitMinor = Value(withdrawalLimitMinor);
  static Insertable<CashSetting> custom({
    Expression<int>? id,
    Expression<int>? cashAccountId,
    Expression<int>? withdrawalLimitMinor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cashAccountId != null) 'cash_account_id': cashAccountId,
      if (withdrawalLimitMinor != null)
        'withdrawal_limit_minor': withdrawalLimitMinor,
    });
  }

  CashSettingsCompanion copyWith({
    Value<int>? id,
    Value<int?>? cashAccountId,
    Value<int>? withdrawalLimitMinor,
  }) {
    return CashSettingsCompanion(
      id: id ?? this.id,
      cashAccountId: cashAccountId ?? this.cashAccountId,
      withdrawalLimitMinor: withdrawalLimitMinor ?? this.withdrawalLimitMinor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cashAccountId.present) {
      map['cash_account_id'] = Variable<int>(cashAccountId.value);
    }
    if (withdrawalLimitMinor.present) {
      map['withdrawal_limit_minor'] = Variable<int>(withdrawalLimitMinor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashSettingsCompanion(')
          ..write('id: $id, ')
          ..write('cashAccountId: $cashAccountId, ')
          ..write('withdrawalLimitMinor: $withdrawalLimitMinor')
          ..write(')'))
        .toString();
  }
}

class $CashReconciliationsTable extends CashReconciliations
    with TableInfo<$CashReconciliationsTable, CashReconciliation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashReconciliationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id)',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_accounts (id)',
    ),
  );
  static const VerificationMeta _priorMinorMeta = const VerificationMeta(
    'priorMinor',
  );
  @override
  late final GeneratedColumn<int> priorMinor = GeneratedColumn<int>(
    'prior_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countedMinorMeta = const VerificationMeta(
    'countedMinor',
  );
  @override
  late final GeneratedColumn<int> countedMinor = GeneratedColumn<int>(
    'counted_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    entryId,
    accountId,
    priorMinor,
    countedMinor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_reconciliations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashReconciliation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('prior_minor')) {
      context.handle(
        _priorMinorMeta,
        priorMinor.isAcceptableOrUnknown(data['prior_minor']!, _priorMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_priorMinorMeta);
    }
    if (data.containsKey('counted_minor')) {
      context.handle(
        _countedMinorMeta,
        countedMinor.isAcceptableOrUnknown(
          data['counted_minor']!,
          _countedMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countedMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId};
  @override
  CashReconciliation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashReconciliation(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      priorMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prior_minor'],
      )!,
      countedMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}counted_minor'],
      )!,
    );
  }

  @override
  $CashReconciliationsTable createAlias(String alias) {
    return $CashReconciliationsTable(attachedDatabase, alias);
  }
}

class CashReconciliation extends DataClass
    implements Insertable<CashReconciliation> {
  final int entryId;
  final int accountId;
  final int priorMinor;
  final int countedMinor;
  const CashReconciliation({
    required this.entryId,
    required this.accountId,
    required this.priorMinor,
    required this.countedMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<int>(entryId);
    map['account_id'] = Variable<int>(accountId);
    map['prior_minor'] = Variable<int>(priorMinor);
    map['counted_minor'] = Variable<int>(countedMinor);
    return map;
  }

  CashReconciliationsCompanion toCompanion(bool nullToAbsent) {
    return CashReconciliationsCompanion(
      entryId: Value(entryId),
      accountId: Value(accountId),
      priorMinor: Value(priorMinor),
      countedMinor: Value(countedMinor),
    );
  }

  factory CashReconciliation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashReconciliation(
      entryId: serializer.fromJson<int>(json['entryId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      priorMinor: serializer.fromJson<int>(json['priorMinor']),
      countedMinor: serializer.fromJson<int>(json['countedMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<int>(entryId),
      'accountId': serializer.toJson<int>(accountId),
      'priorMinor': serializer.toJson<int>(priorMinor),
      'countedMinor': serializer.toJson<int>(countedMinor),
    };
  }

  CashReconciliation copyWith({
    int? entryId,
    int? accountId,
    int? priorMinor,
    int? countedMinor,
  }) => CashReconciliation(
    entryId: entryId ?? this.entryId,
    accountId: accountId ?? this.accountId,
    priorMinor: priorMinor ?? this.priorMinor,
    countedMinor: countedMinor ?? this.countedMinor,
  );
  CashReconciliation copyWithCompanion(CashReconciliationsCompanion data) {
    return CashReconciliation(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      priorMinor: data.priorMinor.present
          ? data.priorMinor.value
          : this.priorMinor,
      countedMinor: data.countedMinor.present
          ? data.countedMinor.value
          : this.countedMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashReconciliation(')
          ..write('entryId: $entryId, ')
          ..write('accountId: $accountId, ')
          ..write('priorMinor: $priorMinor, ')
          ..write('countedMinor: $countedMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entryId, accountId, priorMinor, countedMinor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashReconciliation &&
          other.entryId == this.entryId &&
          other.accountId == this.accountId &&
          other.priorMinor == this.priorMinor &&
          other.countedMinor == this.countedMinor);
}

class CashReconciliationsCompanion extends UpdateCompanion<CashReconciliation> {
  final Value<int> entryId;
  final Value<int> accountId;
  final Value<int> priorMinor;
  final Value<int> countedMinor;
  const CashReconciliationsCompanion({
    this.entryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.priorMinor = const Value.absent(),
    this.countedMinor = const Value.absent(),
  });
  CashReconciliationsCompanion.insert({
    this.entryId = const Value.absent(),
    required int accountId,
    required int priorMinor,
    required int countedMinor,
  }) : accountId = Value(accountId),
       priorMinor = Value(priorMinor),
       countedMinor = Value(countedMinor);
  static Insertable<CashReconciliation> custom({
    Expression<int>? entryId,
    Expression<int>? accountId,
    Expression<int>? priorMinor,
    Expression<int>? countedMinor,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (accountId != null) 'account_id': accountId,
      if (priorMinor != null) 'prior_minor': priorMinor,
      if (countedMinor != null) 'counted_minor': countedMinor,
    });
  }

  CashReconciliationsCompanion copyWith({
    Value<int>? entryId,
    Value<int>? accountId,
    Value<int>? priorMinor,
    Value<int>? countedMinor,
  }) {
    return CashReconciliationsCompanion(
      entryId: entryId ?? this.entryId,
      accountId: accountId ?? this.accountId,
      priorMinor: priorMinor ?? this.priorMinor,
      countedMinor: countedMinor ?? this.countedMinor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (priorMinor.present) {
      map['prior_minor'] = Variable<int>(priorMinor.value);
    }
    if (countedMinor.present) {
      map['counted_minor'] = Variable<int>(countedMinor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashReconciliationsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('accountId: $accountId, ')
          ..write('priorMinor: $priorMinor, ')
          ..write('countedMinor: $countedMinor')
          ..write(')'))
        .toString();
  }
}

class $ExpenseDetailsTable extends ExpenseDetails
    with TableInfo<$ExpenseDetailsTable, ExpenseDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExpensePeriod, String> period =
      GeneratedColumn<String>(
        'period',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ExpensePeriod>($ExpenseDetailsTable.$converterperiod);
  static const VerificationMeta _startDayMeta = const VerificationMeta(
    'startDay',
  );
  @override
  late final GeneratedColumn<int> startDay = GeneratedColumn<int>(
    'start_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExpenseCategory?, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<ExpenseCategory?>($ExpenseDetailsTable.$convertercategoryn);
  @override
  List<GeneratedColumn> get $columns => [entryId, period, startDay, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseDetail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    }
    if (data.containsKey('start_day')) {
      context.handle(
        _startDayMeta,
        startDay.isAcceptableOrUnknown(data['start_day']!, _startDayMeta),
      );
    } else if (isInserting) {
      context.missing(_startDayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId};
  @override
  ExpenseDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseDetail(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      period: $ExpenseDetailsTable.$converterperiod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}period'],
        )!,
      ),
      startDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_day'],
      )!,
      category: $ExpenseDetailsTable.$convertercategoryn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        ),
      ),
    );
  }

  @override
  $ExpenseDetailsTable createAlias(String alias) {
    return $ExpenseDetailsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ExpensePeriod, String, String> $converterperiod =
      const EnumNameConverter<ExpensePeriod>(ExpensePeriod.values);
  static JsonTypeConverter2<ExpenseCategory, String, String>
  $convertercategory = const EnumNameConverter<ExpenseCategory>(
    ExpenseCategory.values,
  );
  static JsonTypeConverter2<ExpenseCategory?, String?, String?>
  $convertercategoryn = JsonTypeConverter2.asNullable($convertercategory);
}

class ExpenseDetail extends DataClass implements Insertable<ExpenseDetail> {
  final int entryId;
  final ExpensePeriod period;
  final int startDay;
  final ExpenseCategory? category;
  const ExpenseDetail({
    required this.entryId,
    required this.period,
    required this.startDay,
    this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<int>(entryId);
    {
      map['period'] = Variable<String>(
        $ExpenseDetailsTable.$converterperiod.toSql(period),
      );
    }
    map['start_day'] = Variable<int>(startDay);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(
        $ExpenseDetailsTable.$convertercategoryn.toSql(category),
      );
    }
    return map;
  }

  ExpenseDetailsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseDetailsCompanion(
      entryId: Value(entryId),
      period: Value(period),
      startDay: Value(startDay),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
    );
  }

  factory ExpenseDetail.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseDetail(
      entryId: serializer.fromJson<int>(json['entryId']),
      period: $ExpenseDetailsTable.$converterperiod.fromJson(
        serializer.fromJson<String>(json['period']),
      ),
      startDay: serializer.fromJson<int>(json['startDay']),
      category: $ExpenseDetailsTable.$convertercategoryn.fromJson(
        serializer.fromJson<String?>(json['category']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<int>(entryId),
      'period': serializer.toJson<String>(
        $ExpenseDetailsTable.$converterperiod.toJson(period),
      ),
      'startDay': serializer.toJson<int>(startDay),
      'category': serializer.toJson<String?>(
        $ExpenseDetailsTable.$convertercategoryn.toJson(category),
      ),
    };
  }

  ExpenseDetail copyWith({
    int? entryId,
    ExpensePeriod? period,
    int? startDay,
    Value<ExpenseCategory?> category = const Value.absent(),
  }) => ExpenseDetail(
    entryId: entryId ?? this.entryId,
    period: period ?? this.period,
    startDay: startDay ?? this.startDay,
    category: category.present ? category.value : this.category,
  );
  ExpenseDetail copyWithCompanion(ExpenseDetailsCompanion data) {
    return ExpenseDetail(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      period: data.period.present ? data.period.value : this.period,
      startDay: data.startDay.present ? data.startDay.value : this.startDay,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseDetail(')
          ..write('entryId: $entryId, ')
          ..write('period: $period, ')
          ..write('startDay: $startDay, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entryId, period, startDay, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseDetail &&
          other.entryId == this.entryId &&
          other.period == this.period &&
          other.startDay == this.startDay &&
          other.category == this.category);
}

class ExpenseDetailsCompanion extends UpdateCompanion<ExpenseDetail> {
  final Value<int> entryId;
  final Value<ExpensePeriod> period;
  final Value<int> startDay;
  final Value<ExpenseCategory?> category;
  const ExpenseDetailsCompanion({
    this.entryId = const Value.absent(),
    this.period = const Value.absent(),
    this.startDay = const Value.absent(),
    this.category = const Value.absent(),
  });
  ExpenseDetailsCompanion.insert({
    this.entryId = const Value.absent(),
    required ExpensePeriod period,
    required int startDay,
    this.category = const Value.absent(),
  }) : period = Value(period),
       startDay = Value(startDay);
  static Insertable<ExpenseDetail> custom({
    Expression<int>? entryId,
    Expression<String>? period,
    Expression<int>? startDay,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (period != null) 'period': period,
      if (startDay != null) 'start_day': startDay,
      if (category != null) 'category': category,
    });
  }

  ExpenseDetailsCompanion copyWith({
    Value<int>? entryId,
    Value<ExpensePeriod>? period,
    Value<int>? startDay,
    Value<ExpenseCategory?>? category,
  }) {
    return ExpenseDetailsCompanion(
      entryId: entryId ?? this.entryId,
      period: period ?? this.period,
      startDay: startDay ?? this.startDay,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(
        $ExpenseDetailsTable.$converterperiod.toSql(period.value),
      );
    }
    if (startDay.present) {
      map['start_day'] = Variable<int>(startDay.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $ExpenseDetailsTable.$convertercategoryn.toSql(category.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseDetailsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('period: $period, ')
          ..write('startDay: $startDay, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $RemittancesTable extends Remittances
    with TableInfo<$RemittancesTable, Remittance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemittancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _draftKeyMeta = const VerificationMeta(
    'draftKey',
  );
  @override
  late final GeneratedColumn<String> draftKey = GeneratedColumn<String>(
    'draft_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _sourceAccountIdMeta = const VerificationMeta(
    'sourceAccountId',
  );
  @override
  late final GeneratedColumn<int> sourceAccountId = GeneratedColumn<int>(
    'source_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_accounts (id)',
    ),
  );
  static const VerificationMeta _destinationAccountIdMeta =
      const VerificationMeta('destinationAccountId');
  @override
  late final GeneratedColumn<int> destinationAccountId = GeneratedColumn<int>(
    'destination_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_accounts (id)',
    ),
  );
  static const VerificationMeta _destinationCurrencyMeta =
      const VerificationMeta('destinationCurrency');
  @override
  late final GeneratedColumn<String> destinationCurrency =
      GeneratedColumn<String>(
        'destination_currency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES currencies (code)',
        ),
      );
  @override
  late final GeneratedColumnWithTypeConverter<RemittanceDestination, String>
  destination =
      GeneratedColumn<String>(
        'destination',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RemittanceDestination>(
        $RemittancesTable.$converterdestination,
      );
  static const VerificationMeta _beneficiaryMeta = const VerificationMeta(
    'beneficiary',
  );
  @override
  late final GeneratedColumn<String> beneficiary = GeneratedColumn<String>(
    'beneficiary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelledMeta = const VerificationMeta(
    'cancelled',
  );
  @override
  late final GeneratedColumn<bool> cancelled = GeneratedColumn<bool>(
    'cancelled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cancelled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _awaitingMeta = const VerificationMeta(
    'awaiting',
  );
  @override
  late final GeneratedColumn<bool> awaiting = GeneratedColumn<bool>(
    'awaiting',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("awaiting" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    draftKey,
    sourceAccountId,
    destinationAccountId,
    destinationCurrency,
    destination,
    beneficiary,
    cancelled,
    awaiting,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'remittances';
  @override
  VerificationContext validateIntegrity(
    Insertable<Remittance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('draft_key')) {
      context.handle(
        _draftKeyMeta,
        draftKey.isAcceptableOrUnknown(data['draft_key']!, _draftKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_draftKeyMeta);
    }
    if (data.containsKey('source_account_id')) {
      context.handle(
        _sourceAccountIdMeta,
        sourceAccountId.isAcceptableOrUnknown(
          data['source_account_id']!,
          _sourceAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceAccountIdMeta);
    }
    if (data.containsKey('destination_account_id')) {
      context.handle(
        _destinationAccountIdMeta,
        destinationAccountId.isAcceptableOrUnknown(
          data['destination_account_id']!,
          _destinationAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('destination_currency')) {
      context.handle(
        _destinationCurrencyMeta,
        destinationCurrency.isAcceptableOrUnknown(
          data['destination_currency']!,
          _destinationCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationCurrencyMeta);
    }
    if (data.containsKey('beneficiary')) {
      context.handle(
        _beneficiaryMeta,
        beneficiary.isAcceptableOrUnknown(
          data['beneficiary']!,
          _beneficiaryMeta,
        ),
      );
    }
    if (data.containsKey('cancelled')) {
      context.handle(
        _cancelledMeta,
        cancelled.isAcceptableOrUnknown(data['cancelled']!, _cancelledMeta),
      );
    }
    if (data.containsKey('awaiting')) {
      context.handle(
        _awaitingMeta,
        awaiting.isAcceptableOrUnknown(data['awaiting']!, _awaitingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Remittance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Remittance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      draftKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}draft_key'],
      )!,
      sourceAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_account_id'],
      )!,
      destinationAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}destination_account_id'],
      ),
      destinationCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_currency'],
      )!,
      destination: $RemittancesTable.$converterdestination.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}destination'],
        )!,
      ),
      beneficiary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}beneficiary'],
      ),
      cancelled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cancelled'],
      )!,
      awaiting: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}awaiting'],
      )!,
    );
  }

  @override
  $RemittancesTable createAlias(String alias) {
    return $RemittancesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RemittanceDestination, String, String>
  $converterdestination = const EnumNameConverter<RemittanceDestination>(
    RemittanceDestination.values,
  );
}

class Remittance extends DataClass implements Insertable<Remittance> {
  final int id;
  final String draftKey;
  final int sourceAccountId;
  final int? destinationAccountId;
  final String destinationCurrency;
  final RemittanceDestination destination;
  final String? beneficiary;
  final bool cancelled;
  final bool awaiting;
  const Remittance({
    required this.id,
    required this.draftKey,
    required this.sourceAccountId,
    this.destinationAccountId,
    required this.destinationCurrency,
    required this.destination,
    this.beneficiary,
    required this.cancelled,
    required this.awaiting,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['draft_key'] = Variable<String>(draftKey);
    map['source_account_id'] = Variable<int>(sourceAccountId);
    if (!nullToAbsent || destinationAccountId != null) {
      map['destination_account_id'] = Variable<int>(destinationAccountId);
    }
    map['destination_currency'] = Variable<String>(destinationCurrency);
    {
      map['destination'] = Variable<String>(
        $RemittancesTable.$converterdestination.toSql(destination),
      );
    }
    if (!nullToAbsent || beneficiary != null) {
      map['beneficiary'] = Variable<String>(beneficiary);
    }
    map['cancelled'] = Variable<bool>(cancelled);
    map['awaiting'] = Variable<bool>(awaiting);
    return map;
  }

  RemittancesCompanion toCompanion(bool nullToAbsent) {
    return RemittancesCompanion(
      id: Value(id),
      draftKey: Value(draftKey),
      sourceAccountId: Value(sourceAccountId),
      destinationAccountId: destinationAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationAccountId),
      destinationCurrency: Value(destinationCurrency),
      destination: Value(destination),
      beneficiary: beneficiary == null && nullToAbsent
          ? const Value.absent()
          : Value(beneficiary),
      cancelled: Value(cancelled),
      awaiting: Value(awaiting),
    );
  }

  factory Remittance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Remittance(
      id: serializer.fromJson<int>(json['id']),
      draftKey: serializer.fromJson<String>(json['draftKey']),
      sourceAccountId: serializer.fromJson<int>(json['sourceAccountId']),
      destinationAccountId: serializer.fromJson<int?>(
        json['destinationAccountId'],
      ),
      destinationCurrency: serializer.fromJson<String>(
        json['destinationCurrency'],
      ),
      destination: $RemittancesTable.$converterdestination.fromJson(
        serializer.fromJson<String>(json['destination']),
      ),
      beneficiary: serializer.fromJson<String?>(json['beneficiary']),
      cancelled: serializer.fromJson<bool>(json['cancelled']),
      awaiting: serializer.fromJson<bool>(json['awaiting']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'draftKey': serializer.toJson<String>(draftKey),
      'sourceAccountId': serializer.toJson<int>(sourceAccountId),
      'destinationAccountId': serializer.toJson<int?>(destinationAccountId),
      'destinationCurrency': serializer.toJson<String>(destinationCurrency),
      'destination': serializer.toJson<String>(
        $RemittancesTable.$converterdestination.toJson(destination),
      ),
      'beneficiary': serializer.toJson<String?>(beneficiary),
      'cancelled': serializer.toJson<bool>(cancelled),
      'awaiting': serializer.toJson<bool>(awaiting),
    };
  }

  Remittance copyWith({
    int? id,
    String? draftKey,
    int? sourceAccountId,
    Value<int?> destinationAccountId = const Value.absent(),
    String? destinationCurrency,
    RemittanceDestination? destination,
    Value<String?> beneficiary = const Value.absent(),
    bool? cancelled,
    bool? awaiting,
  }) => Remittance(
    id: id ?? this.id,
    draftKey: draftKey ?? this.draftKey,
    sourceAccountId: sourceAccountId ?? this.sourceAccountId,
    destinationAccountId: destinationAccountId.present
        ? destinationAccountId.value
        : this.destinationAccountId,
    destinationCurrency: destinationCurrency ?? this.destinationCurrency,
    destination: destination ?? this.destination,
    beneficiary: beneficiary.present ? beneficiary.value : this.beneficiary,
    cancelled: cancelled ?? this.cancelled,
    awaiting: awaiting ?? this.awaiting,
  );
  Remittance copyWithCompanion(RemittancesCompanion data) {
    return Remittance(
      id: data.id.present ? data.id.value : this.id,
      draftKey: data.draftKey.present ? data.draftKey.value : this.draftKey,
      sourceAccountId: data.sourceAccountId.present
          ? data.sourceAccountId.value
          : this.sourceAccountId,
      destinationAccountId: data.destinationAccountId.present
          ? data.destinationAccountId.value
          : this.destinationAccountId,
      destinationCurrency: data.destinationCurrency.present
          ? data.destinationCurrency.value
          : this.destinationCurrency,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      beneficiary: data.beneficiary.present
          ? data.beneficiary.value
          : this.beneficiary,
      cancelled: data.cancelled.present ? data.cancelled.value : this.cancelled,
      awaiting: data.awaiting.present ? data.awaiting.value : this.awaiting,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Remittance(')
          ..write('id: $id, ')
          ..write('draftKey: $draftKey, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('destinationCurrency: $destinationCurrency, ')
          ..write('destination: $destination, ')
          ..write('beneficiary: $beneficiary, ')
          ..write('cancelled: $cancelled, ')
          ..write('awaiting: $awaiting')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    draftKey,
    sourceAccountId,
    destinationAccountId,
    destinationCurrency,
    destination,
    beneficiary,
    cancelled,
    awaiting,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Remittance &&
          other.id == this.id &&
          other.draftKey == this.draftKey &&
          other.sourceAccountId == this.sourceAccountId &&
          other.destinationAccountId == this.destinationAccountId &&
          other.destinationCurrency == this.destinationCurrency &&
          other.destination == this.destination &&
          other.beneficiary == this.beneficiary &&
          other.cancelled == this.cancelled &&
          other.awaiting == this.awaiting);
}

class RemittancesCompanion extends UpdateCompanion<Remittance> {
  final Value<int> id;
  final Value<String> draftKey;
  final Value<int> sourceAccountId;
  final Value<int?> destinationAccountId;
  final Value<String> destinationCurrency;
  final Value<RemittanceDestination> destination;
  final Value<String?> beneficiary;
  final Value<bool> cancelled;
  final Value<bool> awaiting;
  const RemittancesCompanion({
    this.id = const Value.absent(),
    this.draftKey = const Value.absent(),
    this.sourceAccountId = const Value.absent(),
    this.destinationAccountId = const Value.absent(),
    this.destinationCurrency = const Value.absent(),
    this.destination = const Value.absent(),
    this.beneficiary = const Value.absent(),
    this.cancelled = const Value.absent(),
    this.awaiting = const Value.absent(),
  });
  RemittancesCompanion.insert({
    this.id = const Value.absent(),
    required String draftKey,
    required int sourceAccountId,
    this.destinationAccountId = const Value.absent(),
    required String destinationCurrency,
    required RemittanceDestination destination,
    this.beneficiary = const Value.absent(),
    this.cancelled = const Value.absent(),
    this.awaiting = const Value.absent(),
  }) : draftKey = Value(draftKey),
       sourceAccountId = Value(sourceAccountId),
       destinationCurrency = Value(destinationCurrency),
       destination = Value(destination);
  static Insertable<Remittance> custom({
    Expression<int>? id,
    Expression<String>? draftKey,
    Expression<int>? sourceAccountId,
    Expression<int>? destinationAccountId,
    Expression<String>? destinationCurrency,
    Expression<String>? destination,
    Expression<String>? beneficiary,
    Expression<bool>? cancelled,
    Expression<bool>? awaiting,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (draftKey != null) 'draft_key': draftKey,
      if (sourceAccountId != null) 'source_account_id': sourceAccountId,
      if (destinationAccountId != null)
        'destination_account_id': destinationAccountId,
      if (destinationCurrency != null)
        'destination_currency': destinationCurrency,
      if (destination != null) 'destination': destination,
      if (beneficiary != null) 'beneficiary': beneficiary,
      if (cancelled != null) 'cancelled': cancelled,
      if (awaiting != null) 'awaiting': awaiting,
    });
  }

  RemittancesCompanion copyWith({
    Value<int>? id,
    Value<String>? draftKey,
    Value<int>? sourceAccountId,
    Value<int?>? destinationAccountId,
    Value<String>? destinationCurrency,
    Value<RemittanceDestination>? destination,
    Value<String?>? beneficiary,
    Value<bool>? cancelled,
    Value<bool>? awaiting,
  }) {
    return RemittancesCompanion(
      id: id ?? this.id,
      draftKey: draftKey ?? this.draftKey,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      destinationAccountId: destinationAccountId ?? this.destinationAccountId,
      destinationCurrency: destinationCurrency ?? this.destinationCurrency,
      destination: destination ?? this.destination,
      beneficiary: beneficiary ?? this.beneficiary,
      cancelled: cancelled ?? this.cancelled,
      awaiting: awaiting ?? this.awaiting,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (draftKey.present) {
      map['draft_key'] = Variable<String>(draftKey.value);
    }
    if (sourceAccountId.present) {
      map['source_account_id'] = Variable<int>(sourceAccountId.value);
    }
    if (destinationAccountId.present) {
      map['destination_account_id'] = Variable<int>(destinationAccountId.value);
    }
    if (destinationCurrency.present) {
      map['destination_currency'] = Variable<String>(destinationCurrency.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(
        $RemittancesTable.$converterdestination.toSql(destination.value),
      );
    }
    if (beneficiary.present) {
      map['beneficiary'] = Variable<String>(beneficiary.value);
    }
    if (cancelled.present) {
      map['cancelled'] = Variable<bool>(cancelled.value);
    }
    if (awaiting.present) {
      map['awaiting'] = Variable<bool>(awaiting.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemittancesCompanion(')
          ..write('id: $id, ')
          ..write('draftKey: $draftKey, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('destinationCurrency: $destinationCurrency, ')
          ..write('destination: $destination, ')
          ..write('beneficiary: $beneficiary, ')
          ..write('cancelled: $cancelled, ')
          ..write('awaiting: $awaiting')
          ..write(')'))
        .toString();
  }
}

class $RemittanceEventsTable extends RemittanceEvents
    with TableInfo<$RemittanceEventsTable, RemittanceEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemittanceEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id)',
    ),
  );
  static const VerificationMeta _remittanceIdMeta = const VerificationMeta(
    'remittanceId',
  );
  @override
  late final GeneratedColumn<int> remittanceId = GeneratedColumn<int>(
    'remittance_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES remittances (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RemittanceEventKind, String>
  kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<RemittanceEventKind>($RemittanceEventsTable.$converterkind);
  static const VerificationMeta _evidenceMeta = const VerificationMeta(
    'evidence',
  );
  @override
  late final GeneratedColumn<String> evidence = GeneratedColumn<String>(
    'evidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _feeMinorMeta = const VerificationMeta(
    'feeMinor',
  );
  @override
  late final GeneratedColumn<int> feeMinor = GeneratedColumn<int>(
    'fee_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptEntryIdMeta = const VerificationMeta(
    'receiptEntryId',
  );
  @override
  late final GeneratedColumn<int> receiptEntryId = GeneratedColumn<int>(
    'receipt_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    entryId,
    remittanceId,
    kind,
    evidence,
    feeMinor,
    receiptEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'remittance_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<RemittanceEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    }
    if (data.containsKey('remittance_id')) {
      context.handle(
        _remittanceIdMeta,
        remittanceId.isAcceptableOrUnknown(
          data['remittance_id']!,
          _remittanceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remittanceIdMeta);
    }
    if (data.containsKey('evidence')) {
      context.handle(
        _evidenceMeta,
        evidence.isAcceptableOrUnknown(data['evidence']!, _evidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_evidenceMeta);
    }
    if (data.containsKey('fee_minor')) {
      context.handle(
        _feeMinorMeta,
        feeMinor.isAcceptableOrUnknown(data['fee_minor']!, _feeMinorMeta),
      );
    }
    if (data.containsKey('receipt_entry_id')) {
      context.handle(
        _receiptEntryIdMeta,
        receiptEntryId.isAcceptableOrUnknown(
          data['receipt_entry_id']!,
          _receiptEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId};
  @override
  RemittanceEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemittanceEvent(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      remittanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remittance_id'],
      )!,
      kind: $RemittanceEventsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      evidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence'],
      )!,
      feeMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fee_minor'],
      ),
      receiptEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_entry_id'],
      ),
    );
  }

  @override
  $RemittanceEventsTable createAlias(String alias) {
    return $RemittanceEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RemittanceEventKind, String, String>
  $converterkind = const EnumNameConverter<RemittanceEventKind>(
    RemittanceEventKind.values,
  );
}

class RemittanceEvent extends DataClass implements Insertable<RemittanceEvent> {
  final int entryId;
  final int remittanceId;
  final RemittanceEventKind kind;
  final String evidence;
  final int? feeMinor;
  final int? receiptEntryId;
  const RemittanceEvent({
    required this.entryId,
    required this.remittanceId,
    required this.kind,
    required this.evidence,
    this.feeMinor,
    this.receiptEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<int>(entryId);
    map['remittance_id'] = Variable<int>(remittanceId);
    {
      map['kind'] = Variable<String>(
        $RemittanceEventsTable.$converterkind.toSql(kind),
      );
    }
    map['evidence'] = Variable<String>(evidence);
    if (!nullToAbsent || feeMinor != null) {
      map['fee_minor'] = Variable<int>(feeMinor);
    }
    if (!nullToAbsent || receiptEntryId != null) {
      map['receipt_entry_id'] = Variable<int>(receiptEntryId);
    }
    return map;
  }

  RemittanceEventsCompanion toCompanion(bool nullToAbsent) {
    return RemittanceEventsCompanion(
      entryId: Value(entryId),
      remittanceId: Value(remittanceId),
      kind: Value(kind),
      evidence: Value(evidence),
      feeMinor: feeMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(feeMinor),
      receiptEntryId: receiptEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptEntryId),
    );
  }

  factory RemittanceEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemittanceEvent(
      entryId: serializer.fromJson<int>(json['entryId']),
      remittanceId: serializer.fromJson<int>(json['remittanceId']),
      kind: $RemittanceEventsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      evidence: serializer.fromJson<String>(json['evidence']),
      feeMinor: serializer.fromJson<int?>(json['feeMinor']),
      receiptEntryId: serializer.fromJson<int?>(json['receiptEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<int>(entryId),
      'remittanceId': serializer.toJson<int>(remittanceId),
      'kind': serializer.toJson<String>(
        $RemittanceEventsTable.$converterkind.toJson(kind),
      ),
      'evidence': serializer.toJson<String>(evidence),
      'feeMinor': serializer.toJson<int?>(feeMinor),
      'receiptEntryId': serializer.toJson<int?>(receiptEntryId),
    };
  }

  RemittanceEvent copyWith({
    int? entryId,
    int? remittanceId,
    RemittanceEventKind? kind,
    String? evidence,
    Value<int?> feeMinor = const Value.absent(),
    Value<int?> receiptEntryId = const Value.absent(),
  }) => RemittanceEvent(
    entryId: entryId ?? this.entryId,
    remittanceId: remittanceId ?? this.remittanceId,
    kind: kind ?? this.kind,
    evidence: evidence ?? this.evidence,
    feeMinor: feeMinor.present ? feeMinor.value : this.feeMinor,
    receiptEntryId: receiptEntryId.present
        ? receiptEntryId.value
        : this.receiptEntryId,
  );
  RemittanceEvent copyWithCompanion(RemittanceEventsCompanion data) {
    return RemittanceEvent(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      remittanceId: data.remittanceId.present
          ? data.remittanceId.value
          : this.remittanceId,
      kind: data.kind.present ? data.kind.value : this.kind,
      evidence: data.evidence.present ? data.evidence.value : this.evidence,
      feeMinor: data.feeMinor.present ? data.feeMinor.value : this.feeMinor,
      receiptEntryId: data.receiptEntryId.present
          ? data.receiptEntryId.value
          : this.receiptEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemittanceEvent(')
          ..write('entryId: $entryId, ')
          ..write('remittanceId: $remittanceId, ')
          ..write('kind: $kind, ')
          ..write('evidence: $evidence, ')
          ..write('feeMinor: $feeMinor, ')
          ..write('receiptEntryId: $receiptEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    entryId,
    remittanceId,
    kind,
    evidence,
    feeMinor,
    receiptEntryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemittanceEvent &&
          other.entryId == this.entryId &&
          other.remittanceId == this.remittanceId &&
          other.kind == this.kind &&
          other.evidence == this.evidence &&
          other.feeMinor == this.feeMinor &&
          other.receiptEntryId == this.receiptEntryId);
}

class RemittanceEventsCompanion extends UpdateCompanion<RemittanceEvent> {
  final Value<int> entryId;
  final Value<int> remittanceId;
  final Value<RemittanceEventKind> kind;
  final Value<String> evidence;
  final Value<int?> feeMinor;
  final Value<int?> receiptEntryId;
  const RemittanceEventsCompanion({
    this.entryId = const Value.absent(),
    this.remittanceId = const Value.absent(),
    this.kind = const Value.absent(),
    this.evidence = const Value.absent(),
    this.feeMinor = const Value.absent(),
    this.receiptEntryId = const Value.absent(),
  });
  RemittanceEventsCompanion.insert({
    this.entryId = const Value.absent(),
    required int remittanceId,
    required RemittanceEventKind kind,
    required String evidence,
    this.feeMinor = const Value.absent(),
    this.receiptEntryId = const Value.absent(),
  }) : remittanceId = Value(remittanceId),
       kind = Value(kind),
       evidence = Value(evidence);
  static Insertable<RemittanceEvent> custom({
    Expression<int>? entryId,
    Expression<int>? remittanceId,
    Expression<String>? kind,
    Expression<String>? evidence,
    Expression<int>? feeMinor,
    Expression<int>? receiptEntryId,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (remittanceId != null) 'remittance_id': remittanceId,
      if (kind != null) 'kind': kind,
      if (evidence != null) 'evidence': evidence,
      if (feeMinor != null) 'fee_minor': feeMinor,
      if (receiptEntryId != null) 'receipt_entry_id': receiptEntryId,
    });
  }

  RemittanceEventsCompanion copyWith({
    Value<int>? entryId,
    Value<int>? remittanceId,
    Value<RemittanceEventKind>? kind,
    Value<String>? evidence,
    Value<int?>? feeMinor,
    Value<int?>? receiptEntryId,
  }) {
    return RemittanceEventsCompanion(
      entryId: entryId ?? this.entryId,
      remittanceId: remittanceId ?? this.remittanceId,
      kind: kind ?? this.kind,
      evidence: evidence ?? this.evidence,
      feeMinor: feeMinor ?? this.feeMinor,
      receiptEntryId: receiptEntryId ?? this.receiptEntryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (remittanceId.present) {
      map['remittance_id'] = Variable<int>(remittanceId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $RemittanceEventsTable.$converterkind.toSql(kind.value),
      );
    }
    if (evidence.present) {
      map['evidence'] = Variable<String>(evidence.value);
    }
    if (feeMinor.present) {
      map['fee_minor'] = Variable<int>(feeMinor.value);
    }
    if (receiptEntryId.present) {
      map['receipt_entry_id'] = Variable<int>(receiptEntryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemittanceEventsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('remittanceId: $remittanceId, ')
          ..write('kind: $kind, ')
          ..write('evidence: $evidence, ')
          ..write('feeMinor: $feeMinor, ')
          ..write('receiptEntryId: $receiptEntryId')
          ..write(')'))
        .toString();
  }
}

class $RemittancePurposesTable extends RemittancePurposes
    with TableInfo<$RemittancePurposesTable, RemittancePurpose> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemittancePurposesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationKeyMeta = const VerificationMeta(
    'operationKey',
  );
  @override
  late final GeneratedColumn<String> operationKey = GeneratedColumn<String>(
    'operation_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remittanceIdMeta = const VerificationMeta(
    'remittanceId',
  );
  @override
  late final GeneratedColumn<int> remittanceId = GeneratedColumn<int>(
    'remittance_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES remittances (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minorMeta = const VerificationMeta('minor');
  @override
  late final GeneratedColumn<int> minor = GeneratedColumn<int>(
    'minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyMeta = const VerificationMeta('family');
  @override
  late final GeneratedColumn<bool> family = GeneratedColumn<bool>(
    'family',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("family" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationKey,
    remittanceId,
    label,
    minor,
    family,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'remittance_purposes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RemittancePurpose> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_key')) {
      context.handle(
        _operationKeyMeta,
        operationKey.isAcceptableOrUnknown(
          data['operation_key']!,
          _operationKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationKeyMeta);
    }
    if (data.containsKey('remittance_id')) {
      context.handle(
        _remittanceIdMeta,
        remittanceId.isAcceptableOrUnknown(
          data['remittance_id']!,
          _remittanceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remittanceIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('minor')) {
      context.handle(
        _minorMeta,
        minor.isAcceptableOrUnknown(data['minor']!, _minorMeta),
      );
    } else if (isInserting) {
      context.missing(_minorMeta);
    }
    if (data.containsKey('family')) {
      context.handle(
        _familyMeta,
        family.isAcceptableOrUnknown(data['family']!, _familyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationKey};
  @override
  RemittancePurpose map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemittancePurpose(
      operationKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_key'],
      )!,
      remittanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remittance_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      minor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minor'],
      )!,
      family: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}family'],
      )!,
    );
  }

  @override
  $RemittancePurposesTable createAlias(String alias) {
    return $RemittancePurposesTable(attachedDatabase, alias);
  }
}

class RemittancePurpose extends DataClass
    implements Insertable<RemittancePurpose> {
  final String operationKey;
  final int remittanceId;
  final String label;
  final int minor;
  final bool family;
  const RemittancePurpose({
    required this.operationKey,
    required this.remittanceId,
    required this.label,
    required this.minor,
    required this.family,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_key'] = Variable<String>(operationKey);
    map['remittance_id'] = Variable<int>(remittanceId);
    map['label'] = Variable<String>(label);
    map['minor'] = Variable<int>(minor);
    map['family'] = Variable<bool>(family);
    return map;
  }

  RemittancePurposesCompanion toCompanion(bool nullToAbsent) {
    return RemittancePurposesCompanion(
      operationKey: Value(operationKey),
      remittanceId: Value(remittanceId),
      label: Value(label),
      minor: Value(minor),
      family: Value(family),
    );
  }

  factory RemittancePurpose.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemittancePurpose(
      operationKey: serializer.fromJson<String>(json['operationKey']),
      remittanceId: serializer.fromJson<int>(json['remittanceId']),
      label: serializer.fromJson<String>(json['label']),
      minor: serializer.fromJson<int>(json['minor']),
      family: serializer.fromJson<bool>(json['family']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationKey': serializer.toJson<String>(operationKey),
      'remittanceId': serializer.toJson<int>(remittanceId),
      'label': serializer.toJson<String>(label),
      'minor': serializer.toJson<int>(minor),
      'family': serializer.toJson<bool>(family),
    };
  }

  RemittancePurpose copyWith({
    String? operationKey,
    int? remittanceId,
    String? label,
    int? minor,
    bool? family,
  }) => RemittancePurpose(
    operationKey: operationKey ?? this.operationKey,
    remittanceId: remittanceId ?? this.remittanceId,
    label: label ?? this.label,
    minor: minor ?? this.minor,
    family: family ?? this.family,
  );
  RemittancePurpose copyWithCompanion(RemittancePurposesCompanion data) {
    return RemittancePurpose(
      operationKey: data.operationKey.present
          ? data.operationKey.value
          : this.operationKey,
      remittanceId: data.remittanceId.present
          ? data.remittanceId.value
          : this.remittanceId,
      label: data.label.present ? data.label.value : this.label,
      minor: data.minor.present ? data.minor.value : this.minor,
      family: data.family.present ? data.family.value : this.family,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemittancePurpose(')
          ..write('operationKey: $operationKey, ')
          ..write('remittanceId: $remittanceId, ')
          ..write('label: $label, ')
          ..write('minor: $minor, ')
          ..write('family: $family')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(operationKey, remittanceId, label, minor, family);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemittancePurpose &&
          other.operationKey == this.operationKey &&
          other.remittanceId == this.remittanceId &&
          other.label == this.label &&
          other.minor == this.minor &&
          other.family == this.family);
}

class RemittancePurposesCompanion extends UpdateCompanion<RemittancePurpose> {
  final Value<String> operationKey;
  final Value<int> remittanceId;
  final Value<String> label;
  final Value<int> minor;
  final Value<bool> family;
  final Value<int> rowid;
  const RemittancePurposesCompanion({
    this.operationKey = const Value.absent(),
    this.remittanceId = const Value.absent(),
    this.label = const Value.absent(),
    this.minor = const Value.absent(),
    this.family = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemittancePurposesCompanion.insert({
    required String operationKey,
    required int remittanceId,
    required String label,
    required int minor,
    this.family = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : operationKey = Value(operationKey),
       remittanceId = Value(remittanceId),
       label = Value(label),
       minor = Value(minor);
  static Insertable<RemittancePurpose> custom({
    Expression<String>? operationKey,
    Expression<int>? remittanceId,
    Expression<String>? label,
    Expression<int>? minor,
    Expression<bool>? family,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationKey != null) 'operation_key': operationKey,
      if (remittanceId != null) 'remittance_id': remittanceId,
      if (label != null) 'label': label,
      if (minor != null) 'minor': minor,
      if (family != null) 'family': family,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemittancePurposesCompanion copyWith({
    Value<String>? operationKey,
    Value<int>? remittanceId,
    Value<String>? label,
    Value<int>? minor,
    Value<bool>? family,
    Value<int>? rowid,
  }) {
    return RemittancePurposesCompanion(
      operationKey: operationKey ?? this.operationKey,
      remittanceId: remittanceId ?? this.remittanceId,
      label: label ?? this.label,
      minor: minor ?? this.minor,
      family: family ?? this.family,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationKey.present) {
      map['operation_key'] = Variable<String>(operationKey.value);
    }
    if (remittanceId.present) {
      map['remittance_id'] = Variable<int>(remittanceId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (minor.present) {
      map['minor'] = Variable<int>(minor.value);
    }
    if (family.present) {
      map['family'] = Variable<bool>(family.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemittancePurposesCompanion(')
          ..write('operationKey: $operationKey, ')
          ..write('remittanceId: $remittanceId, ')
          ..write('label: $label, ')
          ..write('minor: $minor, ')
          ..write('family: $family, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemittanceFamilyPaymentsTable extends RemittanceFamilyPayments
    with TableInfo<$RemittanceFamilyPaymentsTable, RemittanceFamilyPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemittanceFamilyPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id)',
    ),
  );
  static const VerificationMeta _purposeKeyMeta = const VerificationMeta(
    'purposeKey',
  );
  @override
  late final GeneratedColumn<String> purposeKey = GeneratedColumn<String>(
    'purpose_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES remittance_purposes (operation_key)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [entryId, purposeKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'remittance_family_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<RemittanceFamilyPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    }
    if (data.containsKey('purpose_key')) {
      context.handle(
        _purposeKeyMeta,
        purposeKey.isAcceptableOrUnknown(data['purpose_key']!, _purposeKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_purposeKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId};
  @override
  RemittanceFamilyPayment map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemittanceFamilyPayment(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      purposeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose_key'],
      )!,
    );
  }

  @override
  $RemittanceFamilyPaymentsTable createAlias(String alias) {
    return $RemittanceFamilyPaymentsTable(attachedDatabase, alias);
  }
}

class RemittanceFamilyPayment extends DataClass
    implements Insertable<RemittanceFamilyPayment> {
  final int entryId;
  final String purposeKey;
  const RemittanceFamilyPayment({
    required this.entryId,
    required this.purposeKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<int>(entryId);
    map['purpose_key'] = Variable<String>(purposeKey);
    return map;
  }

  RemittanceFamilyPaymentsCompanion toCompanion(bool nullToAbsent) {
    return RemittanceFamilyPaymentsCompanion(
      entryId: Value(entryId),
      purposeKey: Value(purposeKey),
    );
  }

  factory RemittanceFamilyPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemittanceFamilyPayment(
      entryId: serializer.fromJson<int>(json['entryId']),
      purposeKey: serializer.fromJson<String>(json['purposeKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<int>(entryId),
      'purposeKey': serializer.toJson<String>(purposeKey),
    };
  }

  RemittanceFamilyPayment copyWith({int? entryId, String? purposeKey}) =>
      RemittanceFamilyPayment(
        entryId: entryId ?? this.entryId,
        purposeKey: purposeKey ?? this.purposeKey,
      );
  RemittanceFamilyPayment copyWithCompanion(
    RemittanceFamilyPaymentsCompanion data,
  ) {
    return RemittanceFamilyPayment(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      purposeKey: data.purposeKey.present
          ? data.purposeKey.value
          : this.purposeKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemittanceFamilyPayment(')
          ..write('entryId: $entryId, ')
          ..write('purposeKey: $purposeKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entryId, purposeKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemittanceFamilyPayment &&
          other.entryId == this.entryId &&
          other.purposeKey == this.purposeKey);
}

class RemittanceFamilyPaymentsCompanion
    extends UpdateCompanion<RemittanceFamilyPayment> {
  final Value<int> entryId;
  final Value<String> purposeKey;
  const RemittanceFamilyPaymentsCompanion({
    this.entryId = const Value.absent(),
    this.purposeKey = const Value.absent(),
  });
  RemittanceFamilyPaymentsCompanion.insert({
    this.entryId = const Value.absent(),
    required String purposeKey,
  }) : purposeKey = Value(purposeKey);
  static Insertable<RemittanceFamilyPayment> custom({
    Expression<int>? entryId,
    Expression<String>? purposeKey,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (purposeKey != null) 'purpose_key': purposeKey,
    });
  }

  RemittanceFamilyPaymentsCompanion copyWith({
    Value<int>? entryId,
    Value<String>? purposeKey,
  }) {
    return RemittanceFamilyPaymentsCompanion(
      entryId: entryId ?? this.entryId,
      purposeKey: purposeKey ?? this.purposeKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (purposeKey.present) {
      map['purpose_key'] = Variable<String>(purposeKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemittanceFamilyPaymentsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('purposeKey: $purposeKey')
          ..write(')'))
        .toString();
  }
}

class $LeaveRulesTable extends LeaveRules
    with TableInfo<$LeaveRulesTable, LeaveRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _effectiveDayMeta = const VerificationMeta(
    'effectiveDay',
  );
  @override
  late final GeneratedColumn<int> effectiveDay = GeneratedColumn<int>(
    'effective_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _annualDaysMeta = const VerificationMeta(
    'annualDays',
  );
  @override
  late final GeneratedColumn<int> annualDays = GeneratedColumn<int>(
    'annual_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _casualDaysMeta = const VerificationMeta(
    'casualDays',
  );
  @override
  late final GeneratedColumn<int> casualDays = GeneratedColumn<int>(
    'casual_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sickDaysMeta = const VerificationMeta(
    'sickDays',
  );
  @override
  late final GeneratedColumn<int> sickDays = GeneratedColumn<int>(
    'sick_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    effectiveDay,
    annualDays,
    casualDays,
    sickDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('effective_day')) {
      context.handle(
        _effectiveDayMeta,
        effectiveDay.isAcceptableOrUnknown(
          data['effective_day']!,
          _effectiveDayMeta,
        ),
      );
    }
    if (data.containsKey('annual_days')) {
      context.handle(
        _annualDaysMeta,
        annualDays.isAcceptableOrUnknown(data['annual_days']!, _annualDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_annualDaysMeta);
    }
    if (data.containsKey('casual_days')) {
      context.handle(
        _casualDaysMeta,
        casualDays.isAcceptableOrUnknown(data['casual_days']!, _casualDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_casualDaysMeta);
    }
    if (data.containsKey('sick_days')) {
      context.handle(
        _sickDaysMeta,
        sickDays.isAcceptableOrUnknown(data['sick_days']!, _sickDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_sickDaysMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {effectiveDay};
  @override
  LeaveRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveRule(
      effectiveDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}effective_day'],
      )!,
      annualDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}annual_days'],
      )!,
      casualDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}casual_days'],
      )!,
      sickDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sick_days'],
      )!,
    );
  }

  @override
  $LeaveRulesTable createAlias(String alias) {
    return $LeaveRulesTable(attachedDatabase, alias);
  }
}

class LeaveRule extends DataClass implements Insertable<LeaveRule> {
  final int effectiveDay;
  final int annualDays;
  final int casualDays;
  final int sickDays;
  const LeaveRule({
    required this.effectiveDay,
    required this.annualDays,
    required this.casualDays,
    required this.sickDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['effective_day'] = Variable<int>(effectiveDay);
    map['annual_days'] = Variable<int>(annualDays);
    map['casual_days'] = Variable<int>(casualDays);
    map['sick_days'] = Variable<int>(sickDays);
    return map;
  }

  LeaveRulesCompanion toCompanion(bool nullToAbsent) {
    return LeaveRulesCompanion(
      effectiveDay: Value(effectiveDay),
      annualDays: Value(annualDays),
      casualDays: Value(casualDays),
      sickDays: Value(sickDays),
    );
  }

  factory LeaveRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveRule(
      effectiveDay: serializer.fromJson<int>(json['effectiveDay']),
      annualDays: serializer.fromJson<int>(json['annualDays']),
      casualDays: serializer.fromJson<int>(json['casualDays']),
      sickDays: serializer.fromJson<int>(json['sickDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'effectiveDay': serializer.toJson<int>(effectiveDay),
      'annualDays': serializer.toJson<int>(annualDays),
      'casualDays': serializer.toJson<int>(casualDays),
      'sickDays': serializer.toJson<int>(sickDays),
    };
  }

  LeaveRule copyWith({
    int? effectiveDay,
    int? annualDays,
    int? casualDays,
    int? sickDays,
  }) => LeaveRule(
    effectiveDay: effectiveDay ?? this.effectiveDay,
    annualDays: annualDays ?? this.annualDays,
    casualDays: casualDays ?? this.casualDays,
    sickDays: sickDays ?? this.sickDays,
  );
  LeaveRule copyWithCompanion(LeaveRulesCompanion data) {
    return LeaveRule(
      effectiveDay: data.effectiveDay.present
          ? data.effectiveDay.value
          : this.effectiveDay,
      annualDays: data.annualDays.present
          ? data.annualDays.value
          : this.annualDays,
      casualDays: data.casualDays.present
          ? data.casualDays.value
          : this.casualDays,
      sickDays: data.sickDays.present ? data.sickDays.value : this.sickDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRule(')
          ..write('effectiveDay: $effectiveDay, ')
          ..write('annualDays: $annualDays, ')
          ..write('casualDays: $casualDays, ')
          ..write('sickDays: $sickDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(effectiveDay, annualDays, casualDays, sickDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveRule &&
          other.effectiveDay == this.effectiveDay &&
          other.annualDays == this.annualDays &&
          other.casualDays == this.casualDays &&
          other.sickDays == this.sickDays);
}

class LeaveRulesCompanion extends UpdateCompanion<LeaveRule> {
  final Value<int> effectiveDay;
  final Value<int> annualDays;
  final Value<int> casualDays;
  final Value<int> sickDays;
  const LeaveRulesCompanion({
    this.effectiveDay = const Value.absent(),
    this.annualDays = const Value.absent(),
    this.casualDays = const Value.absent(),
    this.sickDays = const Value.absent(),
  });
  LeaveRulesCompanion.insert({
    this.effectiveDay = const Value.absent(),
    required int annualDays,
    required int casualDays,
    required int sickDays,
  }) : annualDays = Value(annualDays),
       casualDays = Value(casualDays),
       sickDays = Value(sickDays);
  static Insertable<LeaveRule> custom({
    Expression<int>? effectiveDay,
    Expression<int>? annualDays,
    Expression<int>? casualDays,
    Expression<int>? sickDays,
  }) {
    return RawValuesInsertable({
      if (effectiveDay != null) 'effective_day': effectiveDay,
      if (annualDays != null) 'annual_days': annualDays,
      if (casualDays != null) 'casual_days': casualDays,
      if (sickDays != null) 'sick_days': sickDays,
    });
  }

  LeaveRulesCompanion copyWith({
    Value<int>? effectiveDay,
    Value<int>? annualDays,
    Value<int>? casualDays,
    Value<int>? sickDays,
  }) {
    return LeaveRulesCompanion(
      effectiveDay: effectiveDay ?? this.effectiveDay,
      annualDays: annualDays ?? this.annualDays,
      casualDays: casualDays ?? this.casualDays,
      sickDays: sickDays ?? this.sickDays,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (effectiveDay.present) {
      map['effective_day'] = Variable<int>(effectiveDay.value);
    }
    if (annualDays.present) {
      map['annual_days'] = Variable<int>(annualDays.value);
    }
    if (casualDays.present) {
      map['casual_days'] = Variable<int>(casualDays.value);
    }
    if (sickDays.present) {
      map['sick_days'] = Variable<int>(sickDays.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRulesCompanion(')
          ..write('effectiveDay: $effectiveDay, ')
          ..write('annualDays: $annualDays, ')
          ..write('casualDays: $casualDays, ')
          ..write('sickDays: $sickDays')
          ..write(')'))
        .toString();
  }
}

class $LeaveEntriesTable extends LeaveEntries
    with TableInfo<$LeaveEntriesTable, LeaveEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LeaveKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LeaveKind>($LeaveEntriesTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<LeaveStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LeaveStatus>($LeaveEntriesTable.$converterstatus);
  static const VerificationMeta _startDayMeta = const VerificationMeta(
    'startDay',
  );
  @override
  late final GeneratedColumn<int> startDay = GeneratedColumn<int>(
    'start_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDayMeta = const VerificationMeta('endDay');
  @override
  late final GeneratedColumn<int> endDay = GeneratedColumn<int>(
    'end_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occasionMeta = const VerificationMeta(
    'occasion',
  );
  @override
  late final GeneratedColumn<String> occasion = GeneratedColumn<String>(
    'occasion',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 120),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MedicalReport, String>
  medicalReport = GeneratedColumn<String>(
    'medical_report',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<MedicalReport>($LeaveEntriesTable.$convertermedicalReport);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    status,
    startDay,
    endDay,
    occasion,
    medicalReport,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_day')) {
      context.handle(
        _startDayMeta,
        startDay.isAcceptableOrUnknown(data['start_day']!, _startDayMeta),
      );
    } else if (isInserting) {
      context.missing(_startDayMeta);
    }
    if (data.containsKey('end_day')) {
      context.handle(
        _endDayMeta,
        endDay.isAcceptableOrUnknown(data['end_day']!, _endDayMeta),
      );
    } else if (isInserting) {
      context.missing(_endDayMeta);
    }
    if (data.containsKey('occasion')) {
      context.handle(
        _occasionMeta,
        occasion.isAcceptableOrUnknown(data['occasion']!, _occasionMeta),
      );
    } else if (isInserting) {
      context.missing(_occasionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaveEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $LeaveEntriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      status: $LeaveEntriesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      startDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_day'],
      )!,
      endDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_day'],
      )!,
      occasion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occasion'],
      )!,
      medicalReport: $LeaveEntriesTable.$convertermedicalReport.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}medical_report'],
        )!,
      ),
    );
  }

  @override
  $LeaveEntriesTable createAlias(String alias) {
    return $LeaveEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LeaveKind, String, String> $converterkind =
      const EnumNameConverter<LeaveKind>(LeaveKind.values);
  static JsonTypeConverter2<LeaveStatus, String, String> $converterstatus =
      const EnumNameConverter<LeaveStatus>(LeaveStatus.values);
  static JsonTypeConverter2<MedicalReport, String, String>
  $convertermedicalReport = const EnumNameConverter<MedicalReport>(
    MedicalReport.values,
  );
}

class LeaveEntry extends DataClass implements Insertable<LeaveEntry> {
  final int id;
  final LeaveKind kind;
  final LeaveStatus status;
  final int startDay;
  final int endDay;
  final String occasion;
  final MedicalReport medicalReport;
  const LeaveEntry({
    required this.id,
    required this.kind,
    required this.status,
    required this.startDay,
    required this.endDay,
    required this.occasion,
    required this.medicalReport,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>(
        $LeaveEntriesTable.$converterkind.toSql(kind),
      );
    }
    {
      map['status'] = Variable<String>(
        $LeaveEntriesTable.$converterstatus.toSql(status),
      );
    }
    map['start_day'] = Variable<int>(startDay);
    map['end_day'] = Variable<int>(endDay);
    map['occasion'] = Variable<String>(occasion);
    {
      map['medical_report'] = Variable<String>(
        $LeaveEntriesTable.$convertermedicalReport.toSql(medicalReport),
      );
    }
    return map;
  }

  LeaveEntriesCompanion toCompanion(bool nullToAbsent) {
    return LeaveEntriesCompanion(
      id: Value(id),
      kind: Value(kind),
      status: Value(status),
      startDay: Value(startDay),
      endDay: Value(endDay),
      occasion: Value(occasion),
      medicalReport: Value(medicalReport),
    );
  }

  factory LeaveEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveEntry(
      id: serializer.fromJson<int>(json['id']),
      kind: $LeaveEntriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      status: $LeaveEntriesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      startDay: serializer.fromJson<int>(json['startDay']),
      endDay: serializer.fromJson<int>(json['endDay']),
      occasion: serializer.fromJson<String>(json['occasion']),
      medicalReport: $LeaveEntriesTable.$convertermedicalReport.fromJson(
        serializer.fromJson<String>(json['medicalReport']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(
        $LeaveEntriesTable.$converterkind.toJson(kind),
      ),
      'status': serializer.toJson<String>(
        $LeaveEntriesTable.$converterstatus.toJson(status),
      ),
      'startDay': serializer.toJson<int>(startDay),
      'endDay': serializer.toJson<int>(endDay),
      'occasion': serializer.toJson<String>(occasion),
      'medicalReport': serializer.toJson<String>(
        $LeaveEntriesTable.$convertermedicalReport.toJson(medicalReport),
      ),
    };
  }

  LeaveEntry copyWith({
    int? id,
    LeaveKind? kind,
    LeaveStatus? status,
    int? startDay,
    int? endDay,
    String? occasion,
    MedicalReport? medicalReport,
  }) => LeaveEntry(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    status: status ?? this.status,
    startDay: startDay ?? this.startDay,
    endDay: endDay ?? this.endDay,
    occasion: occasion ?? this.occasion,
    medicalReport: medicalReport ?? this.medicalReport,
  );
  LeaveEntry copyWithCompanion(LeaveEntriesCompanion data) {
    return LeaveEntry(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      status: data.status.present ? data.status.value : this.status,
      startDay: data.startDay.present ? data.startDay.value : this.startDay,
      endDay: data.endDay.present ? data.endDay.value : this.endDay,
      occasion: data.occasion.present ? data.occasion.value : this.occasion,
      medicalReport: data.medicalReport.present
          ? data.medicalReport.value
          : this.medicalReport,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveEntry(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('startDay: $startDay, ')
          ..write('endDay: $endDay, ')
          ..write('occasion: $occasion, ')
          ..write('medicalReport: $medicalReport')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, status, startDay, endDay, occasion, medicalReport);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveEntry &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.status == this.status &&
          other.startDay == this.startDay &&
          other.endDay == this.endDay &&
          other.occasion == this.occasion &&
          other.medicalReport == this.medicalReport);
}

class LeaveEntriesCompanion extends UpdateCompanion<LeaveEntry> {
  final Value<int> id;
  final Value<LeaveKind> kind;
  final Value<LeaveStatus> status;
  final Value<int> startDay;
  final Value<int> endDay;
  final Value<String> occasion;
  final Value<MedicalReport> medicalReport;
  const LeaveEntriesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.startDay = const Value.absent(),
    this.endDay = const Value.absent(),
    this.occasion = const Value.absent(),
    this.medicalReport = const Value.absent(),
  });
  LeaveEntriesCompanion.insert({
    this.id = const Value.absent(),
    required LeaveKind kind,
    required LeaveStatus status,
    required int startDay,
    required int endDay,
    required String occasion,
    required MedicalReport medicalReport,
  }) : kind = Value(kind),
       status = Value(status),
       startDay = Value(startDay),
       endDay = Value(endDay),
       occasion = Value(occasion),
       medicalReport = Value(medicalReport);
  static Insertable<LeaveEntry> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? status,
    Expression<int>? startDay,
    Expression<int>? endDay,
    Expression<String>? occasion,
    Expression<String>? medicalReport,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (status != null) 'status': status,
      if (startDay != null) 'start_day': startDay,
      if (endDay != null) 'end_day': endDay,
      if (occasion != null) 'occasion': occasion,
      if (medicalReport != null) 'medical_report': medicalReport,
    });
  }

  LeaveEntriesCompanion copyWith({
    Value<int>? id,
    Value<LeaveKind>? kind,
    Value<LeaveStatus>? status,
    Value<int>? startDay,
    Value<int>? endDay,
    Value<String>? occasion,
    Value<MedicalReport>? medicalReport,
  }) {
    return LeaveEntriesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
      occasion: occasion ?? this.occasion,
      medicalReport: medicalReport ?? this.medicalReport,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $LeaveEntriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $LeaveEntriesTable.$converterstatus.toSql(status.value),
      );
    }
    if (startDay.present) {
      map['start_day'] = Variable<int>(startDay.value);
    }
    if (endDay.present) {
      map['end_day'] = Variable<int>(endDay.value);
    }
    if (occasion.present) {
      map['occasion'] = Variable<String>(occasion.value);
    }
    if (medicalReport.present) {
      map['medical_report'] = Variable<String>(
        $LeaveEntriesTable.$convertermedicalReport.toSql(medicalReport.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveEntriesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('startDay: $startDay, ')
          ..write('endDay: $endDay, ')
          ..write('occasion: $occasion, ')
          ..write('medicalReport: $medicalReport')
          ..write(')'))
        .toString();
  }
}

class $LeaveHolidaysTable extends LeaveHolidays
    with TableInfo<$LeaveHolidaysTable, LeaveHoliday> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveHolidaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [day, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_holidays';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveHoliday> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  LeaveHoliday map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveHoliday(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $LeaveHolidaysTable createAlias(String alias) {
    return $LeaveHolidaysTable(attachedDatabase, alias);
  }
}

class LeaveHoliday extends DataClass implements Insertable<LeaveHoliday> {
  final int day;
  final String name;
  const LeaveHoliday({required this.day, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<int>(day);
    map['name'] = Variable<String>(name);
    return map;
  }

  LeaveHolidaysCompanion toCompanion(bool nullToAbsent) {
    return LeaveHolidaysCompanion(day: Value(day), name: Value(name));
  }

  factory LeaveHoliday.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveHoliday(
      day: serializer.fromJson<int>(json['day']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<int>(day),
      'name': serializer.toJson<String>(name),
    };
  }

  LeaveHoliday copyWith({int? day, String? name}) =>
      LeaveHoliday(day: day ?? this.day, name: name ?? this.name);
  LeaveHoliday copyWithCompanion(LeaveHolidaysCompanion data) {
    return LeaveHoliday(
      day: data.day.present ? data.day.value : this.day,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveHoliday(')
          ..write('day: $day, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveHoliday &&
          other.day == this.day &&
          other.name == this.name);
}

class LeaveHolidaysCompanion extends UpdateCompanion<LeaveHoliday> {
  final Value<int> day;
  final Value<String> name;
  const LeaveHolidaysCompanion({
    this.day = const Value.absent(),
    this.name = const Value.absent(),
  });
  LeaveHolidaysCompanion.insert({
    this.day = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<LeaveHoliday> custom({
    Expression<int>? day,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (name != null) 'name': name,
    });
  }

  LeaveHolidaysCompanion copyWith({Value<int>? day, Value<String>? name}) {
    return LeaveHolidaysCompanion(
      day: day ?? this.day,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveHolidaysCompanion(')
          ..write('day: $day, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $DashainPlansTable extends DashainPlans
    with TableInfo<$DashainPlansTable, DashainPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DashainPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _festivalDayMeta = const VerificationMeta(
    'festivalDay',
  );
  @override
  late final GeneratedColumn<int> festivalDay = GeneratedColumn<int>(
    'festival_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES currencies (code)',
    ),
  );
  static const VerificationMeta _salaryMinorMeta = const VerificationMeta(
    'salaryMinor',
  );
  @override
  late final GeneratedColumn<int> salaryMinor = GeneratedColumn<int>(
    'salary_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allowancesMinorMeta = const VerificationMeta(
    'allowancesMinor',
  );
  @override
  late final GeneratedColumn<int> allowancesMinor = GeneratedColumn<int>(
    'allowances_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiptIdMeta = const VerificationMeta(
    'receiptId',
  );
  @override
  late final GeneratedColumn<int> receiptId = GeneratedColumn<int>(
    'receipt_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES journal_entries (id)',
    ),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    year,
    festivalDay,
    currency,
    salaryMinor,
    allowancesMinor,
    receiptId,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dashain_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<DashainPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('festival_day')) {
      context.handle(
        _festivalDayMeta,
        festivalDay.isAcceptableOrUnknown(
          data['festival_day']!,
          _festivalDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_festivalDayMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('salary_minor')) {
      context.handle(
        _salaryMinorMeta,
        salaryMinor.isAcceptableOrUnknown(
          data['salary_minor']!,
          _salaryMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_salaryMinorMeta);
    }
    if (data.containsKey('allowances_minor')) {
      context.handle(
        _allowancesMinorMeta,
        allowancesMinor.isAcceptableOrUnknown(
          data['allowances_minor']!,
          _allowancesMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allowancesMinorMeta);
    }
    if (data.containsKey('receipt_id')) {
      context.handle(
        _receiptIdMeta,
        receiptId.isAcceptableOrUnknown(data['receipt_id']!, _receiptIdMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {year};
  @override
  DashainPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DashainPlan(
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      festivalDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}festival_day'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      salaryMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}salary_minor'],
      )!,
      allowancesMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allowances_minor'],
      )!,
      receiptId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_id'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  $DashainPlansTable createAlias(String alias) {
    return $DashainPlansTable(attachedDatabase, alias);
  }
}

class DashainPlan extends DataClass implements Insertable<DashainPlan> {
  final int year;
  final int festivalDay;
  final String currency;
  final int salaryMinor;
  final int allowancesMinor;
  final int? receiptId;
  final int revision;
  const DashainPlan({
    required this.year,
    required this.festivalDay,
    required this.currency,
    required this.salaryMinor,
    required this.allowancesMinor,
    this.receiptId,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['year'] = Variable<int>(year);
    map['festival_day'] = Variable<int>(festivalDay);
    map['currency'] = Variable<String>(currency);
    map['salary_minor'] = Variable<int>(salaryMinor);
    map['allowances_minor'] = Variable<int>(allowancesMinor);
    if (!nullToAbsent || receiptId != null) {
      map['receipt_id'] = Variable<int>(receiptId);
    }
    map['revision'] = Variable<int>(revision);
    return map;
  }

  DashainPlansCompanion toCompanion(bool nullToAbsent) {
    return DashainPlansCompanion(
      year: Value(year),
      festivalDay: Value(festivalDay),
      currency: Value(currency),
      salaryMinor: Value(salaryMinor),
      allowancesMinor: Value(allowancesMinor),
      receiptId: receiptId == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptId),
      revision: Value(revision),
    );
  }

  factory DashainPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DashainPlan(
      year: serializer.fromJson<int>(json['year']),
      festivalDay: serializer.fromJson<int>(json['festivalDay']),
      currency: serializer.fromJson<String>(json['currency']),
      salaryMinor: serializer.fromJson<int>(json['salaryMinor']),
      allowancesMinor: serializer.fromJson<int>(json['allowancesMinor']),
      receiptId: serializer.fromJson<int?>(json['receiptId']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'year': serializer.toJson<int>(year),
      'festivalDay': serializer.toJson<int>(festivalDay),
      'currency': serializer.toJson<String>(currency),
      'salaryMinor': serializer.toJson<int>(salaryMinor),
      'allowancesMinor': serializer.toJson<int>(allowancesMinor),
      'receiptId': serializer.toJson<int?>(receiptId),
      'revision': serializer.toJson<int>(revision),
    };
  }

  DashainPlan copyWith({
    int? year,
    int? festivalDay,
    String? currency,
    int? salaryMinor,
    int? allowancesMinor,
    Value<int?> receiptId = const Value.absent(),
    int? revision,
  }) => DashainPlan(
    year: year ?? this.year,
    festivalDay: festivalDay ?? this.festivalDay,
    currency: currency ?? this.currency,
    salaryMinor: salaryMinor ?? this.salaryMinor,
    allowancesMinor: allowancesMinor ?? this.allowancesMinor,
    receiptId: receiptId.present ? receiptId.value : this.receiptId,
    revision: revision ?? this.revision,
  );
  DashainPlan copyWithCompanion(DashainPlansCompanion data) {
    return DashainPlan(
      year: data.year.present ? data.year.value : this.year,
      festivalDay: data.festivalDay.present
          ? data.festivalDay.value
          : this.festivalDay,
      currency: data.currency.present ? data.currency.value : this.currency,
      salaryMinor: data.salaryMinor.present
          ? data.salaryMinor.value
          : this.salaryMinor,
      allowancesMinor: data.allowancesMinor.present
          ? data.allowancesMinor.value
          : this.allowancesMinor,
      receiptId: data.receiptId.present ? data.receiptId.value : this.receiptId,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DashainPlan(')
          ..write('year: $year, ')
          ..write('festivalDay: $festivalDay, ')
          ..write('currency: $currency, ')
          ..write('salaryMinor: $salaryMinor, ')
          ..write('allowancesMinor: $allowancesMinor, ')
          ..write('receiptId: $receiptId, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    year,
    festivalDay,
    currency,
    salaryMinor,
    allowancesMinor,
    receiptId,
    revision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DashainPlan &&
          other.year == this.year &&
          other.festivalDay == this.festivalDay &&
          other.currency == this.currency &&
          other.salaryMinor == this.salaryMinor &&
          other.allowancesMinor == this.allowancesMinor &&
          other.receiptId == this.receiptId &&
          other.revision == this.revision);
}

class DashainPlansCompanion extends UpdateCompanion<DashainPlan> {
  final Value<int> year;
  final Value<int> festivalDay;
  final Value<String> currency;
  final Value<int> salaryMinor;
  final Value<int> allowancesMinor;
  final Value<int?> receiptId;
  final Value<int> revision;
  const DashainPlansCompanion({
    this.year = const Value.absent(),
    this.festivalDay = const Value.absent(),
    this.currency = const Value.absent(),
    this.salaryMinor = const Value.absent(),
    this.allowancesMinor = const Value.absent(),
    this.receiptId = const Value.absent(),
    this.revision = const Value.absent(),
  });
  DashainPlansCompanion.insert({
    this.year = const Value.absent(),
    required int festivalDay,
    required String currency,
    required int salaryMinor,
    required int allowancesMinor,
    this.receiptId = const Value.absent(),
    this.revision = const Value.absent(),
  }) : festivalDay = Value(festivalDay),
       currency = Value(currency),
       salaryMinor = Value(salaryMinor),
       allowancesMinor = Value(allowancesMinor);
  static Insertable<DashainPlan> custom({
    Expression<int>? year,
    Expression<int>? festivalDay,
    Expression<String>? currency,
    Expression<int>? salaryMinor,
    Expression<int>? allowancesMinor,
    Expression<int>? receiptId,
    Expression<int>? revision,
  }) {
    return RawValuesInsertable({
      if (year != null) 'year': year,
      if (festivalDay != null) 'festival_day': festivalDay,
      if (currency != null) 'currency': currency,
      if (salaryMinor != null) 'salary_minor': salaryMinor,
      if (allowancesMinor != null) 'allowances_minor': allowancesMinor,
      if (receiptId != null) 'receipt_id': receiptId,
      if (revision != null) 'revision': revision,
    });
  }

  DashainPlansCompanion copyWith({
    Value<int>? year,
    Value<int>? festivalDay,
    Value<String>? currency,
    Value<int>? salaryMinor,
    Value<int>? allowancesMinor,
    Value<int?>? receiptId,
    Value<int>? revision,
  }) {
    return DashainPlansCompanion(
      year: year ?? this.year,
      festivalDay: festivalDay ?? this.festivalDay,
      currency: currency ?? this.currency,
      salaryMinor: salaryMinor ?? this.salaryMinor,
      allowancesMinor: allowancesMinor ?? this.allowancesMinor,
      receiptId: receiptId ?? this.receiptId,
      revision: revision ?? this.revision,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (festivalDay.present) {
      map['festival_day'] = Variable<int>(festivalDay.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (salaryMinor.present) {
      map['salary_minor'] = Variable<int>(salaryMinor.value);
    }
    if (allowancesMinor.present) {
      map['allowances_minor'] = Variable<int>(allowancesMinor.value);
    }
    if (receiptId.present) {
      map['receipt_id'] = Variable<int>(receiptId.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashainPlansCompanion(')
          ..write('year: $year, ')
          ..write('festivalDay: $festivalDay, ')
          ..write('currency: $currency, ')
          ..write('salaryMinor: $salaryMinor, ')
          ..write('allowancesMinor: $allowancesMinor, ')
          ..write('receiptId: $receiptId, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }
}

class $AnnualTicketsTable extends AnnualTickets
    with TableInfo<$AnnualTicketsTable, AnnualTicket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnnualTicketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _policyVersionMeta = const VerificationMeta(
    'policyVersion',
  );
  @override
  late final GeneratedColumn<int> policyVersion = GeneratedColumn<int>(
    'policy_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedDayMeta = const VerificationMeta(
    'receivedDay',
  );
  @override
  late final GeneratedColumn<int> receivedDay = GeneratedColumn<int>(
    'received_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usedDayMeta = const VerificationMeta(
    'usedDay',
  );
  @override
  late final GeneratedColumn<int> usedDay = GeneratedColumn<int>(
    'used_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leaveIdMeta = const VerificationMeta(
    'leaveId',
  );
  @override
  late final GeneratedColumn<int> leaveId = GeneratedColumn<int>(
    'leave_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES leave_entries (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    year,
    policyVersion,
    receivedDay,
    usedDay,
    leaveId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'annual_tickets';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnnualTicket> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('policy_version')) {
      context.handle(
        _policyVersionMeta,
        policyVersion.isAcceptableOrUnknown(
          data['policy_version']!,
          _policyVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_policyVersionMeta);
    }
    if (data.containsKey('received_day')) {
      context.handle(
        _receivedDayMeta,
        receivedDay.isAcceptableOrUnknown(
          data['received_day']!,
          _receivedDayMeta,
        ),
      );
    }
    if (data.containsKey('used_day')) {
      context.handle(
        _usedDayMeta,
        usedDay.isAcceptableOrUnknown(data['used_day']!, _usedDayMeta),
      );
    }
    if (data.containsKey('leave_id')) {
      context.handle(
        _leaveIdMeta,
        leaveId.isAcceptableOrUnknown(data['leave_id']!, _leaveIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {year};
  @override
  AnnualTicket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnnualTicket(
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      policyVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}policy_version'],
      )!,
      receivedDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}received_day'],
      ),
      usedDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}used_day'],
      ),
      leaveId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leave_id'],
      ),
    );
  }

  @override
  $AnnualTicketsTable createAlias(String alias) {
    return $AnnualTicketsTable(attachedDatabase, alias);
  }
}

class AnnualTicket extends DataClass implements Insertable<AnnualTicket> {
  final int year;
  final int policyVersion;
  final int? receivedDay;
  final int? usedDay;
  final int? leaveId;
  const AnnualTicket({
    required this.year,
    required this.policyVersion,
    this.receivedDay,
    this.usedDay,
    this.leaveId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['year'] = Variable<int>(year);
    map['policy_version'] = Variable<int>(policyVersion);
    if (!nullToAbsent || receivedDay != null) {
      map['received_day'] = Variable<int>(receivedDay);
    }
    if (!nullToAbsent || usedDay != null) {
      map['used_day'] = Variable<int>(usedDay);
    }
    if (!nullToAbsent || leaveId != null) {
      map['leave_id'] = Variable<int>(leaveId);
    }
    return map;
  }

  AnnualTicketsCompanion toCompanion(bool nullToAbsent) {
    return AnnualTicketsCompanion(
      year: Value(year),
      policyVersion: Value(policyVersion),
      receivedDay: receivedDay == null && nullToAbsent
          ? const Value.absent()
          : Value(receivedDay),
      usedDay: usedDay == null && nullToAbsent
          ? const Value.absent()
          : Value(usedDay),
      leaveId: leaveId == null && nullToAbsent
          ? const Value.absent()
          : Value(leaveId),
    );
  }

  factory AnnualTicket.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnnualTicket(
      year: serializer.fromJson<int>(json['year']),
      policyVersion: serializer.fromJson<int>(json['policyVersion']),
      receivedDay: serializer.fromJson<int?>(json['receivedDay']),
      usedDay: serializer.fromJson<int?>(json['usedDay']),
      leaveId: serializer.fromJson<int?>(json['leaveId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'year': serializer.toJson<int>(year),
      'policyVersion': serializer.toJson<int>(policyVersion),
      'receivedDay': serializer.toJson<int?>(receivedDay),
      'usedDay': serializer.toJson<int?>(usedDay),
      'leaveId': serializer.toJson<int?>(leaveId),
    };
  }

  AnnualTicket copyWith({
    int? year,
    int? policyVersion,
    Value<int?> receivedDay = const Value.absent(),
    Value<int?> usedDay = const Value.absent(),
    Value<int?> leaveId = const Value.absent(),
  }) => AnnualTicket(
    year: year ?? this.year,
    policyVersion: policyVersion ?? this.policyVersion,
    receivedDay: receivedDay.present ? receivedDay.value : this.receivedDay,
    usedDay: usedDay.present ? usedDay.value : this.usedDay,
    leaveId: leaveId.present ? leaveId.value : this.leaveId,
  );
  AnnualTicket copyWithCompanion(AnnualTicketsCompanion data) {
    return AnnualTicket(
      year: data.year.present ? data.year.value : this.year,
      policyVersion: data.policyVersion.present
          ? data.policyVersion.value
          : this.policyVersion,
      receivedDay: data.receivedDay.present
          ? data.receivedDay.value
          : this.receivedDay,
      usedDay: data.usedDay.present ? data.usedDay.value : this.usedDay,
      leaveId: data.leaveId.present ? data.leaveId.value : this.leaveId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnnualTicket(')
          ..write('year: $year, ')
          ..write('policyVersion: $policyVersion, ')
          ..write('receivedDay: $receivedDay, ')
          ..write('usedDay: $usedDay, ')
          ..write('leaveId: $leaveId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(year, policyVersion, receivedDay, usedDay, leaveId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnnualTicket &&
          other.year == this.year &&
          other.policyVersion == this.policyVersion &&
          other.receivedDay == this.receivedDay &&
          other.usedDay == this.usedDay &&
          other.leaveId == this.leaveId);
}

class AnnualTicketsCompanion extends UpdateCompanion<AnnualTicket> {
  final Value<int> year;
  final Value<int> policyVersion;
  final Value<int?> receivedDay;
  final Value<int?> usedDay;
  final Value<int?> leaveId;
  const AnnualTicketsCompanion({
    this.year = const Value.absent(),
    this.policyVersion = const Value.absent(),
    this.receivedDay = const Value.absent(),
    this.usedDay = const Value.absent(),
    this.leaveId = const Value.absent(),
  });
  AnnualTicketsCompanion.insert({
    this.year = const Value.absent(),
    required int policyVersion,
    this.receivedDay = const Value.absent(),
    this.usedDay = const Value.absent(),
    this.leaveId = const Value.absent(),
  }) : policyVersion = Value(policyVersion);
  static Insertable<AnnualTicket> custom({
    Expression<int>? year,
    Expression<int>? policyVersion,
    Expression<int>? receivedDay,
    Expression<int>? usedDay,
    Expression<int>? leaveId,
  }) {
    return RawValuesInsertable({
      if (year != null) 'year': year,
      if (policyVersion != null) 'policy_version': policyVersion,
      if (receivedDay != null) 'received_day': receivedDay,
      if (usedDay != null) 'used_day': usedDay,
      if (leaveId != null) 'leave_id': leaveId,
    });
  }

  AnnualTicketsCompanion copyWith({
    Value<int>? year,
    Value<int>? policyVersion,
    Value<int?>? receivedDay,
    Value<int?>? usedDay,
    Value<int?>? leaveId,
  }) {
    return AnnualTicketsCompanion(
      year: year ?? this.year,
      policyVersion: policyVersion ?? this.policyVersion,
      receivedDay: receivedDay ?? this.receivedDay,
      usedDay: usedDay ?? this.usedDay,
      leaveId: leaveId ?? this.leaveId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (policyVersion.present) {
      map['policy_version'] = Variable<int>(policyVersion.value);
    }
    if (receivedDay.present) {
      map['received_day'] = Variable<int>(receivedDay.value);
    }
    if (usedDay.present) {
      map['used_day'] = Variable<int>(usedDay.value);
    }
    if (leaveId.present) {
      map['leave_id'] = Variable<int>(leaveId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnualTicketsCompanion(')
          ..write('year: $year, ')
          ..write('policyVersion: $policyVersion, ')
          ..write('receivedDay: $receivedDay, ')
          ..write('usedDay: $usedDay, ')
          ..write('leaveId: $leaveId')
          ..write(')'))
        .toString();
  }
}

class $TravelGoalsTable extends TravelGoals
    with TableInfo<$TravelGoalsTable, TravelGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TravelGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES currencies (code)',
    ),
  );
  static const VerificationMeta _targetDayMeta = const VerificationMeta(
    'targetDay',
  );
  @override
  late final GeneratedColumn<int> targetDay = GeneratedColumn<int>(
    'target_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripMinorMeta = const VerificationMeta(
    'tripMinor',
  );
  @override
  late final GeneratedColumn<int> tripMinor = GeneratedColumn<int>(
    'trip_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _airfareMinorMeta = const VerificationMeta(
    'airfareMinor',
  );
  @override
  late final GeneratedColumn<int> airfareMinor = GeneratedColumn<int>(
    'airfare_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currency,
    targetDay,
    tripMinor,
    airfareMinor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'travel_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<TravelGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('target_day')) {
      context.handle(
        _targetDayMeta,
        targetDay.isAcceptableOrUnknown(data['target_day']!, _targetDayMeta),
      );
    } else if (isInserting) {
      context.missing(_targetDayMeta);
    }
    if (data.containsKey('trip_minor')) {
      context.handle(
        _tripMinorMeta,
        tripMinor.isAcceptableOrUnknown(data['trip_minor']!, _tripMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_tripMinorMeta);
    }
    if (data.containsKey('airfare_minor')) {
      context.handle(
        _airfareMinorMeta,
        airfareMinor.isAcceptableOrUnknown(
          data['airfare_minor']!,
          _airfareMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_airfareMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TravelGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TravelGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      targetDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_day'],
      )!,
      tripMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_minor'],
      )!,
      airfareMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}airfare_minor'],
      )!,
    );
  }

  @override
  $TravelGoalsTable createAlias(String alias) {
    return $TravelGoalsTable(attachedDatabase, alias);
  }
}

class TravelGoal extends DataClass implements Insertable<TravelGoal> {
  final int id;
  final String currency;
  final int targetDay;
  final int tripMinor;
  final int airfareMinor;
  const TravelGoal({
    required this.id,
    required this.currency,
    required this.targetDay,
    required this.tripMinor,
    required this.airfareMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['currency'] = Variable<String>(currency);
    map['target_day'] = Variable<int>(targetDay);
    map['trip_minor'] = Variable<int>(tripMinor);
    map['airfare_minor'] = Variable<int>(airfareMinor);
    return map;
  }

  TravelGoalsCompanion toCompanion(bool nullToAbsent) {
    return TravelGoalsCompanion(
      id: Value(id),
      currency: Value(currency),
      targetDay: Value(targetDay),
      tripMinor: Value(tripMinor),
      airfareMinor: Value(airfareMinor),
    );
  }

  factory TravelGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TravelGoal(
      id: serializer.fromJson<int>(json['id']),
      currency: serializer.fromJson<String>(json['currency']),
      targetDay: serializer.fromJson<int>(json['targetDay']),
      tripMinor: serializer.fromJson<int>(json['tripMinor']),
      airfareMinor: serializer.fromJson<int>(json['airfareMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currency': serializer.toJson<String>(currency),
      'targetDay': serializer.toJson<int>(targetDay),
      'tripMinor': serializer.toJson<int>(tripMinor),
      'airfareMinor': serializer.toJson<int>(airfareMinor),
    };
  }

  TravelGoal copyWith({
    int? id,
    String? currency,
    int? targetDay,
    int? tripMinor,
    int? airfareMinor,
  }) => TravelGoal(
    id: id ?? this.id,
    currency: currency ?? this.currency,
    targetDay: targetDay ?? this.targetDay,
    tripMinor: tripMinor ?? this.tripMinor,
    airfareMinor: airfareMinor ?? this.airfareMinor,
  );
  TravelGoal copyWithCompanion(TravelGoalsCompanion data) {
    return TravelGoal(
      id: data.id.present ? data.id.value : this.id,
      currency: data.currency.present ? data.currency.value : this.currency,
      targetDay: data.targetDay.present ? data.targetDay.value : this.targetDay,
      tripMinor: data.tripMinor.present ? data.tripMinor.value : this.tripMinor,
      airfareMinor: data.airfareMinor.present
          ? data.airfareMinor.value
          : this.airfareMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TravelGoal(')
          ..write('id: $id, ')
          ..write('currency: $currency, ')
          ..write('targetDay: $targetDay, ')
          ..write('tripMinor: $tripMinor, ')
          ..write('airfareMinor: $airfareMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, currency, targetDay, tripMinor, airfareMinor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TravelGoal &&
          other.id == this.id &&
          other.currency == this.currency &&
          other.targetDay == this.targetDay &&
          other.tripMinor == this.tripMinor &&
          other.airfareMinor == this.airfareMinor);
}

class TravelGoalsCompanion extends UpdateCompanion<TravelGoal> {
  final Value<int> id;
  final Value<String> currency;
  final Value<int> targetDay;
  final Value<int> tripMinor;
  final Value<int> airfareMinor;
  const TravelGoalsCompanion({
    this.id = const Value.absent(),
    this.currency = const Value.absent(),
    this.targetDay = const Value.absent(),
    this.tripMinor = const Value.absent(),
    this.airfareMinor = const Value.absent(),
  });
  TravelGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String currency,
    required int targetDay,
    required int tripMinor,
    required int airfareMinor,
  }) : currency = Value(currency),
       targetDay = Value(targetDay),
       tripMinor = Value(tripMinor),
       airfareMinor = Value(airfareMinor);
  static Insertable<TravelGoal> custom({
    Expression<int>? id,
    Expression<String>? currency,
    Expression<int>? targetDay,
    Expression<int>? tripMinor,
    Expression<int>? airfareMinor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currency != null) 'currency': currency,
      if (targetDay != null) 'target_day': targetDay,
      if (tripMinor != null) 'trip_minor': tripMinor,
      if (airfareMinor != null) 'airfare_minor': airfareMinor,
    });
  }

  TravelGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? currency,
    Value<int>? targetDay,
    Value<int>? tripMinor,
    Value<int>? airfareMinor,
  }) {
    return TravelGoalsCompanion(
      id: id ?? this.id,
      currency: currency ?? this.currency,
      targetDay: targetDay ?? this.targetDay,
      tripMinor: tripMinor ?? this.tripMinor,
      airfareMinor: airfareMinor ?? this.airfareMinor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (targetDay.present) {
      map['target_day'] = Variable<int>(targetDay.value);
    }
    if (tripMinor.present) {
      map['trip_minor'] = Variable<int>(tripMinor.value);
    }
    if (airfareMinor.present) {
      map['airfare_minor'] = Variable<int>(airfareMinor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TravelGoalsCompanion(')
          ..write('id: $id, ')
          ..write('currency: $currency, ')
          ..write('targetDay: $targetDay, ')
          ..write('tripMinor: $tripMinor, ')
          ..write('airfareMinor: $airfareMinor')
          ..write(')'))
        .toString();
  }
}

class $TravelContributionsTable extends TravelContributions
    with TableInfo<$TravelContributionsTable, TravelContribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TravelContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES travel_goals (id)',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ledger_accounts (id)',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minorMeta = const VerificationMeta('minor');
  @override
  late final GeneratedColumn<int> minor = GeneratedColumn<int>(
    'minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    goalId,
    accountId,
    day,
    minor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'travel_contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TravelContribution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('minor')) {
      context.handle(
        _minorMeta,
        minor.isAcceptableOrUnknown(data['minor']!, _minorMeta),
      );
    } else if (isInserting) {
      context.missing(_minorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  TravelContribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TravelContribution(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      minor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minor'],
      )!,
    );
  }

  @override
  $TravelContributionsTable createAlias(String alias) {
    return $TravelContributionsTable(attachedDatabase, alias);
  }
}

class TravelContribution extends DataClass
    implements Insertable<TravelContribution> {
  final String operationId;
  final int goalId;
  final int accountId;
  final int day;
  final int minor;
  const TravelContribution({
    required this.operationId,
    required this.goalId,
    required this.accountId,
    required this.day,
    required this.minor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['goal_id'] = Variable<int>(goalId);
    map['account_id'] = Variable<int>(accountId);
    map['day'] = Variable<int>(day);
    map['minor'] = Variable<int>(minor);
    return map;
  }

  TravelContributionsCompanion toCompanion(bool nullToAbsent) {
    return TravelContributionsCompanion(
      operationId: Value(operationId),
      goalId: Value(goalId),
      accountId: Value(accountId),
      day: Value(day),
      minor: Value(minor),
    );
  }

  factory TravelContribution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TravelContribution(
      operationId: serializer.fromJson<String>(json['operationId']),
      goalId: serializer.fromJson<int>(json['goalId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      day: serializer.fromJson<int>(json['day']),
      minor: serializer.fromJson<int>(json['minor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'goalId': serializer.toJson<int>(goalId),
      'accountId': serializer.toJson<int>(accountId),
      'day': serializer.toJson<int>(day),
      'minor': serializer.toJson<int>(minor),
    };
  }

  TravelContribution copyWith({
    String? operationId,
    int? goalId,
    int? accountId,
    int? day,
    int? minor,
  }) => TravelContribution(
    operationId: operationId ?? this.operationId,
    goalId: goalId ?? this.goalId,
    accountId: accountId ?? this.accountId,
    day: day ?? this.day,
    minor: minor ?? this.minor,
  );
  TravelContribution copyWithCompanion(TravelContributionsCompanion data) {
    return TravelContribution(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      day: data.day.present ? data.day.value : this.day,
      minor: data.minor.present ? data.minor.value : this.minor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TravelContribution(')
          ..write('operationId: $operationId, ')
          ..write('goalId: $goalId, ')
          ..write('accountId: $accountId, ')
          ..write('day: $day, ')
          ..write('minor: $minor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(operationId, goalId, accountId, day, minor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TravelContribution &&
          other.operationId == this.operationId &&
          other.goalId == this.goalId &&
          other.accountId == this.accountId &&
          other.day == this.day &&
          other.minor == this.minor);
}

class TravelContributionsCompanion extends UpdateCompanion<TravelContribution> {
  final Value<String> operationId;
  final Value<int> goalId;
  final Value<int> accountId;
  final Value<int> day;
  final Value<int> minor;
  final Value<int> rowid;
  const TravelContributionsCompanion({
    this.operationId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.day = const Value.absent(),
    this.minor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TravelContributionsCompanion.insert({
    required String operationId,
    required int goalId,
    required int accountId,
    required int day,
    required int minor,
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       goalId = Value(goalId),
       accountId = Value(accountId),
       day = Value(day),
       minor = Value(minor);
  static Insertable<TravelContribution> custom({
    Expression<String>? operationId,
    Expression<int>? goalId,
    Expression<int>? accountId,
    Expression<int>? day,
    Expression<int>? minor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (goalId != null) 'goal_id': goalId,
      if (accountId != null) 'account_id': accountId,
      if (day != null) 'day': day,
      if (minor != null) 'minor': minor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TravelContributionsCompanion copyWith({
    Value<String>? operationId,
    Value<int>? goalId,
    Value<int>? accountId,
    Value<int>? day,
    Value<int>? minor,
    Value<int>? rowid,
  }) {
    return TravelContributionsCompanion(
      operationId: operationId ?? this.operationId,
      goalId: goalId ?? this.goalId,
      accountId: accountId ?? this.accountId,
      day: day ?? this.day,
      minor: minor ?? this.minor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (minor.present) {
      map['minor'] = Variable<int>(minor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TravelContributionsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('goalId: $goalId, ')
          ..write('accountId: $accountId, ')
          ..write('day: $day, ')
          ..write('minor: $minor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LedgerDatabase extends GeneratedDatabase {
  _$LedgerDatabase(QueryExecutor e) : super(e);
  $LedgerDatabaseManager get managers => $LedgerDatabaseManager(this);
  late final $CurrenciesTable currencies = $CurrenciesTable(this);
  late final $LedgerAccountsTable ledgerAccounts = $LedgerAccountsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $JournalPostingsTable journalPostings = $JournalPostingsTable(
    this,
  );
  late final $SalaryReceiptsTable salaryReceipts = $SalaryReceiptsTable(this);
  late final $SalaryPlansTable salaryPlans = $SalaryPlansTable(this);
  late final $SalaryAllocationsTable salaryAllocations =
      $SalaryAllocationsTable(this);
  late final $SalaryExecutionsTable salaryExecutions = $SalaryExecutionsTable(
    this,
  );
  late final $MovementConfirmationsTable movementConfirmations =
      $MovementConfirmationsTable(this);
  late final $CashSettingsTable cashSettings = $CashSettingsTable(this);
  late final $CashReconciliationsTable cashReconciliations =
      $CashReconciliationsTable(this);
  late final $ExpenseDetailsTable expenseDetails = $ExpenseDetailsTable(this);
  late final $RemittancesTable remittances = $RemittancesTable(this);
  late final $RemittanceEventsTable remittanceEvents = $RemittanceEventsTable(
    this,
  );
  late final $RemittancePurposesTable remittancePurposes =
      $RemittancePurposesTable(this);
  late final $RemittanceFamilyPaymentsTable remittanceFamilyPayments =
      $RemittanceFamilyPaymentsTable(this);
  late final $LeaveRulesTable leaveRules = $LeaveRulesTable(this);
  late final $LeaveEntriesTable leaveEntries = $LeaveEntriesTable(this);
  late final $LeaveHolidaysTable leaveHolidays = $LeaveHolidaysTable(this);
  late final $DashainPlansTable dashainPlans = $DashainPlansTable(this);
  late final $AnnualTicketsTable annualTickets = $AnnualTicketsTable(this);
  late final $TravelGoalsTable travelGoals = $TravelGoalsTable(this);
  late final $TravelContributionsTable travelContributions =
      $TravelContributionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    currencies,
    ledgerAccounts,
    journalEntries,
    journalPostings,
    salaryReceipts,
    salaryPlans,
    salaryAllocations,
    salaryExecutions,
    movementConfirmations,
    cashSettings,
    cashReconciliations,
    expenseDetails,
    remittances,
    remittanceEvents,
    remittancePurposes,
    remittanceFamilyPayments,
    leaveRules,
    leaveEntries,
    leaveHolidays,
    dashainPlans,
    annualTickets,
    travelGoals,
    travelContributions,
  ];
}

typedef $$CurrenciesTableCreateCompanionBuilder = CurrenciesCompanion Function({
  required String code,
  required int scale,
  Value<int> rowid,
});
typedef $$CurrenciesTableUpdateCompanionBuilder = CurrenciesCompanion Function({
  Value<String> code,
  Value<int> scale,
  Value<int> rowid,
});

final class $$CurrenciesTableReferences
    extends BaseReferences<_$LedgerDatabase, $CurrenciesTable, Currency> {
  $$CurrenciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LedgerAccountsTable, List<LedgerAccount>>
  _ledgerAccountsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ledgerAccounts,
        aliasName: 'currencies__code__ledger_accounts__currency',
      );

  $$LedgerAccountsTableProcessedTableManager get ledgerAccountsRefs {
    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.currency.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_ledgerAccountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemittancesTable, List<Remittance>>
  _remittancesRefsTable(_$LedgerDatabase db) => MultiTypedResultKey.fromTable(
    db.remittances,
    aliasName: 'currencies__code__remittances__destination_currency',
  );

  $$RemittancesTableProcessedTableManager get remittancesRefs {
    final manager = $$RemittancesTableTableManager($_db, $_db.remittances)
        .filter(
          (f) => f.destinationCurrency.code.sqlEquals(
            $_itemColumn<String>('code')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_remittancesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DashainPlansTable, List<DashainPlan>>
  _dashainPlansRefsTable(_$LedgerDatabase db) => MultiTypedResultKey.fromTable(
    db.dashainPlans,
    aliasName: 'currencies__code__dashain_plans__currency',
  );

  $$DashainPlansTableProcessedTableManager get dashainPlansRefs {
    final manager = $$DashainPlansTableTableManager(
      $_db,
      $_db.dashainPlans,
    ).filter((f) => f.currency.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_dashainPlansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TravelGoalsTable, List<TravelGoal>>
  _travelGoalsRefsTable(_$LedgerDatabase db) => MultiTypedResultKey.fromTable(
    db.travelGoals,
    aliasName: 'currencies__code__travel_goals__currency',
  );

  $$TravelGoalsTableProcessedTableManager get travelGoalsRefs {
    final manager = $$TravelGoalsTableTableManager(
      $_db,
      $_db.travelGoals,
    ).filter((f) => f.currency.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_travelGoalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CurrenciesTableFilterComposer
    extends Composer<_$LedgerDatabase, $CurrenciesTable> {
  $$CurrenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scale => $composableBuilder(
    column: $table.scale,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ledgerAccountsRefs(
    Expression<bool> Function($$LedgerAccountsTableFilterComposer f) f,
  ) {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remittancesRefs(
    Expression<bool> Function($$RemittancesTableFilterComposer f) f,
  ) {
    final $$RemittancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.destinationCurrency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableFilterComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dashainPlansRefs(
    Expression<bool> Function($$DashainPlansTableFilterComposer f) f,
  ) {
    final $$DashainPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.dashainPlans,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DashainPlansTableFilterComposer(
            $db: $db,
            $table: $db.dashainPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> travelGoalsRefs(
    Expression<bool> Function($$TravelGoalsTableFilterComposer f) f,
  ) {
    final $$TravelGoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.travelGoals,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TravelGoalsTableFilterComposer(
            $db: $db,
            $table: $db.travelGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CurrenciesTableOrderingComposer
    extends Composer<_$LedgerDatabase, $CurrenciesTable> {
  $$CurrenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scale => $composableBuilder(
    column: $table.scale,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CurrenciesTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $CurrenciesTable> {
  $$CurrenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get scale =>
      $composableBuilder(column: $table.scale, builder: (column) => column);

  Expression<T> ledgerAccountsRefs<T extends Object>(
    Expression<T> Function($$LedgerAccountsTableAnnotationComposer a) f,
  ) {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remittancesRefs<T extends Object>(
    Expression<T> Function($$RemittancesTableAnnotationComposer a) f,
  ) {
    final $$RemittancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.destinationCurrency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableAnnotationComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dashainPlansRefs<T extends Object>(
    Expression<T> Function($$DashainPlansTableAnnotationComposer a) f,
  ) {
    final $$DashainPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.dashainPlans,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DashainPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.dashainPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> travelGoalsRefs<T extends Object>(
    Expression<T> Function($$TravelGoalsTableAnnotationComposer a) f,
  ) {
    final $$TravelGoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.travelGoals,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TravelGoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.travelGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CurrenciesTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $CurrenciesTable,
          Currency,
          $$CurrenciesTableFilterComposer,
          $$CurrenciesTableOrderingComposer,
          $$CurrenciesTableAnnotationComposer,
          $$CurrenciesTableCreateCompanionBuilder,
          $$CurrenciesTableUpdateCompanionBuilder,
          (Currency, $$CurrenciesTableReferences),
          Currency,
          PrefetchHooks Function({
            bool ledgerAccountsRefs,
            bool remittancesRefs,
            bool dashainPlansRefs,
            bool travelGoalsRefs,
          })
        > {
  $$CurrenciesTableTableManager(_$LedgerDatabase db, $CurrenciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<int> scale = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => CurrenciesCompanion(code: code, scale: scale, rowid: rowid),
          createCompanionCallback:
              ({
                required String code,
                required int scale,
                Value<int> rowid = const Value.absent(),
              }) => CurrenciesCompanion.insert(
                code: code,
                scale: scale,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CurrenciesTable, Currency>(table),
                  $$CurrenciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ledgerAccountsRefs = false,
                remittancesRefs = false,
                dashainPlansRefs = false,
                travelGoalsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ledgerAccountsRefs) db.ledgerAccounts,
                    if (remittancesRefs) db.remittances,
                    if (dashainPlansRefs) db.dashainPlans,
                    if (travelGoalsRefs) db.travelGoals,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ledgerAccountsRefs)
                        await $_getPrefetchedDataByColumns<
                          Currency,
                          $CurrenciesTable,
                          LedgerAccount,
                          $LedgerAccountsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CurrenciesTableReferences
                              ._ledgerAccountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CurrenciesTableReferences(
                                db,
                                table,
                                p0,
                              ).ledgerAccountsRefs,
                          currentColumn: 'code',
                          referencedColumn: 'currency',
                          typedResults: items,
                        ),
                      if (remittancesRefs)
                        await $_getPrefetchedDataByColumns<
                          Currency,
                          $CurrenciesTable,
                          Remittance,
                          $RemittancesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CurrenciesTableReferences
                              ._remittancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CurrenciesTableReferences(
                                db,
                                table,
                                p0,
                              ).remittancesRefs,
                          currentColumn: 'code',
                          referencedColumn: 'destination_currency',
                          typedResults: items,
                        ),
                      if (dashainPlansRefs)
                        await $_getPrefetchedDataByColumns<
                          Currency,
                          $CurrenciesTable,
                          DashainPlan,
                          $DashainPlansTable
                        >(
                          currentTable: table,
                          referencedTable: $$CurrenciesTableReferences
                              ._dashainPlansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CurrenciesTableReferences(
                                db,
                                table,
                                p0,
                              ).dashainPlansRefs,
                          currentColumn: 'code',
                          referencedColumn: 'currency',
                          typedResults: items,
                        ),
                      if (travelGoalsRefs)
                        await $_getPrefetchedDataByColumns<
                          Currency,
                          $CurrenciesTable,
                          TravelGoal,
                          $TravelGoalsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CurrenciesTableReferences
                              ._travelGoalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CurrenciesTableReferences(
                                db,
                                table,
                                p0,
                              ).travelGoalsRefs,
                          currentColumn: 'code',
                          referencedColumn: 'currency',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CurrenciesTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $CurrenciesTable,
      Currency,
      $$CurrenciesTableFilterComposer,
      $$CurrenciesTableOrderingComposer,
      $$CurrenciesTableAnnotationComposer,
      $$CurrenciesTableCreateCompanionBuilder,
      $$CurrenciesTableUpdateCompanionBuilder,
      (Currency, $$CurrenciesTableReferences),
      Currency,
      PrefetchHooks Function({
        bool ledgerAccountsRefs,
        bool remittancesRefs,
        bool dashainPlansRefs,
        bool travelGoalsRefs,
      })
    >;
typedef $$LedgerAccountsTableCreateCompanionBuilder =
    LedgerAccountsCompanion Function({
      Value<int> id,
      required String name,
      required String currency,
      required AccountKind kind,
    });
typedef $$LedgerAccountsTableUpdateCompanionBuilder =
    LedgerAccountsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> currency,
      Value<AccountKind> kind,
    });

final class $$LedgerAccountsTableReferences
    extends
        BaseReferences<_$LedgerDatabase, $LedgerAccountsTable, LedgerAccount> {
  $$LedgerAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CurrenciesTable _currencyTable(_$LedgerDatabase db) =>
      db.currencies.createAlias('ledger_accounts__currency__currencies__code');

  $$CurrenciesTableProcessedTableManager get currency {
    final $_column = $_itemColumn<String>('currency')!;

    final manager = $$CurrenciesTableTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$JournalEntriesTable, List<JournalEntry>>
  _journalEntriesRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalEntries,
        aliasName: 'ledger_accounts__id__journal_entries__opening_account_id',
      );

  $$JournalEntriesTableProcessedTableManager get journalEntriesRefs {
    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.openingAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_journalEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$JournalPostingsTable, List<JournalPosting>>
  _journalPostingsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalPostings,
        aliasName: 'ledger_accounts__id__journal_postings__account_id',
      );

  $$JournalPostingsTableProcessedTableManager get journalPostingsRefs {
    final manager = $$JournalPostingsTableTableManager(
      $_db,
      $_db.journalPostings,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalPostingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SalaryReceiptsTable, List<SalaryReceipt>>
  _salaryReceiptsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.salaryReceipts,
        aliasName: 'ledger_accounts__id__salary_receipts__account_id',
      );

  $$SalaryReceiptsTableProcessedTableManager get salaryReceiptsRefs {
    final manager = $$SalaryReceiptsTableTableManager(
      $_db,
      $_db.salaryReceipts,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salaryReceiptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CashSettingsTable, List<CashSetting>>
  _cashSettingsRefsTable(_$LedgerDatabase db) => MultiTypedResultKey.fromTable(
    db.cashSettings,
    aliasName: 'ledger_accounts__id__cash_settings__cash_account_id',
  );

  $$CashSettingsTableProcessedTableManager get cashSettingsRefs {
    final manager = $$CashSettingsTableTableManager(
      $_db,
      $_db.cashSettings,
    ).filter((f) => f.cashAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cashSettingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CashReconciliationsTable,
    List<CashReconciliation>
  >
  _cashReconciliationsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cashReconciliations,
        aliasName: 'ledger_accounts__id__cash_reconciliations__account_id',
      );

  $$CashReconciliationsTableProcessedTableManager get cashReconciliationsRefs {
    final manager = $$CashReconciliationsTableTableManager(
      $_db,
      $_db.cashReconciliations,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cashReconciliationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemittancesTable, List<Remittance>>
  _outgoingRemittancesTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.remittances,
        aliasName: 'ledger_accounts__id__remittances__source_account_id',
      );

  $$RemittancesTableProcessedTableManager get outgoingRemittances {
    final manager = $$RemittancesTableTableManager(
      $_db,
      $_db.remittances,
    ).filter((f) => f.sourceAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _outgoingRemittancesTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemittancesTable, List<Remittance>>
  _incomingRemittancesTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.remittances,
        aliasName: 'ledger_accounts__id__remittances__destination_account_id',
      );

  $$RemittancesTableProcessedTableManager get incomingRemittances {
    final manager = $$RemittancesTableTableManager($_db, $_db.remittances)
        .filter(
          (f) => f.destinationAccountId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _incomingRemittancesTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TravelContributionsTable,
    List<TravelContribution>
  >
  _travelContributionsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.travelContributions,
        aliasName: 'ledger_accounts__id__travel_contributions__account_id',
      );

  $$TravelContributionsTableProcessedTableManager get travelContributionsRefs {
    final manager = $$TravelContributionsTableTableManager(
      $_db,
      $_db.travelContributions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _travelContributionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LedgerAccountsTableFilterComposer
    extends Composer<_$LedgerDatabase, $LedgerAccountsTable> {
  $$LedgerAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AccountKind, AccountKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$CurrenciesTableFilterComposer get currency {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> journalEntriesRefs(
    Expression<bool> Function($$JournalEntriesTableFilterComposer f) f,
  ) {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.openingAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journalPostingsRefs(
    Expression<bool> Function($$JournalPostingsTableFilterComposer f) f,
  ) {
    final $$JournalPostingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalPostings,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalPostingsTableFilterComposer(
            $db: $db,
            $table: $db.journalPostings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> salaryReceiptsRefs(
    Expression<bool> Function($$SalaryReceiptsTableFilterComposer f) f,
  ) {
    final $$SalaryReceiptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.salaryReceipts,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalaryReceiptsTableFilterComposer(
            $db: $db,
            $table: $db.salaryReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cashSettingsRefs(
    Expression<bool> Function($$CashSettingsTableFilterComposer f) f,
  ) {
    final $$CashSettingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashSettings,
      getReferencedColumn: (t) => t.cashAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashSettingsTableFilterComposer(
            $db: $db,
            $table: $db.cashSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cashReconciliationsRefs(
    Expression<bool> Function($$CashReconciliationsTableFilterComposer f) f,
  ) {
    final $$CashReconciliationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashReconciliations,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashReconciliationsTableFilterComposer(
            $db: $db,
            $table: $db.cashReconciliations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> outgoingRemittances(
    Expression<bool> Function($$RemittancesTableFilterComposer f) f,
  ) {
    final $$RemittancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.sourceAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableFilterComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomingRemittances(
    Expression<bool> Function($$RemittancesTableFilterComposer f) f,
  ) {
    final $$RemittancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.destinationAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableFilterComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> travelContributionsRefs(
    Expression<bool> Function($$TravelContributionsTableFilterComposer f) f,
  ) {
    final $$TravelContributionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.travelContributions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TravelContributionsTableFilterComposer(
            $db: $db,
            $table: $db.travelContributions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LedgerAccountsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $LedgerAccountsTable> {
  $$LedgerAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  $$CurrenciesTableOrderingComposer get currency {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerAccountsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $LedgerAccountsTable> {
  $$LedgerAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  $$CurrenciesTableAnnotationComposer get currency {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> journalEntriesRefs<T extends Object>(
    Expression<T> Function($$JournalEntriesTableAnnotationComposer a) f,
  ) {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.openingAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> journalPostingsRefs<T extends Object>(
    Expression<T> Function($$JournalPostingsTableAnnotationComposer a) f,
  ) {
    final $$JournalPostingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalPostings,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalPostingsTableAnnotationComposer(
            $db: $db,
            $table: $db.journalPostings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> salaryReceiptsRefs<T extends Object>(
    Expression<T> Function($$SalaryReceiptsTableAnnotationComposer a) f,
  ) {
    final $$SalaryReceiptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.salaryReceipts,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalaryReceiptsTableAnnotationComposer(
            $db: $db,
            $table: $db.salaryReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cashSettingsRefs<T extends Object>(
    Expression<T> Function($$CashSettingsTableAnnotationComposer a) f,
  ) {
    final $$CashSettingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashSettings,
      getReferencedColumn: (t) => t.cashAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashSettingsTableAnnotationComposer(
            $db: $db,
            $table: $db.cashSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cashReconciliationsRefs<T extends Object>(
    Expression<T> Function($$CashReconciliationsTableAnnotationComposer a) f,
  ) {
    final $$CashReconciliationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cashReconciliations,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CashReconciliationsTableAnnotationComposer(
                $db: $db,
                $table: $db.cashReconciliations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> outgoingRemittances<T extends Object>(
    Expression<T> Function($$RemittancesTableAnnotationComposer a) f,
  ) {
    final $$RemittancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.sourceAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableAnnotationComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomingRemittances<T extends Object>(
    Expression<T> Function($$RemittancesTableAnnotationComposer a) f,
  ) {
    final $$RemittancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.destinationAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableAnnotationComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> travelContributionsRefs<T extends Object>(
    Expression<T> Function($$TravelContributionsTableAnnotationComposer a) f,
  ) {
    final $$TravelContributionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.travelContributions,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TravelContributionsTableAnnotationComposer(
                $db: $db,
                $table: $db.travelContributions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LedgerAccountsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $LedgerAccountsTable,
          LedgerAccount,
          $$LedgerAccountsTableFilterComposer,
          $$LedgerAccountsTableOrderingComposer,
          $$LedgerAccountsTableAnnotationComposer,
          $$LedgerAccountsTableCreateCompanionBuilder,
          $$LedgerAccountsTableUpdateCompanionBuilder,
          (LedgerAccount, $$LedgerAccountsTableReferences),
          LedgerAccount,
          PrefetchHooks Function({
            bool currency,
            bool journalEntriesRefs,
            bool journalPostingsRefs,
            bool salaryReceiptsRefs,
            bool cashSettingsRefs,
            bool cashReconciliationsRefs,
            bool outgoingRemittances,
            bool incomingRemittances,
            bool travelContributionsRefs,
          })
        > {
  $$LedgerAccountsTableTableManager(
    _$LedgerDatabase db,
    $LedgerAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<AccountKind> kind = const Value.absent(),
              }) => LedgerAccountsCompanion(
                id: id,
                name: name,
                currency: currency,
                kind: kind,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String currency,
                required AccountKind kind,
              }) => LedgerAccountsCompanion.insert(
                id: id,
                name: name,
                currency: currency,
                kind: kind,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LedgerAccountsTable, LedgerAccount>(table),
                  $$LedgerAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                currency = false,
                journalEntriesRefs = false,
                journalPostingsRefs = false,
                salaryReceiptsRefs = false,
                cashSettingsRefs = false,
                cashReconciliationsRefs = false,
                outgoingRemittances = false,
                incomingRemittances = false,
                travelContributionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (journalEntriesRefs) db.journalEntries,
                    if (journalPostingsRefs) db.journalPostings,
                    if (salaryReceiptsRefs) db.salaryReceipts,
                    if (cashSettingsRefs) db.cashSettings,
                    if (cashReconciliationsRefs) db.cashReconciliations,
                    if (outgoingRemittances) db.remittances,
                    if (incomingRemittances) db.remittances,
                    if (travelContributionsRefs) db.travelContributions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (currency) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.currency,
                            referencedTable: $$LedgerAccountsTableReferences
                                ._currencyTable(db),
                            referencedColumn: $$LedgerAccountsTableReferences
                                ._currencyTable(db)
                                .code,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (journalEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          LedgerAccount,
                          $LedgerAccountsTable,
                          JournalEntry,
                          $JournalEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerAccountsTableReferences
                              ._journalEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).journalEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'opening_account_id',
                          typedResults: items,
                        ),
                      if (journalPostingsRefs)
                        await $_getPrefetchedDataByColumns<
                          LedgerAccount,
                          $LedgerAccountsTable,
                          JournalPosting,
                          $JournalPostingsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerAccountsTableReferences
                              ._journalPostingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).journalPostingsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                      if (salaryReceiptsRefs)
                        await $_getPrefetchedDataByColumns<
                          LedgerAccount,
                          $LedgerAccountsTable,
                          SalaryReceipt,
                          $SalaryReceiptsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerAccountsTableReferences
                              ._salaryReceiptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).salaryReceiptsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                      if (cashSettingsRefs)
                        await $_getPrefetchedDataByColumns<
                          LedgerAccount,
                          $LedgerAccountsTable,
                          CashSetting,
                          $CashSettingsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerAccountsTableReferences
                              ._cashSettingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).cashSettingsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'cash_account_id',
                          typedResults: items,
                        ),
                      if (cashReconciliationsRefs)
                        await $_getPrefetchedDataByColumns<
                          LedgerAccount,
                          $LedgerAccountsTable,
                          CashReconciliation,
                          $CashReconciliationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerAccountsTableReferences
                              ._cashReconciliationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).cashReconciliationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                      if (outgoingRemittances)
                        await $_getPrefetchedDataByColumns<
                          LedgerAccount,
                          $LedgerAccountsTable,
                          Remittance,
                          $RemittancesTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerAccountsTableReferences
                              ._outgoingRemittancesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).outgoingRemittances,
                          currentColumn: 'id',
                          referencedColumn: 'source_account_id',
                          typedResults: items,
                        ),
                      if (incomingRemittances)
                        await $_getPrefetchedDataByColumns<
                          LedgerAccount,
                          $LedgerAccountsTable,
                          Remittance,
                          $RemittancesTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerAccountsTableReferences
                              ._incomingRemittancesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).incomingRemittances,
                          currentColumn: 'id',
                          referencedColumn: 'destination_account_id',
                          typedResults: items,
                        ),
                      if (travelContributionsRefs)
                        await $_getPrefetchedDataByColumns<
                          LedgerAccount,
                          $LedgerAccountsTable,
                          TravelContribution,
                          $TravelContributionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LedgerAccountsTableReferences
                              ._travelContributionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LedgerAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).travelContributionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LedgerAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $LedgerAccountsTable,
      LedgerAccount,
      $$LedgerAccountsTableFilterComposer,
      $$LedgerAccountsTableOrderingComposer,
      $$LedgerAccountsTableAnnotationComposer,
      $$LedgerAccountsTableCreateCompanionBuilder,
      $$LedgerAccountsTableUpdateCompanionBuilder,
      (LedgerAccount, $$LedgerAccountsTableReferences),
      LedgerAccount,
      PrefetchHooks Function({
        bool currency,
        bool journalEntriesRefs,
        bool journalPostingsRefs,
        bool salaryReceiptsRefs,
        bool cashSettingsRefs,
        bool cashReconciliationsRefs,
        bool outgoingRemittances,
        bool incomingRemittances,
        bool travelContributionsRefs,
      })
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      required String operationId,
      required JournalKind kind,
      required int effectiveMicros,
      Value<int?> openingAccountId,
      Value<int?> reversalOf,
      Value<int?> correctionOf,
      Value<String?> reason,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      Value<String> operationId,
      Value<JournalKind> kind,
      Value<int> effectiveMicros,
      Value<int?> openingAccountId,
      Value<int?> reversalOf,
      Value<int?> correctionOf,
      Value<String?> reason,
    });

final class $$JournalEntriesTableReferences
    extends
        BaseReferences<_$LedgerDatabase, $JournalEntriesTable, JournalEntry> {
  $$JournalEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LedgerAccountsTable _openingAccountIdTable(_$LedgerDatabase db) => db
      .ledgerAccounts
      .createAlias('journal_entries__opening_account_id__ledger_accounts__id');

  $$LedgerAccountsTableProcessedTableManager? get openingAccountId {
    final $_column = $_itemColumn<int>('opening_account_id');
    if ($_column == null) return null;
    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_openingAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $JournalEntriesTable _reversalOfTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('journal_entries__reversal_of__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager? get reversalOf {
    final $_column = $_itemColumn<int>('reversal_of');
    if ($_column == null) return null;
    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reversalOfTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $JournalEntriesTable _correctionOfTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('journal_entries__correction_of__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager? get correctionOf {
    final $_column = $_itemColumn<int>('correction_of');
    if ($_column == null) return null;
    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_correctionOfTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$JournalPostingsTable, List<JournalPosting>>
  _journalPostingsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalPostings,
        aliasName: 'journal_entries__id__journal_postings__entry_id',
      );

  $$JournalPostingsTableProcessedTableManager get journalPostingsRefs {
    final manager = $$JournalPostingsTableTableManager(
      $_db,
      $_db.journalPostings,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalPostingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SalaryReceiptsTable, List<SalaryReceipt>>
  _salaryReceiptsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.salaryReceipts,
        aliasName: 'journal_entries__id__salary_receipts__entry_id',
      );

  $$SalaryReceiptsTableProcessedTableManager get salaryReceiptsRefs {
    final manager = $$SalaryReceiptsTableTableManager(
      $_db,
      $_db.salaryReceipts,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salaryReceiptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SalaryExecutionsTable, List<SalaryExecution>>
  _salaryExecutionsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.salaryExecutions,
        aliasName: 'journal_entries__id__salary_executions__entry_id',
      );

  $$SalaryExecutionsTableProcessedTableManager get salaryExecutionsRefs {
    final manager = $$SalaryExecutionsTableTableManager(
      $_db,
      $_db.salaryExecutions,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _salaryExecutionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MovementConfirmationsTable,
    List<MovementConfirmation>
  >
  _movementConfirmationsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.movementConfirmations,
        aliasName: 'journal_entries__id__movement_confirmations__entry_id',
      );

  $$MovementConfirmationsTableProcessedTableManager
  get movementConfirmationsRefs {
    final manager = $$MovementConfirmationsTableTableManager(
      $_db,
      $_db.movementConfirmations,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movementConfirmationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CashReconciliationsTable,
    List<CashReconciliation>
  >
  _cashReconciliationsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cashReconciliations,
        aliasName: 'journal_entries__id__cash_reconciliations__entry_id',
      );

  $$CashReconciliationsTableProcessedTableManager get cashReconciliationsRefs {
    final manager = $$CashReconciliationsTableTableManager(
      $_db,
      $_db.cashReconciliations,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cashReconciliationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpenseDetailsTable, List<ExpenseDetail>>
  _expenseDetailsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.expenseDetails,
        aliasName: 'journal_entries__id__expense_details__entry_id',
      );

  $$ExpenseDetailsTableProcessedTableManager get expenseDetailsRefs {
    final manager = $$ExpenseDetailsTableTableManager(
      $_db,
      $_db.expenseDetails,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expenseDetailsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemittanceEventsTable, List<RemittanceEvent>>
  _remittanceEventsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.remittanceEvents,
        aliasName: 'journal_entries__id__remittance_events__entry_id',
      );

  $$RemittanceEventsTableProcessedTableManager get remittanceEventsRefs {
    final manager = $$RemittanceEventsTableTableManager(
      $_db,
      $_db.remittanceEvents,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _remittanceEventsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemittanceEventsTable, List<RemittanceEvent>>
  _remittanceSourceProofsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.remittanceEvents,
        aliasName: 'journal_entries__id__remittance_events__receipt_entry_id',
      );

  $$RemittanceEventsTableProcessedTableManager get remittanceSourceProofs {
    final manager = $$RemittanceEventsTableTableManager(
      $_db,
      $_db.remittanceEvents,
    ).filter((f) => f.receiptEntryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _remittanceSourceProofsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RemittanceFamilyPaymentsTable,
    List<RemittanceFamilyPayment>
  >
  _remittanceFamilyPaymentsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.remittanceFamilyPayments,
        aliasName: 'journal_entries__id__remittance_family_payments__entry_id',
      );

  $$RemittanceFamilyPaymentsTableProcessedTableManager
  get remittanceFamilyPaymentsRefs {
    final manager = $$RemittanceFamilyPaymentsTableTableManager(
      $_db,
      $_db.remittanceFamilyPayments,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _remittanceFamilyPaymentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DashainPlansTable, List<DashainPlan>>
  _dashainPlansRefsTable(_$LedgerDatabase db) => MultiTypedResultKey.fromTable(
    db.dashainPlans,
    aliasName: 'journal_entries__id__dashain_plans__receipt_id',
  );

  $$DashainPlansTableProcessedTableManager get dashainPlansRefs {
    final manager = $$DashainPlansTableTableManager(
      $_db,
      $_db.dashainPlans,
    ).filter((f) => f.receiptId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dashainPlansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$JournalEntriesTableFilterComposer
    extends Composer<_$LedgerDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<JournalKind, JournalKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get effectiveMicros => $composableBuilder(
    column: $table.effectiveMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  $$LedgerAccountsTableFilterComposer get openingAccountId {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.openingAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableFilterComposer get reversalOf {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversalOf,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableFilterComposer get correctionOf {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctionOf,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> journalPostingsRefs(
    Expression<bool> Function($$JournalPostingsTableFilterComposer f) f,
  ) {
    final $$JournalPostingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalPostings,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalPostingsTableFilterComposer(
            $db: $db,
            $table: $db.journalPostings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> salaryReceiptsRefs(
    Expression<bool> Function($$SalaryReceiptsTableFilterComposer f) f,
  ) {
    final $$SalaryReceiptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.salaryReceipts,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalaryReceiptsTableFilterComposer(
            $db: $db,
            $table: $db.salaryReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> salaryExecutionsRefs(
    Expression<bool> Function($$SalaryExecutionsTableFilterComposer f) f,
  ) {
    final $$SalaryExecutionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.salaryExecutions,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalaryExecutionsTableFilterComposer(
            $db: $db,
            $table: $db.salaryExecutions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movementConfirmationsRefs(
    Expression<bool> Function($$MovementConfirmationsTableFilterComposer f) f,
  ) {
    final $$MovementConfirmationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movementConfirmations,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovementConfirmationsTableFilterComposer(
                $db: $db,
                $table: $db.movementConfirmations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> cashReconciliationsRefs(
    Expression<bool> Function($$CashReconciliationsTableFilterComposer f) f,
  ) {
    final $$CashReconciliationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashReconciliations,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashReconciliationsTableFilterComposer(
            $db: $db,
            $table: $db.cashReconciliations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expenseDetailsRefs(
    Expression<bool> Function($$ExpenseDetailsTableFilterComposer f) f,
  ) {
    final $$ExpenseDetailsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseDetails,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseDetailsTableFilterComposer(
            $db: $db,
            $table: $db.expenseDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remittanceEventsRefs(
    Expression<bool> Function($$RemittanceEventsTableFilterComposer f) f,
  ) {
    final $$RemittanceEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remittanceEvents,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittanceEventsTableFilterComposer(
            $db: $db,
            $table: $db.remittanceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remittanceSourceProofs(
    Expression<bool> Function($$RemittanceEventsTableFilterComposer f) f,
  ) {
    final $$RemittanceEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remittanceEvents,
      getReferencedColumn: (t) => t.receiptEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittanceEventsTableFilterComposer(
            $db: $db,
            $table: $db.remittanceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remittanceFamilyPaymentsRefs(
    Expression<bool> Function($$RemittanceFamilyPaymentsTableFilterComposer f)
    f,
  ) {
    final $$RemittanceFamilyPaymentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.remittanceFamilyPayments,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RemittanceFamilyPaymentsTableFilterComposer(
                $db: $db,
                $table: $db.remittanceFamilyPayments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> dashainPlansRefs(
    Expression<bool> Function($$DashainPlansTableFilterComposer f) f,
  ) {
    final $$DashainPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dashainPlans,
      getReferencedColumn: (t) => t.receiptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DashainPlansTableFilterComposer(
            $db: $db,
            $table: $db.dashainPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$LedgerDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get effectiveMicros => $composableBuilder(
    column: $table.effectiveMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  $$LedgerAccountsTableOrderingComposer get openingAccountId {
    final $$LedgerAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.openingAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableOrderingComposer get reversalOf {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversalOf,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableOrderingComposer get correctionOf {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctionOf,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<JournalKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get effectiveMicros => $composableBuilder(
    column: $table.effectiveMicros,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  $$LedgerAccountsTableAnnotationComposer get openingAccountId {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.openingAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableAnnotationComposer get reversalOf {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversalOf,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableAnnotationComposer get correctionOf {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctionOf,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> journalPostingsRefs<T extends Object>(
    Expression<T> Function($$JournalPostingsTableAnnotationComposer a) f,
  ) {
    final $$JournalPostingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalPostings,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalPostingsTableAnnotationComposer(
            $db: $db,
            $table: $db.journalPostings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> salaryReceiptsRefs<T extends Object>(
    Expression<T> Function($$SalaryReceiptsTableAnnotationComposer a) f,
  ) {
    final $$SalaryReceiptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.salaryReceipts,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalaryReceiptsTableAnnotationComposer(
            $db: $db,
            $table: $db.salaryReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> salaryExecutionsRefs<T extends Object>(
    Expression<T> Function($$SalaryExecutionsTableAnnotationComposer a) f,
  ) {
    final $$SalaryExecutionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.salaryExecutions,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalaryExecutionsTableAnnotationComposer(
            $db: $db,
            $table: $db.salaryExecutions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movementConfirmationsRefs<T extends Object>(
    Expression<T> Function($$MovementConfirmationsTableAnnotationComposer a) f,
  ) {
    final $$MovementConfirmationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.movementConfirmations,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MovementConfirmationsTableAnnotationComposer(
                $db: $db,
                $table: $db.movementConfirmations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> cashReconciliationsRefs<T extends Object>(
    Expression<T> Function($$CashReconciliationsTableAnnotationComposer a) f,
  ) {
    final $$CashReconciliationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cashReconciliations,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CashReconciliationsTableAnnotationComposer(
                $db: $db,
                $table: $db.cashReconciliations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> expenseDetailsRefs<T extends Object>(
    Expression<T> Function($$ExpenseDetailsTableAnnotationComposer a) f,
  ) {
    final $$ExpenseDetailsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenseDetails,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseDetailsTableAnnotationComposer(
            $db: $db,
            $table: $db.expenseDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remittanceEventsRefs<T extends Object>(
    Expression<T> Function($$RemittanceEventsTableAnnotationComposer a) f,
  ) {
    final $$RemittanceEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remittanceEvents,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittanceEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.remittanceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remittanceSourceProofs<T extends Object>(
    Expression<T> Function($$RemittanceEventsTableAnnotationComposer a) f,
  ) {
    final $$RemittanceEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remittanceEvents,
      getReferencedColumn: (t) => t.receiptEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittanceEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.remittanceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remittanceFamilyPaymentsRefs<T extends Object>(
    Expression<T> Function($$RemittanceFamilyPaymentsTableAnnotationComposer a)
    f,
  ) {
    final $$RemittanceFamilyPaymentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.remittanceFamilyPayments,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RemittanceFamilyPaymentsTableAnnotationComposer(
                $db: $db,
                $table: $db.remittanceFamilyPayments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> dashainPlansRefs<T extends Object>(
    Expression<T> Function($$DashainPlansTableAnnotationComposer a) f,
  ) {
    final $$DashainPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dashainPlans,
      getReferencedColumn: (t) => t.receiptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DashainPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.dashainPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $JournalEntriesTable,
          JournalEntry,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (JournalEntry, $$JournalEntriesTableReferences),
          JournalEntry,
          PrefetchHooks Function({
            bool openingAccountId,
            bool reversalOf,
            bool correctionOf,
            bool journalPostingsRefs,
            bool salaryReceiptsRefs,
            bool salaryExecutionsRefs,
            bool movementConfirmationsRefs,
            bool cashReconciliationsRefs,
            bool expenseDetailsRefs,
            bool remittanceEventsRefs,
            bool remittanceSourceProofs,
            bool remittanceFamilyPaymentsRefs,
            bool dashainPlansRefs,
          })
        > {
  $$JournalEntriesTableTableManager(
    _$LedgerDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> operationId = const Value.absent(),
                Value<JournalKind> kind = const Value.absent(),
                Value<int> effectiveMicros = const Value.absent(),
                Value<int?> openingAccountId = const Value.absent(),
                Value<int?> reversalOf = const Value.absent(),
                Value<int?> correctionOf = const Value.absent(),
                Value<String?> reason = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                operationId: operationId,
                kind: kind,
                effectiveMicros: effectiveMicros,
                openingAccountId: openingAccountId,
                reversalOf: reversalOf,
                correctionOf: correctionOf,
                reason: reason,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String operationId,
                required JournalKind kind,
                required int effectiveMicros,
                Value<int?> openingAccountId = const Value.absent(),
                Value<int?> reversalOf = const Value.absent(),
                Value<int?> correctionOf = const Value.absent(),
                Value<String?> reason = const Value.absent(),
              }) => JournalEntriesCompanion.insert(
                id: id,
                operationId: operationId,
                kind: kind,
                effectiveMicros: effectiveMicros,
                openingAccountId: openingAccountId,
                reversalOf: reversalOf,
                correctionOf: correctionOf,
                reason: reason,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$JournalEntriesTable, JournalEntry>(table),
                  $$JournalEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                openingAccountId = false,
                reversalOf = false,
                correctionOf = false,
                journalPostingsRefs = false,
                salaryReceiptsRefs = false,
                salaryExecutionsRefs = false,
                movementConfirmationsRefs = false,
                cashReconciliationsRefs = false,
                expenseDetailsRefs = false,
                remittanceEventsRefs = false,
                remittanceSourceProofs = false,
                remittanceFamilyPaymentsRefs = false,
                dashainPlansRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (journalPostingsRefs) db.journalPostings,
                    if (salaryReceiptsRefs) db.salaryReceipts,
                    if (salaryExecutionsRefs) db.salaryExecutions,
                    if (movementConfirmationsRefs) db.movementConfirmations,
                    if (cashReconciliationsRefs) db.cashReconciliations,
                    if (expenseDetailsRefs) db.expenseDetails,
                    if (remittanceEventsRefs) db.remittanceEvents,
                    if (remittanceSourceProofs) db.remittanceEvents,
                    if (remittanceFamilyPaymentsRefs)
                      db.remittanceFamilyPayments,
                    if (dashainPlansRefs) db.dashainPlans,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (openingAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.openingAccountId,
                            referencedTable: $$JournalEntriesTableReferences
                                ._openingAccountIdTable(db),
                            referencedColumn: $$JournalEntriesTableReferences
                                ._openingAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (reversalOf) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.reversalOf,
                            referencedTable: $$JournalEntriesTableReferences
                                ._reversalOfTable(db),
                            referencedColumn: $$JournalEntriesTableReferences
                                ._reversalOfTable(db)
                                .id,
                          ) as T;
                        }
                        if (correctionOf) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.correctionOf,
                            referencedTable: $$JournalEntriesTableReferences
                                ._correctionOfTable(db),
                            referencedColumn: $$JournalEntriesTableReferences
                                ._correctionOfTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (journalPostingsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntry,
                          $JournalEntriesTable,
                          JournalPosting,
                          $JournalPostingsTable
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._journalPostingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).journalPostingsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                      if (salaryReceiptsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntry,
                          $JournalEntriesTable,
                          SalaryReceipt,
                          $SalaryReceiptsTable
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._salaryReceiptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).salaryReceiptsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                      if (salaryExecutionsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntry,
                          $JournalEntriesTable,
                          SalaryExecution,
                          $SalaryExecutionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._salaryExecutionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).salaryExecutionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                      if (movementConfirmationsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntry,
                          $JournalEntriesTable,
                          MovementConfirmation,
                          $MovementConfirmationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._movementConfirmationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).movementConfirmationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                      if (cashReconciliationsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntry,
                          $JournalEntriesTable,
                          CashReconciliation,
                          $CashReconciliationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._cashReconciliationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).cashReconciliationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                      if (expenseDetailsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntry,
                          $JournalEntriesTable,
                          ExpenseDetail,
                          $ExpenseDetailsTable
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._expenseDetailsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).expenseDetailsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                      if (remittanceEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntry,
                          $JournalEntriesTable,
                          RemittanceEvent,
                          $RemittanceEventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._remittanceEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).remittanceEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                      if (remittanceSourceProofs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntry,
                          $JournalEntriesTable,
                          RemittanceEvent,
                          $RemittanceEventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._remittanceSourceProofsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).remittanceSourceProofs,
                          currentColumn: 'id',
                          referencedColumn: 'receipt_entry_id',
                          typedResults: items,
                        ),
                      if (remittanceFamilyPaymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntry,
                          $JournalEntriesTable,
                          RemittanceFamilyPayment,
                          $RemittanceFamilyPaymentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._remittanceFamilyPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).remittanceFamilyPaymentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                      if (dashainPlansRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntry,
                          $JournalEntriesTable,
                          DashainPlan,
                          $DashainPlansTable
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._dashainPlansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).dashainPlansRefs,
                          currentColumn: 'id',
                          referencedColumn: 'receipt_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $JournalEntriesTable,
      JournalEntry,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (JournalEntry, $$JournalEntriesTableReferences),
      JournalEntry,
      PrefetchHooks Function({
        bool openingAccountId,
        bool reversalOf,
        bool correctionOf,
        bool journalPostingsRefs,
        bool salaryReceiptsRefs,
        bool salaryExecutionsRefs,
        bool movementConfirmationsRefs,
        bool cashReconciliationsRefs,
        bool expenseDetailsRefs,
        bool remittanceEventsRefs,
        bool remittanceSourceProofs,
        bool remittanceFamilyPaymentsRefs,
        bool dashainPlansRefs,
      })
    >;
typedef $$JournalPostingsTableCreateCompanionBuilder =
    JournalPostingsCompanion Function({
      required int entryId,
      required int accountId,
      required int minor,
      Value<int> rowid,
    });
typedef $$JournalPostingsTableUpdateCompanionBuilder =
    JournalPostingsCompanion Function({
      Value<int> entryId,
      Value<int> accountId,
      Value<int> minor,
      Value<int> rowid,
    });

final class $$JournalPostingsTableReferences
    extends
        BaseReferences<
          _$LedgerDatabase,
          $JournalPostingsTable,
          JournalPosting
        > {
  $$JournalPostingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _entryIdTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('journal_postings__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LedgerAccountsTable _accountIdTable(_$LedgerDatabase db) => db
      .ledgerAccounts
      .createAlias('journal_postings__account_id__ledger_accounts__id');

  $$LedgerAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JournalPostingsTableFilterComposer
    extends Composer<_$LedgerDatabase, $JournalPostingsTable> {
  $$JournalPostingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get minor => $composableBuilder(
    column: $table.minor,
    builder: (column) => ColumnFilters(column),
  );

  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableFilterComposer get accountId {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalPostingsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $JournalPostingsTable> {
  $$JournalPostingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get minor => $composableBuilder(
    column: $table.minor,
    builder: (column) => ColumnOrderings(column),
  );

  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableOrderingComposer get accountId {
    final $$LedgerAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalPostingsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $JournalPostingsTable> {
  $$JournalPostingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get minor =>
      $composableBuilder(column: $table.minor, builder: (column) => column);

  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableAnnotationComposer get accountId {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalPostingsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $JournalPostingsTable,
          JournalPosting,
          $$JournalPostingsTableFilterComposer,
          $$JournalPostingsTableOrderingComposer,
          $$JournalPostingsTableAnnotationComposer,
          $$JournalPostingsTableCreateCompanionBuilder,
          $$JournalPostingsTableUpdateCompanionBuilder,
          (JournalPosting, $$JournalPostingsTableReferences),
          JournalPosting,
          PrefetchHooks Function({bool entryId, bool accountId})
        > {
  $$JournalPostingsTableTableManager(
    _$LedgerDatabase db,
    $JournalPostingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalPostingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalPostingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalPostingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int> minor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalPostingsCompanion(
                entryId: entryId,
                accountId: accountId,
                minor: minor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int entryId,
                required int accountId,
                required int minor,
                Value<int> rowid = const Value.absent(),
              }) => JournalPostingsCompanion.insert(
                entryId: entryId,
                accountId: accountId,
                minor: minor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$JournalPostingsTable, JournalPosting>(table),
                  $$JournalPostingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false, accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $$JournalPostingsTableReferences
                            ._entryIdTable(db),
                        referencedColumn: $$JournalPostingsTableReferences
                            ._entryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $$JournalPostingsTableReferences
                            ._accountIdTable(db),
                        referencedColumn: $$JournalPostingsTableReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JournalPostingsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $JournalPostingsTable,
      JournalPosting,
      $$JournalPostingsTableFilterComposer,
      $$JournalPostingsTableOrderingComposer,
      $$JournalPostingsTableAnnotationComposer,
      $$JournalPostingsTableCreateCompanionBuilder,
      $$JournalPostingsTableUpdateCompanionBuilder,
      (JournalPosting, $$JournalPostingsTableReferences),
      JournalPosting,
      PrefetchHooks Function({bool entryId, bool accountId})
    >;
typedef $$SalaryReceiptsTableCreateCompanionBuilder =
    SalaryReceiptsCompanion Function({
      Value<int> entryId,
      required int accountId,
      Value<String?> reference,
    });
typedef $$SalaryReceiptsTableUpdateCompanionBuilder =
    SalaryReceiptsCompanion Function({
      Value<int> entryId,
      Value<int> accountId,
      Value<String?> reference,
    });

final class $$SalaryReceiptsTableReferences
    extends
        BaseReferences<_$LedgerDatabase, $SalaryReceiptsTable, SalaryReceipt> {
  $$SalaryReceiptsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _entryIdTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('salary_receipts__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LedgerAccountsTable _accountIdTable(_$LedgerDatabase db) => db
      .ledgerAccounts
      .createAlias('salary_receipts__account_id__ledger_accounts__id');

  $$LedgerAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SalaryReceiptsTableFilterComposer
    extends Composer<_$LedgerDatabase, $SalaryReceiptsTable> {
  $$SalaryReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableFilterComposer get accountId {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalaryReceiptsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $SalaryReceiptsTable> {
  $$SalaryReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableOrderingComposer get accountId {
    final $$LedgerAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalaryReceiptsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $SalaryReceiptsTable> {
  $$SalaryReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableAnnotationComposer get accountId {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalaryReceiptsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $SalaryReceiptsTable,
          SalaryReceipt,
          $$SalaryReceiptsTableFilterComposer,
          $$SalaryReceiptsTableOrderingComposer,
          $$SalaryReceiptsTableAnnotationComposer,
          $$SalaryReceiptsTableCreateCompanionBuilder,
          $$SalaryReceiptsTableUpdateCompanionBuilder,
          (SalaryReceipt, $$SalaryReceiptsTableReferences),
          SalaryReceipt,
          PrefetchHooks Function({bool entryId, bool accountId})
        > {
  $$SalaryReceiptsTableTableManager(
    _$LedgerDatabase db,
    $SalaryReceiptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalaryReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalaryReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalaryReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String?> reference = const Value.absent(),
              }) => SalaryReceiptsCompanion(
                entryId: entryId,
                accountId: accountId,
                reference: reference,
              ),
          createCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                required int accountId,
                Value<String?> reference = const Value.absent(),
              }) => SalaryReceiptsCompanion.insert(
                entryId: entryId,
                accountId: accountId,
                reference: reference,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SalaryReceiptsTable, SalaryReceipt>(table),
                  $$SalaryReceiptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false, accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $$SalaryReceiptsTableReferences
                            ._entryIdTable(db),
                        referencedColumn: $$SalaryReceiptsTableReferences
                            ._entryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $$SalaryReceiptsTableReferences
                            ._accountIdTable(db),
                        referencedColumn: $$SalaryReceiptsTableReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SalaryReceiptsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $SalaryReceiptsTable,
      SalaryReceipt,
      $$SalaryReceiptsTableFilterComposer,
      $$SalaryReceiptsTableOrderingComposer,
      $$SalaryReceiptsTableAnnotationComposer,
      $$SalaryReceiptsTableCreateCompanionBuilder,
      $$SalaryReceiptsTableUpdateCompanionBuilder,
      (SalaryReceipt, $$SalaryReceiptsTableReferences),
      SalaryReceipt,
      PrefetchHooks Function({bool entryId, bool accountId})
    >;
typedef $$SalaryPlansTableCreateCompanionBuilder =
    SalaryPlansCompanion Function({Value<int> salaryId});
typedef $$SalaryPlansTableUpdateCompanionBuilder =
    SalaryPlansCompanion Function({Value<int> salaryId});

class $$SalaryPlansTableFilterComposer
    extends Composer<_$LedgerDatabase, $SalaryPlansTable> {
  $$SalaryPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
}

class $$SalaryPlansTableOrderingComposer
    extends Composer<_$LedgerDatabase, $SalaryPlansTable> {
  $$SalaryPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
}

class $$SalaryPlansTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $SalaryPlansTable> {
  $$SalaryPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
}

class $$SalaryPlansTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $SalaryPlansTable,
          SalaryPlan,
          $$SalaryPlansTableFilterComposer,
          $$SalaryPlansTableOrderingComposer,
          $$SalaryPlansTableAnnotationComposer,
          $$SalaryPlansTableCreateCompanionBuilder,
          $$SalaryPlansTableUpdateCompanionBuilder,
          (
            SalaryPlan,
            BaseReferences<_$LedgerDatabase, $SalaryPlansTable, SalaryPlan>,
          ),
          SalaryPlan,
          PrefetchHooks Function()
        > {
  $$SalaryPlansTableTableManager(_$LedgerDatabase db, $SalaryPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalaryPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalaryPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalaryPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> salaryId = const Value.absent(),
          }) => SalaryPlansCompanion(salaryId: salaryId),
          createCompanionCallback: ({
            Value<int> salaryId = const Value.absent(),
          }) => SalaryPlansCompanion.insert(salaryId: salaryId),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SalaryPlansTable, SalaryPlan>(table),
                  BaseReferences<
                    _$LedgerDatabase,
                    $SalaryPlansTable,
                    SalaryPlan
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalaryPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $SalaryPlansTable,
      SalaryPlan,
      $$SalaryPlansTableFilterComposer,
      $$SalaryPlansTableOrderingComposer,
      $$SalaryPlansTableAnnotationComposer,
      $$SalaryPlansTableCreateCompanionBuilder,
      $$SalaryPlansTableUpdateCompanionBuilder,
      (
        SalaryPlan,
        BaseReferences<_$LedgerDatabase, $SalaryPlansTable, SalaryPlan>,
      ),
      SalaryPlan,
      PrefetchHooks Function()
    >;
typedef $$SalaryAllocationsTableCreateCompanionBuilder =
    SalaryAllocationsCompanion Function({
      Value<int> id,
      required int salaryId,
      required String label,
      required int plannedMinor,
    });
typedef $$SalaryAllocationsTableUpdateCompanionBuilder =
    SalaryAllocationsCompanion Function({
      Value<int> id,
      Value<int> salaryId,
      Value<String> label,
      Value<int> plannedMinor,
    });

final class $$SalaryAllocationsTableReferences
    extends
        BaseReferences<
          _$LedgerDatabase,
          $SalaryAllocationsTable,
          SalaryAllocation
        > {
  $$SalaryAllocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SalaryExecutionsTable, List<SalaryExecution>>
  _salaryExecutionsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.salaryExecutions,
        aliasName: 'salary_allocations__id__salary_executions__allocation_id',
      );

  $$SalaryExecutionsTableProcessedTableManager get salaryExecutionsRefs {
    final manager = $$SalaryExecutionsTableTableManager(
      $_db,
      $_db.salaryExecutions,
    ).filter((f) => f.allocationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _salaryExecutionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SalaryAllocationsTableFilterComposer
    extends Composer<_$LedgerDatabase, $SalaryAllocationsTable> {
  $$SalaryAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedMinor => $composableBuilder(
    column: $table.plannedMinor,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> salaryExecutionsRefs(
    Expression<bool> Function($$SalaryExecutionsTableFilterComposer f) f,
  ) {
    final $$SalaryExecutionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.salaryExecutions,
      getReferencedColumn: (t) => t.allocationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalaryExecutionsTableFilterComposer(
            $db: $db,
            $table: $db.salaryExecutions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalaryAllocationsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $SalaryAllocationsTable> {
  $$SalaryAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedMinor => $composableBuilder(
    column: $table.plannedMinor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalaryAllocationsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $SalaryAllocationsTable> {
  $$SalaryAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get plannedMinor => $composableBuilder(
    column: $table.plannedMinor,
    builder: (column) => column,
  );

  Expression<T> salaryExecutionsRefs<T extends Object>(
    Expression<T> Function($$SalaryExecutionsTableAnnotationComposer a) f,
  ) {
    final $$SalaryExecutionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.salaryExecutions,
      getReferencedColumn: (t) => t.allocationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalaryExecutionsTableAnnotationComposer(
            $db: $db,
            $table: $db.salaryExecutions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalaryAllocationsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $SalaryAllocationsTable,
          SalaryAllocation,
          $$SalaryAllocationsTableFilterComposer,
          $$SalaryAllocationsTableOrderingComposer,
          $$SalaryAllocationsTableAnnotationComposer,
          $$SalaryAllocationsTableCreateCompanionBuilder,
          $$SalaryAllocationsTableUpdateCompanionBuilder,
          (SalaryAllocation, $$SalaryAllocationsTableReferences),
          SalaryAllocation,
          PrefetchHooks Function({bool salaryExecutionsRefs})
        > {
  $$SalaryAllocationsTableTableManager(
    _$LedgerDatabase db,
    $SalaryAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalaryAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalaryAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalaryAllocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> salaryId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> plannedMinor = const Value.absent(),
              }) => SalaryAllocationsCompanion(
                id: id,
                salaryId: salaryId,
                label: label,
                plannedMinor: plannedMinor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int salaryId,
                required String label,
                required int plannedMinor,
              }) => SalaryAllocationsCompanion.insert(
                id: id,
                salaryId: salaryId,
                label: label,
                plannedMinor: plannedMinor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SalaryAllocationsTable, SalaryAllocation>(table),
                  $$SalaryAllocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({salaryExecutionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (salaryExecutionsRefs) db.salaryExecutions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (salaryExecutionsRefs)
                    await $_getPrefetchedDataByColumns<
                      SalaryAllocation,
                      $SalaryAllocationsTable,
                      SalaryExecution,
                      $SalaryExecutionsTable
                    >(
                      currentTable: table,
                      referencedTable: $$SalaryAllocationsTableReferences
                          ._salaryExecutionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SalaryAllocationsTableReferences(
                            db,
                            table,
                            p0,
                          ).salaryExecutionsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'allocation_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SalaryAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $SalaryAllocationsTable,
      SalaryAllocation,
      $$SalaryAllocationsTableFilterComposer,
      $$SalaryAllocationsTableOrderingComposer,
      $$SalaryAllocationsTableAnnotationComposer,
      $$SalaryAllocationsTableCreateCompanionBuilder,
      $$SalaryAllocationsTableUpdateCompanionBuilder,
      (SalaryAllocation, $$SalaryAllocationsTableReferences),
      SalaryAllocation,
      PrefetchHooks Function({bool salaryExecutionsRefs})
    >;
typedef $$SalaryExecutionsTableCreateCompanionBuilder =
    SalaryExecutionsCompanion Function({
      required int allocationId,
      required int entryId,
      required int minor,
      Value<int> rowid,
    });
typedef $$SalaryExecutionsTableUpdateCompanionBuilder =
    SalaryExecutionsCompanion Function({
      Value<int> allocationId,
      Value<int> entryId,
      Value<int> minor,
      Value<int> rowid,
    });

final class $$SalaryExecutionsTableReferences
    extends
        BaseReferences<
          _$LedgerDatabase,
          $SalaryExecutionsTable,
          SalaryExecution
        > {
  $$SalaryExecutionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SalaryAllocationsTable _allocationIdTable(_$LedgerDatabase db) => db
      .salaryAllocations
      .createAlias('salary_executions__allocation_id__salary_allocations__id');

  $$SalaryAllocationsTableProcessedTableManager get allocationId {
    final $_column = $_itemColumn<int>('allocation_id')!;

    final manager = $$SalaryAllocationsTableTableManager(
      $_db,
      $_db.salaryAllocations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_allocationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $JournalEntriesTable _entryIdTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('salary_executions__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SalaryExecutionsTableFilterComposer
    extends Composer<_$LedgerDatabase, $SalaryExecutionsTable> {
  $$SalaryExecutionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get minor => $composableBuilder(
    column: $table.minor,
    builder: (column) => ColumnFilters(column),
  );

  $$SalaryAllocationsTableFilterComposer get allocationId {
    final $$SalaryAllocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.allocationId,
      referencedTable: $db.salaryAllocations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalaryAllocationsTableFilterComposer(
            $db: $db,
            $table: $db.salaryAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalaryExecutionsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $SalaryExecutionsTable> {
  $$SalaryExecutionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get minor => $composableBuilder(
    column: $table.minor,
    builder: (column) => ColumnOrderings(column),
  );

  $$SalaryAllocationsTableOrderingComposer get allocationId {
    final $$SalaryAllocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.allocationId,
      referencedTable: $db.salaryAllocations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalaryAllocationsTableOrderingComposer(
            $db: $db,
            $table: $db.salaryAllocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalaryExecutionsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $SalaryExecutionsTable> {
  $$SalaryExecutionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get minor =>
      $composableBuilder(column: $table.minor, builder: (column) => column);

  $$SalaryAllocationsTableAnnotationComposer get allocationId {
    final $$SalaryAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.allocationId,
          referencedTable: $db.salaryAllocations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SalaryAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.salaryAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalaryExecutionsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $SalaryExecutionsTable,
          SalaryExecution,
          $$SalaryExecutionsTableFilterComposer,
          $$SalaryExecutionsTableOrderingComposer,
          $$SalaryExecutionsTableAnnotationComposer,
          $$SalaryExecutionsTableCreateCompanionBuilder,
          $$SalaryExecutionsTableUpdateCompanionBuilder,
          (SalaryExecution, $$SalaryExecutionsTableReferences),
          SalaryExecution,
          PrefetchHooks Function({bool allocationId, bool entryId})
        > {
  $$SalaryExecutionsTableTableManager(
    _$LedgerDatabase db,
    $SalaryExecutionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalaryExecutionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalaryExecutionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalaryExecutionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> allocationId = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<int> minor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalaryExecutionsCompanion(
                allocationId: allocationId,
                entryId: entryId,
                minor: minor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int allocationId,
                required int entryId,
                required int minor,
                Value<int> rowid = const Value.absent(),
              }) => SalaryExecutionsCompanion.insert(
                allocationId: allocationId,
                entryId: entryId,
                minor: minor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SalaryExecutionsTable, SalaryExecution>(table),
                  $$SalaryExecutionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({allocationId = false, entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (allocationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.allocationId,
                        referencedTable: $$SalaryExecutionsTableReferences
                            ._allocationIdTable(db),
                        referencedColumn: $$SalaryExecutionsTableReferences
                            ._allocationIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $$SalaryExecutionsTableReferences
                            ._entryIdTable(db),
                        referencedColumn: $$SalaryExecutionsTableReferences
                            ._entryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SalaryExecutionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $SalaryExecutionsTable,
      SalaryExecution,
      $$SalaryExecutionsTableFilterComposer,
      $$SalaryExecutionsTableOrderingComposer,
      $$SalaryExecutionsTableAnnotationComposer,
      $$SalaryExecutionsTableCreateCompanionBuilder,
      $$SalaryExecutionsTableUpdateCompanionBuilder,
      (SalaryExecution, $$SalaryExecutionsTableReferences),
      SalaryExecution,
      PrefetchHooks Function({bool allocationId, bool entryId})
    >;
typedef $$MovementConfirmationsTableCreateCompanionBuilder =
    MovementConfirmationsCompanion Function({
      Value<int> entryId,
      required String evidence,
      required int confirmedMicros,
    });
typedef $$MovementConfirmationsTableUpdateCompanionBuilder =
    MovementConfirmationsCompanion Function({
      Value<int> entryId,
      Value<String> evidence,
      Value<int> confirmedMicros,
    });

final class $$MovementConfirmationsTableReferences
    extends
        BaseReferences<
          _$LedgerDatabase,
          $MovementConfirmationsTable,
          MovementConfirmation
        > {
  $$MovementConfirmationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _entryIdTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('movement_confirmations__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovementConfirmationsTableFilterComposer
    extends Composer<_$LedgerDatabase, $MovementConfirmationsTable> {
  $$MovementConfirmationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get evidence => $composableBuilder(
    column: $table.evidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get confirmedMicros => $composableBuilder(
    column: $table.confirmedMicros,
    builder: (column) => ColumnFilters(column),
  );

  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovementConfirmationsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $MovementConfirmationsTable> {
  $$MovementConfirmationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get evidence => $composableBuilder(
    column: $table.evidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get confirmedMicros => $composableBuilder(
    column: $table.confirmedMicros,
    builder: (column) => ColumnOrderings(column),
  );

  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovementConfirmationsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $MovementConfirmationsTable> {
  $$MovementConfirmationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get evidence =>
      $composableBuilder(column: $table.evidence, builder: (column) => column);

  GeneratedColumn<int> get confirmedMicros => $composableBuilder(
    column: $table.confirmedMicros,
    builder: (column) => column,
  );

  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovementConfirmationsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $MovementConfirmationsTable,
          MovementConfirmation,
          $$MovementConfirmationsTableFilterComposer,
          $$MovementConfirmationsTableOrderingComposer,
          $$MovementConfirmationsTableAnnotationComposer,
          $$MovementConfirmationsTableCreateCompanionBuilder,
          $$MovementConfirmationsTableUpdateCompanionBuilder,
          (MovementConfirmation, $$MovementConfirmationsTableReferences),
          MovementConfirmation,
          PrefetchHooks Function({bool entryId})
        > {
  $$MovementConfirmationsTableTableManager(
    _$LedgerDatabase db,
    $MovementConfirmationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovementConfirmationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MovementConfirmationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MovementConfirmationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                Value<String> evidence = const Value.absent(),
                Value<int> confirmedMicros = const Value.absent(),
              }) => MovementConfirmationsCompanion(
                entryId: entryId,
                evidence: evidence,
                confirmedMicros: confirmedMicros,
              ),
          createCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                required String evidence,
                required int confirmedMicros,
              }) => MovementConfirmationsCompanion.insert(
                entryId: entryId,
                evidence: evidence,
                confirmedMicros: confirmedMicros,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $MovementConfirmationsTable,
                    MovementConfirmation
                  >(table),
                  $$MovementConfirmationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $$MovementConfirmationsTableReferences
                            ._entryIdTable(db),
                        referencedColumn: $$MovementConfirmationsTableReferences
                            ._entryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MovementConfirmationsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $MovementConfirmationsTable,
      MovementConfirmation,
      $$MovementConfirmationsTableFilterComposer,
      $$MovementConfirmationsTableOrderingComposer,
      $$MovementConfirmationsTableAnnotationComposer,
      $$MovementConfirmationsTableCreateCompanionBuilder,
      $$MovementConfirmationsTableUpdateCompanionBuilder,
      (MovementConfirmation, $$MovementConfirmationsTableReferences),
      MovementConfirmation,
      PrefetchHooks Function({bool entryId})
    >;
typedef $$CashSettingsTableCreateCompanionBuilder =
    CashSettingsCompanion Function({
      Value<int> id,
      Value<int?> cashAccountId,
      required int withdrawalLimitMinor,
    });
typedef $$CashSettingsTableUpdateCompanionBuilder =
    CashSettingsCompanion Function({
      Value<int> id,
      Value<int?> cashAccountId,
      Value<int> withdrawalLimitMinor,
    });

final class $$CashSettingsTableReferences
    extends BaseReferences<_$LedgerDatabase, $CashSettingsTable, CashSetting> {
  $$CashSettingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LedgerAccountsTable _cashAccountIdTable(_$LedgerDatabase db) => db
      .ledgerAccounts
      .createAlias('cash_settings__cash_account_id__ledger_accounts__id');

  $$LedgerAccountsTableProcessedTableManager? get cashAccountId {
    final $_column = $_itemColumn<int>('cash_account_id');
    if ($_column == null) return null;
    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cashAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CashSettingsTableFilterComposer
    extends Composer<_$LedgerDatabase, $CashSettingsTable> {
  $$CashSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get withdrawalLimitMinor => $composableBuilder(
    column: $table.withdrawalLimitMinor,
    builder: (column) => ColumnFilters(column),
  );

  $$LedgerAccountsTableFilterComposer get cashAccountId {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cashAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashSettingsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $CashSettingsTable> {
  $$CashSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get withdrawalLimitMinor => $composableBuilder(
    column: $table.withdrawalLimitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $$LedgerAccountsTableOrderingComposer get cashAccountId {
    final $$LedgerAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cashAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashSettingsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $CashSettingsTable> {
  $$CashSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get withdrawalLimitMinor => $composableBuilder(
    column: $table.withdrawalLimitMinor,
    builder: (column) => column,
  );

  $$LedgerAccountsTableAnnotationComposer get cashAccountId {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cashAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashSettingsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $CashSettingsTable,
          CashSetting,
          $$CashSettingsTableFilterComposer,
          $$CashSettingsTableOrderingComposer,
          $$CashSettingsTableAnnotationComposer,
          $$CashSettingsTableCreateCompanionBuilder,
          $$CashSettingsTableUpdateCompanionBuilder,
          (CashSetting, $$CashSettingsTableReferences),
          CashSetting,
          PrefetchHooks Function({bool cashAccountId})
        > {
  $$CashSettingsTableTableManager(_$LedgerDatabase db, $CashSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> cashAccountId = const Value.absent(),
                Value<int> withdrawalLimitMinor = const Value.absent(),
              }) => CashSettingsCompanion(
                id: id,
                cashAccountId: cashAccountId,
                withdrawalLimitMinor: withdrawalLimitMinor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> cashAccountId = const Value.absent(),
                required int withdrawalLimitMinor,
              }) => CashSettingsCompanion.insert(
                id: id,
                cashAccountId: cashAccountId,
                withdrawalLimitMinor: withdrawalLimitMinor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CashSettingsTable, CashSetting>(table),
                  $$CashSettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cashAccountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cashAccountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cashAccountId,
                        referencedTable: $$CashSettingsTableReferences
                            ._cashAccountIdTable(db),
                        referencedColumn: $$CashSettingsTableReferences
                            ._cashAccountIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CashSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $CashSettingsTable,
      CashSetting,
      $$CashSettingsTableFilterComposer,
      $$CashSettingsTableOrderingComposer,
      $$CashSettingsTableAnnotationComposer,
      $$CashSettingsTableCreateCompanionBuilder,
      $$CashSettingsTableUpdateCompanionBuilder,
      (CashSetting, $$CashSettingsTableReferences),
      CashSetting,
      PrefetchHooks Function({bool cashAccountId})
    >;
typedef $$CashReconciliationsTableCreateCompanionBuilder =
    CashReconciliationsCompanion Function({
      Value<int> entryId,
      required int accountId,
      required int priorMinor,
      required int countedMinor,
    });
typedef $$CashReconciliationsTableUpdateCompanionBuilder =
    CashReconciliationsCompanion Function({
      Value<int> entryId,
      Value<int> accountId,
      Value<int> priorMinor,
      Value<int> countedMinor,
    });

final class $$CashReconciliationsTableReferences
    extends
        BaseReferences<
          _$LedgerDatabase,
          $CashReconciliationsTable,
          CashReconciliation
        > {
  $$CashReconciliationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _entryIdTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('cash_reconciliations__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LedgerAccountsTable _accountIdTable(_$LedgerDatabase db) => db
      .ledgerAccounts
      .createAlias('cash_reconciliations__account_id__ledger_accounts__id');

  $$LedgerAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CashReconciliationsTableFilterComposer
    extends Composer<_$LedgerDatabase, $CashReconciliationsTable> {
  $$CashReconciliationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get priorMinor => $composableBuilder(
    column: $table.priorMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get countedMinor => $composableBuilder(
    column: $table.countedMinor,
    builder: (column) => ColumnFilters(column),
  );

  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableFilterComposer get accountId {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashReconciliationsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $CashReconciliationsTable> {
  $$CashReconciliationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get priorMinor => $composableBuilder(
    column: $table.priorMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get countedMinor => $composableBuilder(
    column: $table.countedMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableOrderingComposer get accountId {
    final $$LedgerAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashReconciliationsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $CashReconciliationsTable> {
  $$CashReconciliationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get priorMinor => $composableBuilder(
    column: $table.priorMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get countedMinor => $composableBuilder(
    column: $table.countedMinor,
    builder: (column) => column,
  );

  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableAnnotationComposer get accountId {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashReconciliationsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $CashReconciliationsTable,
          CashReconciliation,
          $$CashReconciliationsTableFilterComposer,
          $$CashReconciliationsTableOrderingComposer,
          $$CashReconciliationsTableAnnotationComposer,
          $$CashReconciliationsTableCreateCompanionBuilder,
          $$CashReconciliationsTableUpdateCompanionBuilder,
          (CashReconciliation, $$CashReconciliationsTableReferences),
          CashReconciliation,
          PrefetchHooks Function({bool entryId, bool accountId})
        > {
  $$CashReconciliationsTableTableManager(
    _$LedgerDatabase db,
    $CashReconciliationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashReconciliationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashReconciliationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CashReconciliationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int> priorMinor = const Value.absent(),
                Value<int> countedMinor = const Value.absent(),
              }) => CashReconciliationsCompanion(
                entryId: entryId,
                accountId: accountId,
                priorMinor: priorMinor,
                countedMinor: countedMinor,
              ),
          createCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                required int accountId,
                required int priorMinor,
                required int countedMinor,
              }) => CashReconciliationsCompanion.insert(
                entryId: entryId,
                accountId: accountId,
                priorMinor: priorMinor,
                countedMinor: countedMinor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CashReconciliationsTable, CashReconciliation>(
                    table,
                  ),
                  $$CashReconciliationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false, accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $$CashReconciliationsTableReferences
                            ._entryIdTable(db),
                        referencedColumn: $$CashReconciliationsTableReferences
                            ._entryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $$CashReconciliationsTableReferences
                            ._accountIdTable(db),
                        referencedColumn: $$CashReconciliationsTableReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CashReconciliationsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $CashReconciliationsTable,
      CashReconciliation,
      $$CashReconciliationsTableFilterComposer,
      $$CashReconciliationsTableOrderingComposer,
      $$CashReconciliationsTableAnnotationComposer,
      $$CashReconciliationsTableCreateCompanionBuilder,
      $$CashReconciliationsTableUpdateCompanionBuilder,
      (CashReconciliation, $$CashReconciliationsTableReferences),
      CashReconciliation,
      PrefetchHooks Function({bool entryId, bool accountId})
    >;
typedef $$ExpenseDetailsTableCreateCompanionBuilder =
    ExpenseDetailsCompanion Function({
      Value<int> entryId,
      required ExpensePeriod period,
      required int startDay,
      Value<ExpenseCategory?> category,
    });
typedef $$ExpenseDetailsTableUpdateCompanionBuilder =
    ExpenseDetailsCompanion Function({
      Value<int> entryId,
      Value<ExpensePeriod> period,
      Value<int> startDay,
      Value<ExpenseCategory?> category,
    });

final class $$ExpenseDetailsTableReferences
    extends
        BaseReferences<_$LedgerDatabase, $ExpenseDetailsTable, ExpenseDetail> {
  $$ExpenseDetailsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _entryIdTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('expense_details__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpenseDetailsTableFilterComposer
    extends Composer<_$LedgerDatabase, $ExpenseDetailsTable> {
  $$ExpenseDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<ExpensePeriod, ExpensePeriod, String>
  get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExpenseCategory?, ExpenseCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseDetailsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $ExpenseDetailsTable> {
  $$ExpenseDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseDetailsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $ExpenseDetailsTable> {
  $$ExpenseDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<ExpensePeriod, String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get startDay =>
      $composableBuilder(column: $table.startDay, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExpenseCategory?, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpenseDetailsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $ExpenseDetailsTable,
          ExpenseDetail,
          $$ExpenseDetailsTableFilterComposer,
          $$ExpenseDetailsTableOrderingComposer,
          $$ExpenseDetailsTableAnnotationComposer,
          $$ExpenseDetailsTableCreateCompanionBuilder,
          $$ExpenseDetailsTableUpdateCompanionBuilder,
          (ExpenseDetail, $$ExpenseDetailsTableReferences),
          ExpenseDetail,
          PrefetchHooks Function({bool entryId})
        > {
  $$ExpenseDetailsTableTableManager(
    _$LedgerDatabase db,
    $ExpenseDetailsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                Value<ExpensePeriod> period = const Value.absent(),
                Value<int> startDay = const Value.absent(),
                Value<ExpenseCategory?> category = const Value.absent(),
              }) => ExpenseDetailsCompanion(
                entryId: entryId,
                period: period,
                startDay: startDay,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                required ExpensePeriod period,
                required int startDay,
                Value<ExpenseCategory?> category = const Value.absent(),
              }) => ExpenseDetailsCompanion.insert(
                entryId: entryId,
                period: period,
                startDay: startDay,
                category: category,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpenseDetailsTable, ExpenseDetail>(table),
                  $$ExpenseDetailsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $$ExpenseDetailsTableReferences
                            ._entryIdTable(db),
                        referencedColumn: $$ExpenseDetailsTableReferences
                            ._entryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExpenseDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $ExpenseDetailsTable,
      ExpenseDetail,
      $$ExpenseDetailsTableFilterComposer,
      $$ExpenseDetailsTableOrderingComposer,
      $$ExpenseDetailsTableAnnotationComposer,
      $$ExpenseDetailsTableCreateCompanionBuilder,
      $$ExpenseDetailsTableUpdateCompanionBuilder,
      (ExpenseDetail, $$ExpenseDetailsTableReferences),
      ExpenseDetail,
      PrefetchHooks Function({bool entryId})
    >;
typedef $$RemittancesTableCreateCompanionBuilder =
    RemittancesCompanion Function({
      Value<int> id,
      required String draftKey,
      required int sourceAccountId,
      Value<int?> destinationAccountId,
      required String destinationCurrency,
      required RemittanceDestination destination,
      Value<String?> beneficiary,
      Value<bool> cancelled,
      Value<bool> awaiting,
    });
typedef $$RemittancesTableUpdateCompanionBuilder =
    RemittancesCompanion Function({
      Value<int> id,
      Value<String> draftKey,
      Value<int> sourceAccountId,
      Value<int?> destinationAccountId,
      Value<String> destinationCurrency,
      Value<RemittanceDestination> destination,
      Value<String?> beneficiary,
      Value<bool> cancelled,
      Value<bool> awaiting,
    });

final class $$RemittancesTableReferences
    extends BaseReferences<_$LedgerDatabase, $RemittancesTable, Remittance> {
  $$RemittancesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LedgerAccountsTable _sourceAccountIdTable(_$LedgerDatabase db) => db
      .ledgerAccounts
      .createAlias('remittances__source_account_id__ledger_accounts__id');

  $$LedgerAccountsTableProcessedTableManager get sourceAccountId {
    final $_column = $_itemColumn<int>('source_account_id')!;

    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LedgerAccountsTable _destinationAccountIdTable(_$LedgerDatabase db) =>
      db.ledgerAccounts.createAlias(
        'remittances__destination_account_id__ledger_accounts__id',
      );

  $$LedgerAccountsTableProcessedTableManager? get destinationAccountId {
    final $_column = $_itemColumn<int>('destination_account_id');
    if ($_column == null) return null;
    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _destinationAccountIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CurrenciesTable _destinationCurrencyTable(_$LedgerDatabase db) => db
      .currencies
      .createAlias('remittances__destination_currency__currencies__code');

  $$CurrenciesTableProcessedTableManager get destinationCurrency {
    final $_column = $_itemColumn<String>('destination_currency')!;

    final manager = $$CurrenciesTableTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_destinationCurrencyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RemittanceEventsTable, List<RemittanceEvent>>
  _remittanceEventsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.remittanceEvents,
        aliasName: 'remittances__id__remittance_events__remittance_id',
      );

  $$RemittanceEventsTableProcessedTableManager get remittanceEventsRefs {
    final manager = $$RemittanceEventsTableTableManager(
      $_db,
      $_db.remittanceEvents,
    ).filter((f) => f.remittanceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _remittanceEventsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemittancePurposesTable, List<RemittancePurpose>>
  _remittancePurposesRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.remittancePurposes,
        aliasName: 'remittances__id__remittance_purposes__remittance_id',
      );

  $$RemittancePurposesTableProcessedTableManager get remittancePurposesRefs {
    final manager = $$RemittancePurposesTableTableManager(
      $_db,
      $_db.remittancePurposes,
    ).filter((f) => f.remittanceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _remittancePurposesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RemittancesTableFilterComposer
    extends Composer<_$LedgerDatabase, $RemittancesTable> {
  $$RemittancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get draftKey => $composableBuilder(
    column: $table.draftKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    RemittanceDestination,
    RemittanceDestination,
    String
  >
  get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get beneficiary => $composableBuilder(
    column: $table.beneficiary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cancelled => $composableBuilder(
    column: $table.cancelled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get awaiting => $composableBuilder(
    column: $table.awaiting,
    builder: (column) => ColumnFilters(column),
  );

  $$LedgerAccountsTableFilterComposer get sourceAccountId {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableFilterComposer get destinationAccountId {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurrenciesTableFilterComposer get destinationCurrency {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationCurrency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> remittanceEventsRefs(
    Expression<bool> Function($$RemittanceEventsTableFilterComposer f) f,
  ) {
    final $$RemittanceEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remittanceEvents,
      getReferencedColumn: (t) => t.remittanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittanceEventsTableFilterComposer(
            $db: $db,
            $table: $db.remittanceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remittancePurposesRefs(
    Expression<bool> Function($$RemittancePurposesTableFilterComposer f) f,
  ) {
    final $$RemittancePurposesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remittancePurposes,
      getReferencedColumn: (t) => t.remittanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancePurposesTableFilterComposer(
            $db: $db,
            $table: $db.remittancePurposes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RemittancesTableOrderingComposer
    extends Composer<_$LedgerDatabase, $RemittancesTable> {
  $$RemittancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get draftKey => $composableBuilder(
    column: $table.draftKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beneficiary => $composableBuilder(
    column: $table.beneficiary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cancelled => $composableBuilder(
    column: $table.cancelled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get awaiting => $composableBuilder(
    column: $table.awaiting,
    builder: (column) => ColumnOrderings(column),
  );

  $$LedgerAccountsTableOrderingComposer get sourceAccountId {
    final $$LedgerAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableOrderingComposer get destinationAccountId {
    final $$LedgerAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurrenciesTableOrderingComposer get destinationCurrency {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationCurrency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemittancesTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $RemittancesTable> {
  $$RemittancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get draftKey =>
      $composableBuilder(column: $table.draftKey, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RemittanceDestination, String>
  get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<String> get beneficiary => $composableBuilder(
    column: $table.beneficiary,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get cancelled =>
      $composableBuilder(column: $table.cancelled, builder: (column) => column);

  GeneratedColumn<bool> get awaiting =>
      $composableBuilder(column: $table.awaiting, builder: (column) => column);

  $$LedgerAccountsTableAnnotationComposer get sourceAccountId {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableAnnotationComposer get destinationAccountId {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurrenciesTableAnnotationComposer get destinationCurrency {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationCurrency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> remittanceEventsRefs<T extends Object>(
    Expression<T> Function($$RemittanceEventsTableAnnotationComposer a) f,
  ) {
    final $$RemittanceEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remittanceEvents,
      getReferencedColumn: (t) => t.remittanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittanceEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.remittanceEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remittancePurposesRefs<T extends Object>(
    Expression<T> Function($$RemittancePurposesTableAnnotationComposer a) f,
  ) {
    final $$RemittancePurposesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.remittancePurposes,
          getReferencedColumn: (t) => t.remittanceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RemittancePurposesTableAnnotationComposer(
                $db: $db,
                $table: $db.remittancePurposes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RemittancesTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $RemittancesTable,
          Remittance,
          $$RemittancesTableFilterComposer,
          $$RemittancesTableOrderingComposer,
          $$RemittancesTableAnnotationComposer,
          $$RemittancesTableCreateCompanionBuilder,
          $$RemittancesTableUpdateCompanionBuilder,
          (Remittance, $$RemittancesTableReferences),
          Remittance,
          PrefetchHooks Function({
            bool sourceAccountId,
            bool destinationAccountId,
            bool destinationCurrency,
            bool remittanceEventsRefs,
            bool remittancePurposesRefs,
          })
        > {
  $$RemittancesTableTableManager(_$LedgerDatabase db, $RemittancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemittancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemittancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemittancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> draftKey = const Value.absent(),
                Value<int> sourceAccountId = const Value.absent(),
                Value<int?> destinationAccountId = const Value.absent(),
                Value<String> destinationCurrency = const Value.absent(),
                Value<RemittanceDestination> destination = const Value.absent(),
                Value<String?> beneficiary = const Value.absent(),
                Value<bool> cancelled = const Value.absent(),
                Value<bool> awaiting = const Value.absent(),
              }) => RemittancesCompanion(
                id: id,
                draftKey: draftKey,
                sourceAccountId: sourceAccountId,
                destinationAccountId: destinationAccountId,
                destinationCurrency: destinationCurrency,
                destination: destination,
                beneficiary: beneficiary,
                cancelled: cancelled,
                awaiting: awaiting,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String draftKey,
                required int sourceAccountId,
                Value<int?> destinationAccountId = const Value.absent(),
                required String destinationCurrency,
                required RemittanceDestination destination,
                Value<String?> beneficiary = const Value.absent(),
                Value<bool> cancelled = const Value.absent(),
                Value<bool> awaiting = const Value.absent(),
              }) => RemittancesCompanion.insert(
                id: id,
                draftKey: draftKey,
                sourceAccountId: sourceAccountId,
                destinationAccountId: destinationAccountId,
                destinationCurrency: destinationCurrency,
                destination: destination,
                beneficiary: beneficiary,
                cancelled: cancelled,
                awaiting: awaiting,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemittancesTable, Remittance>(table),
                  $$RemittancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sourceAccountId = false,
                destinationAccountId = false,
                destinationCurrency = false,
                remittanceEventsRefs = false,
                remittancePurposesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (remittanceEventsRefs) db.remittanceEvents,
                    if (remittancePurposesRefs) db.remittancePurposes,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourceAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceAccountId,
                            referencedTable: $$RemittancesTableReferences
                                ._sourceAccountIdTable(db),
                            referencedColumn: $$RemittancesTableReferences
                                ._sourceAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (destinationAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.destinationAccountId,
                            referencedTable: $$RemittancesTableReferences
                                ._destinationAccountIdTable(db),
                            referencedColumn: $$RemittancesTableReferences
                                ._destinationAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (destinationCurrency) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.destinationCurrency,
                            referencedTable: $$RemittancesTableReferences
                                ._destinationCurrencyTable(db),
                            referencedColumn: $$RemittancesTableReferences
                                ._destinationCurrencyTable(db)
                                .code,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (remittanceEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          Remittance,
                          $RemittancesTable,
                          RemittanceEvent,
                          $RemittanceEventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$RemittancesTableReferences
                              ._remittanceEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RemittancesTableReferences(
                                db,
                                table,
                                p0,
                              ).remittanceEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'remittance_id',
                          typedResults: items,
                        ),
                      if (remittancePurposesRefs)
                        await $_getPrefetchedDataByColumns<
                          Remittance,
                          $RemittancesTable,
                          RemittancePurpose,
                          $RemittancePurposesTable
                        >(
                          currentTable: table,
                          referencedTable: $$RemittancesTableReferences
                              ._remittancePurposesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RemittancesTableReferences(
                                db,
                                table,
                                p0,
                              ).remittancePurposesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'remittance_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RemittancesTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $RemittancesTable,
      Remittance,
      $$RemittancesTableFilterComposer,
      $$RemittancesTableOrderingComposer,
      $$RemittancesTableAnnotationComposer,
      $$RemittancesTableCreateCompanionBuilder,
      $$RemittancesTableUpdateCompanionBuilder,
      (Remittance, $$RemittancesTableReferences),
      Remittance,
      PrefetchHooks Function({
        bool sourceAccountId,
        bool destinationAccountId,
        bool destinationCurrency,
        bool remittanceEventsRefs,
        bool remittancePurposesRefs,
      })
    >;
typedef $$RemittanceEventsTableCreateCompanionBuilder =
    RemittanceEventsCompanion Function({
      Value<int> entryId,
      required int remittanceId,
      required RemittanceEventKind kind,
      required String evidence,
      Value<int?> feeMinor,
      Value<int?> receiptEntryId,
    });
typedef $$RemittanceEventsTableUpdateCompanionBuilder =
    RemittanceEventsCompanion Function({
      Value<int> entryId,
      Value<int> remittanceId,
      Value<RemittanceEventKind> kind,
      Value<String> evidence,
      Value<int?> feeMinor,
      Value<int?> receiptEntryId,
    });

final class $$RemittanceEventsTableReferences
    extends
        BaseReferences<
          _$LedgerDatabase,
          $RemittanceEventsTable,
          RemittanceEvent
        > {
  $$RemittanceEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _entryIdTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('remittance_events__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RemittancesTable _remittanceIdTable(_$LedgerDatabase db) => db
      .remittances
      .createAlias('remittance_events__remittance_id__remittances__id');

  $$RemittancesTableProcessedTableManager get remittanceId {
    final $_column = $_itemColumn<int>('remittance_id')!;

    final manager = $$RemittancesTableTableManager(
      $_db,
      $_db.remittances,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_remittanceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $JournalEntriesTable _receiptEntryIdTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('remittance_events__receipt_entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager? get receiptEntryId {
    final $_column = $_itemColumn<int>('receipt_entry_id');
    if ($_column == null) return null;
    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_receiptEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemittanceEventsTableFilterComposer
    extends Composer<_$LedgerDatabase, $RemittanceEventsTable> {
  $$RemittanceEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<
    RemittanceEventKind,
    RemittanceEventKind,
    String
  >
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get evidence => $composableBuilder(
    column: $table.evidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get feeMinor => $composableBuilder(
    column: $table.feeMinor,
    builder: (column) => ColumnFilters(column),
  );

  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RemittancesTableFilterComposer get remittanceId {
    final $$RemittancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remittanceId,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableFilterComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableFilterComposer get receiptEntryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptEntryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemittanceEventsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $RemittanceEventsTable> {
  $$RemittanceEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidence => $composableBuilder(
    column: $table.evidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get feeMinor => $composableBuilder(
    column: $table.feeMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RemittancesTableOrderingComposer get remittanceId {
    final $$RemittancesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remittanceId,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableOrderingComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableOrderingComposer get receiptEntryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptEntryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemittanceEventsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $RemittanceEventsTable> {
  $$RemittanceEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<RemittanceEventKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get evidence =>
      $composableBuilder(column: $table.evidence, builder: (column) => column);

  GeneratedColumn<int> get feeMinor =>
      $composableBuilder(column: $table.feeMinor, builder: (column) => column);

  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RemittancesTableAnnotationComposer get remittanceId {
    final $$RemittancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remittanceId,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableAnnotationComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableAnnotationComposer get receiptEntryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptEntryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemittanceEventsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $RemittanceEventsTable,
          RemittanceEvent,
          $$RemittanceEventsTableFilterComposer,
          $$RemittanceEventsTableOrderingComposer,
          $$RemittanceEventsTableAnnotationComposer,
          $$RemittanceEventsTableCreateCompanionBuilder,
          $$RemittanceEventsTableUpdateCompanionBuilder,
          (RemittanceEvent, $$RemittanceEventsTableReferences),
          RemittanceEvent,
          PrefetchHooks Function({
            bool entryId,
            bool remittanceId,
            bool receiptEntryId,
          })
        > {
  $$RemittanceEventsTableTableManager(
    _$LedgerDatabase db,
    $RemittanceEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemittanceEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemittanceEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemittanceEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                Value<int> remittanceId = const Value.absent(),
                Value<RemittanceEventKind> kind = const Value.absent(),
                Value<String> evidence = const Value.absent(),
                Value<int?> feeMinor = const Value.absent(),
                Value<int?> receiptEntryId = const Value.absent(),
              }) => RemittanceEventsCompanion(
                entryId: entryId,
                remittanceId: remittanceId,
                kind: kind,
                evidence: evidence,
                feeMinor: feeMinor,
                receiptEntryId: receiptEntryId,
              ),
          createCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                required int remittanceId,
                required RemittanceEventKind kind,
                required String evidence,
                Value<int?> feeMinor = const Value.absent(),
                Value<int?> receiptEntryId = const Value.absent(),
              }) => RemittanceEventsCompanion.insert(
                entryId: entryId,
                remittanceId: remittanceId,
                kind: kind,
                evidence: evidence,
                feeMinor: feeMinor,
                receiptEntryId: receiptEntryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemittanceEventsTable, RemittanceEvent>(table),
                  $$RemittanceEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                entryId = false,
                remittanceId = false,
                receiptEntryId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (entryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.entryId,
                            referencedTable: $$RemittanceEventsTableReferences
                                ._entryIdTable(db),
                            referencedColumn: $$RemittanceEventsTableReferences
                                ._entryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (remittanceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.remittanceId,
                            referencedTable: $$RemittanceEventsTableReferences
                                ._remittanceIdTable(db),
                            referencedColumn: $$RemittanceEventsTableReferences
                                ._remittanceIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (receiptEntryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.receiptEntryId,
                            referencedTable: $$RemittanceEventsTableReferences
                                ._receiptEntryIdTable(db),
                            referencedColumn: $$RemittanceEventsTableReferences
                                ._receiptEntryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RemittanceEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $RemittanceEventsTable,
      RemittanceEvent,
      $$RemittanceEventsTableFilterComposer,
      $$RemittanceEventsTableOrderingComposer,
      $$RemittanceEventsTableAnnotationComposer,
      $$RemittanceEventsTableCreateCompanionBuilder,
      $$RemittanceEventsTableUpdateCompanionBuilder,
      (RemittanceEvent, $$RemittanceEventsTableReferences),
      RemittanceEvent,
      PrefetchHooks Function({
        bool entryId,
        bool remittanceId,
        bool receiptEntryId,
      })
    >;
typedef $$RemittancePurposesTableCreateCompanionBuilder =
    RemittancePurposesCompanion Function({
      required String operationKey,
      required int remittanceId,
      required String label,
      required int minor,
      Value<bool> family,
      Value<int> rowid,
    });
typedef $$RemittancePurposesTableUpdateCompanionBuilder =
    RemittancePurposesCompanion Function({
      Value<String> operationKey,
      Value<int> remittanceId,
      Value<String> label,
      Value<int> minor,
      Value<bool> family,
      Value<int> rowid,
    });

final class $$RemittancePurposesTableReferences
    extends
        BaseReferences<
          _$LedgerDatabase,
          $RemittancePurposesTable,
          RemittancePurpose
        > {
  $$RemittancePurposesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RemittancesTable _remittanceIdTable(_$LedgerDatabase db) => db
      .remittances
      .createAlias('remittance_purposes__remittance_id__remittances__id');

  $$RemittancesTableProcessedTableManager get remittanceId {
    final $_column = $_itemColumn<int>('remittance_id')!;

    final manager = $$RemittancesTableTableManager(
      $_db,
      $_db.remittances,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_remittanceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RemittanceFamilyPaymentsTable,
    List<RemittanceFamilyPayment>
  >
  _remittanceFamilyPaymentsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.remittanceFamilyPayments,
        aliasName: 'remittance_purposes__operation_key__remittance_family_payments__purpose_key',
      );

  $$RemittanceFamilyPaymentsTableProcessedTableManager
  get remittanceFamilyPaymentsRefs {
    final manager =
        $$RemittanceFamilyPaymentsTableTableManager(
          $_db,
          $_db.remittanceFamilyPayments,
        ).filter(
          (f) => f.purposeKey.operationKey.sqlEquals(
            $_itemColumn<String>('operation_key')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _remittanceFamilyPaymentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RemittancePurposesTableFilterComposer
    extends Composer<_$LedgerDatabase, $RemittancePurposesTable> {
  $$RemittancePurposesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationKey => $composableBuilder(
    column: $table.operationKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minor => $composableBuilder(
    column: $table.minor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get family => $composableBuilder(
    column: $table.family,
    builder: (column) => ColumnFilters(column),
  );

  $$RemittancesTableFilterComposer get remittanceId {
    final $$RemittancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remittanceId,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableFilterComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> remittanceFamilyPaymentsRefs(
    Expression<bool> Function($$RemittanceFamilyPaymentsTableFilterComposer f)
    f,
  ) {
    final $$RemittanceFamilyPaymentsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.operationKey,
          referencedTable: $db.remittanceFamilyPayments,
          getReferencedColumn: (t) => t.purposeKey,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RemittanceFamilyPaymentsTableFilterComposer(
                $db: $db,
                $table: $db.remittanceFamilyPayments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RemittancePurposesTableOrderingComposer
    extends Composer<_$LedgerDatabase, $RemittancePurposesTable> {
  $$RemittancePurposesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationKey => $composableBuilder(
    column: $table.operationKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minor => $composableBuilder(
    column: $table.minor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get family => $composableBuilder(
    column: $table.family,
    builder: (column) => ColumnOrderings(column),
  );

  $$RemittancesTableOrderingComposer get remittanceId {
    final $$RemittancesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remittanceId,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableOrderingComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemittancePurposesTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $RemittancePurposesTable> {
  $$RemittancePurposesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationKey => $composableBuilder(
    column: $table.operationKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get minor =>
      $composableBuilder(column: $table.minor, builder: (column) => column);

  GeneratedColumn<bool> get family =>
      $composableBuilder(column: $table.family, builder: (column) => column);

  $$RemittancesTableAnnotationComposer get remittanceId {
    final $$RemittancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.remittanceId,
      referencedTable: $db.remittances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancesTableAnnotationComposer(
            $db: $db,
            $table: $db.remittances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> remittanceFamilyPaymentsRefs<T extends Object>(
    Expression<T> Function($$RemittanceFamilyPaymentsTableAnnotationComposer a)
    f,
  ) {
    final $$RemittanceFamilyPaymentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.operationKey,
          referencedTable: $db.remittanceFamilyPayments,
          getReferencedColumn: (t) => t.purposeKey,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RemittanceFamilyPaymentsTableAnnotationComposer(
                $db: $db,
                $table: $db.remittanceFamilyPayments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RemittancePurposesTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $RemittancePurposesTable,
          RemittancePurpose,
          $$RemittancePurposesTableFilterComposer,
          $$RemittancePurposesTableOrderingComposer,
          $$RemittancePurposesTableAnnotationComposer,
          $$RemittancePurposesTableCreateCompanionBuilder,
          $$RemittancePurposesTableUpdateCompanionBuilder,
          (RemittancePurpose, $$RemittancePurposesTableReferences),
          RemittancePurpose,
          PrefetchHooks Function({
            bool remittanceId,
            bool remittanceFamilyPaymentsRefs,
          })
        > {
  $$RemittancePurposesTableTableManager(
    _$LedgerDatabase db,
    $RemittancePurposesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemittancePurposesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemittancePurposesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemittancePurposesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationKey = const Value.absent(),
                Value<int> remittanceId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> minor = const Value.absent(),
                Value<bool> family = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemittancePurposesCompanion(
                operationKey: operationKey,
                remittanceId: remittanceId,
                label: label,
                minor: minor,
                family: family,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationKey,
                required int remittanceId,
                required String label,
                required int minor,
                Value<bool> family = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemittancePurposesCompanion.insert(
                operationKey: operationKey,
                remittanceId: remittanceId,
                label: label,
                minor: minor,
                family: family,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemittancePurposesTable, RemittancePurpose>(
                    table,
                  ),
                  $$RemittancePurposesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({remittanceId = false, remittanceFamilyPaymentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (remittanceFamilyPaymentsRefs)
                      db.remittanceFamilyPayments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (remittanceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.remittanceId,
                            referencedTable: $$RemittancePurposesTableReferences
                                ._remittanceIdTable(db),
                            referencedColumn:
                                $$RemittancePurposesTableReferences
                                    ._remittanceIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (remittanceFamilyPaymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          RemittancePurpose,
                          $RemittancePurposesTable,
                          RemittanceFamilyPayment,
                          $RemittanceFamilyPaymentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$RemittancePurposesTableReferences
                              ._remittanceFamilyPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RemittancePurposesTableReferences(
                                db,
                                table,
                                p0,
                              ).remittanceFamilyPaymentsRefs,
                          currentColumn: 'operation_key',
                          referencedColumn: 'purpose_key',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RemittancePurposesTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $RemittancePurposesTable,
      RemittancePurpose,
      $$RemittancePurposesTableFilterComposer,
      $$RemittancePurposesTableOrderingComposer,
      $$RemittancePurposesTableAnnotationComposer,
      $$RemittancePurposesTableCreateCompanionBuilder,
      $$RemittancePurposesTableUpdateCompanionBuilder,
      (RemittancePurpose, $$RemittancePurposesTableReferences),
      RemittancePurpose,
      PrefetchHooks Function({
        bool remittanceId,
        bool remittanceFamilyPaymentsRefs,
      })
    >;
typedef $$RemittanceFamilyPaymentsTableCreateCompanionBuilder =
    RemittanceFamilyPaymentsCompanion Function({
      Value<int> entryId,
      required String purposeKey,
    });
typedef $$RemittanceFamilyPaymentsTableUpdateCompanionBuilder =
    RemittanceFamilyPaymentsCompanion Function({
      Value<int> entryId,
      Value<String> purposeKey,
    });

final class $$RemittanceFamilyPaymentsTableReferences
    extends
        BaseReferences<
          _$LedgerDatabase,
          $RemittanceFamilyPaymentsTable,
          RemittanceFamilyPayment
        > {
  $$RemittanceFamilyPaymentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _entryIdTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('remittance_family_payments__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RemittancePurposesTable _purposeKeyTable(_$LedgerDatabase db) =>
      db.remittancePurposes.createAlias(
        'remittance_family_payments__purpose_key__remittance_purposes__operation_key',
      );

  $$RemittancePurposesTableProcessedTableManager get purposeKey {
    final $_column = $_itemColumn<String>('purpose_key')!;

    final manager = $$RemittancePurposesTableTableManager(
      $_db,
      $_db.remittancePurposes,
    ).filter((f) => f.operationKey.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purposeKeyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemittanceFamilyPaymentsTableFilterComposer
    extends Composer<_$LedgerDatabase, $RemittanceFamilyPaymentsTable> {
  $$RemittanceFamilyPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RemittancePurposesTableFilterComposer get purposeKey {
    final $$RemittancePurposesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purposeKey,
      referencedTable: $db.remittancePurposes,
      getReferencedColumn: (t) => t.operationKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancePurposesTableFilterComposer(
            $db: $db,
            $table: $db.remittancePurposes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemittanceFamilyPaymentsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $RemittanceFamilyPaymentsTable> {
  $$RemittanceFamilyPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RemittancePurposesTableOrderingComposer get purposeKey {
    final $$RemittancePurposesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purposeKey,
      referencedTable: $db.remittancePurposes,
      getReferencedColumn: (t) => t.operationKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemittancePurposesTableOrderingComposer(
            $db: $db,
            $table: $db.remittancePurposes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemittanceFamilyPaymentsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $RemittanceFamilyPaymentsTable> {
  $$RemittanceFamilyPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RemittancePurposesTableAnnotationComposer get purposeKey {
    final $$RemittancePurposesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.purposeKey,
          referencedTable: $db.remittancePurposes,
          getReferencedColumn: (t) => t.operationKey,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RemittancePurposesTableAnnotationComposer(
                $db: $db,
                $table: $db.remittancePurposes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$RemittanceFamilyPaymentsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $RemittanceFamilyPaymentsTable,
          RemittanceFamilyPayment,
          $$RemittanceFamilyPaymentsTableFilterComposer,
          $$RemittanceFamilyPaymentsTableOrderingComposer,
          $$RemittanceFamilyPaymentsTableAnnotationComposer,
          $$RemittanceFamilyPaymentsTableCreateCompanionBuilder,
          $$RemittanceFamilyPaymentsTableUpdateCompanionBuilder,
          (RemittanceFamilyPayment, $$RemittanceFamilyPaymentsTableReferences),
          RemittanceFamilyPayment,
          PrefetchHooks Function({bool entryId, bool purposeKey})
        > {
  $$RemittanceFamilyPaymentsTableTableManager(
    _$LedgerDatabase db,
    $RemittanceFamilyPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemittanceFamilyPaymentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RemittanceFamilyPaymentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RemittanceFamilyPaymentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                Value<String> purposeKey = const Value.absent(),
              }) => RemittanceFamilyPaymentsCompanion(
                entryId: entryId,
                purposeKey: purposeKey,
              ),
          createCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                required String purposeKey,
              }) => RemittanceFamilyPaymentsCompanion.insert(
                entryId: entryId,
                purposeKey: purposeKey,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $RemittanceFamilyPaymentsTable,
                    RemittanceFamilyPayment
                  >(table),
                  $$RemittanceFamilyPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false, purposeKey = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable:
                            $$RemittanceFamilyPaymentsTableReferences
                                ._entryIdTable(db),
                        referencedColumn:
                            $$RemittanceFamilyPaymentsTableReferences
                                ._entryIdTable(db)
                                .id,
                      ) as T;
                    }
                    if (purposeKey) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.purposeKey,
                        referencedTable:
                            $$RemittanceFamilyPaymentsTableReferences
                                ._purposeKeyTable(db),
                        referencedColumn:
                            $$RemittanceFamilyPaymentsTableReferences
                                ._purposeKeyTable(db)
                                .operationKey,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RemittanceFamilyPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $RemittanceFamilyPaymentsTable,
      RemittanceFamilyPayment,
      $$RemittanceFamilyPaymentsTableFilterComposer,
      $$RemittanceFamilyPaymentsTableOrderingComposer,
      $$RemittanceFamilyPaymentsTableAnnotationComposer,
      $$RemittanceFamilyPaymentsTableCreateCompanionBuilder,
      $$RemittanceFamilyPaymentsTableUpdateCompanionBuilder,
      (RemittanceFamilyPayment, $$RemittanceFamilyPaymentsTableReferences),
      RemittanceFamilyPayment,
      PrefetchHooks Function({bool entryId, bool purposeKey})
    >;
typedef $$LeaveRulesTableCreateCompanionBuilder = LeaveRulesCompanion Function({
  Value<int> effectiveDay,
  required int annualDays,
  required int casualDays,
  required int sickDays,
});
typedef $$LeaveRulesTableUpdateCompanionBuilder = LeaveRulesCompanion Function({
  Value<int> effectiveDay,
  Value<int> annualDays,
  Value<int> casualDays,
  Value<int> sickDays,
});

class $$LeaveRulesTableFilterComposer
    extends Composer<_$LedgerDatabase, $LeaveRulesTable> {
  $$LeaveRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get effectiveDay => $composableBuilder(
    column: $table.effectiveDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get annualDays => $composableBuilder(
    column: $table.annualDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get casualDays => $composableBuilder(
    column: $table.casualDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sickDays => $composableBuilder(
    column: $table.sickDays,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeaveRulesTableOrderingComposer
    extends Composer<_$LedgerDatabase, $LeaveRulesTable> {
  $$LeaveRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get effectiveDay => $composableBuilder(
    column: $table.effectiveDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get annualDays => $composableBuilder(
    column: $table.annualDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get casualDays => $composableBuilder(
    column: $table.casualDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sickDays => $composableBuilder(
    column: $table.sickDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaveRulesTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $LeaveRulesTable> {
  $$LeaveRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get effectiveDay => $composableBuilder(
    column: $table.effectiveDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get annualDays => $composableBuilder(
    column: $table.annualDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get casualDays => $composableBuilder(
    column: $table.casualDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sickDays =>
      $composableBuilder(column: $table.sickDays, builder: (column) => column);
}

class $$LeaveRulesTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $LeaveRulesTable,
          LeaveRule,
          $$LeaveRulesTableFilterComposer,
          $$LeaveRulesTableOrderingComposer,
          $$LeaveRulesTableAnnotationComposer,
          $$LeaveRulesTableCreateCompanionBuilder,
          $$LeaveRulesTableUpdateCompanionBuilder,
          (
            LeaveRule,
            BaseReferences<_$LedgerDatabase, $LeaveRulesTable, LeaveRule>,
          ),
          LeaveRule,
          PrefetchHooks Function()
        > {
  $$LeaveRulesTableTableManager(_$LedgerDatabase db, $LeaveRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> effectiveDay = const Value.absent(),
                Value<int> annualDays = const Value.absent(),
                Value<int> casualDays = const Value.absent(),
                Value<int> sickDays = const Value.absent(),
              }) => LeaveRulesCompanion(
                effectiveDay: effectiveDay,
                annualDays: annualDays,
                casualDays: casualDays,
                sickDays: sickDays,
              ),
          createCompanionCallback:
              ({
                Value<int> effectiveDay = const Value.absent(),
                required int annualDays,
                required int casualDays,
                required int sickDays,
              }) => LeaveRulesCompanion.insert(
                effectiveDay: effectiveDay,
                annualDays: annualDays,
                casualDays: casualDays,
                sickDays: sickDays,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LeaveRulesTable, LeaveRule>(table),
                  BaseReferences<_$LedgerDatabase, $LeaveRulesTable, LeaveRule>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeaveRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $LeaveRulesTable,
      LeaveRule,
      $$LeaveRulesTableFilterComposer,
      $$LeaveRulesTableOrderingComposer,
      $$LeaveRulesTableAnnotationComposer,
      $$LeaveRulesTableCreateCompanionBuilder,
      $$LeaveRulesTableUpdateCompanionBuilder,
      (
        LeaveRule,
        BaseReferences<_$LedgerDatabase, $LeaveRulesTable, LeaveRule>,
      ),
      LeaveRule,
      PrefetchHooks Function()
    >;
typedef $$LeaveEntriesTableCreateCompanionBuilder =
    LeaveEntriesCompanion Function({
      Value<int> id,
      required LeaveKind kind,
      required LeaveStatus status,
      required int startDay,
      required int endDay,
      required String occasion,
      required MedicalReport medicalReport,
    });
typedef $$LeaveEntriesTableUpdateCompanionBuilder =
    LeaveEntriesCompanion Function({
      Value<int> id,
      Value<LeaveKind> kind,
      Value<LeaveStatus> status,
      Value<int> startDay,
      Value<int> endDay,
      Value<String> occasion,
      Value<MedicalReport> medicalReport,
    });

final class $$LeaveEntriesTableReferences
    extends BaseReferences<_$LedgerDatabase, $LeaveEntriesTable, LeaveEntry> {
  $$LeaveEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AnnualTicketsTable, List<AnnualTicket>>
  _annualTicketsRefsTable(_$LedgerDatabase db) => MultiTypedResultKey.fromTable(
    db.annualTickets,
    aliasName: 'leave_entries__id__annual_tickets__leave_id',
  );

  $$AnnualTicketsTableProcessedTableManager get annualTicketsRefs {
    final manager = $$AnnualTicketsTableTableManager(
      $_db,
      $_db.annualTickets,
    ).filter((f) => f.leaveId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_annualTicketsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LeaveEntriesTableFilterComposer
    extends Composer<_$LedgerDatabase, $LeaveEntriesTable> {
  $$LeaveEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LeaveKind, LeaveKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<LeaveStatus, LeaveStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDay => $composableBuilder(
    column: $table.endDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occasion => $composableBuilder(
    column: $table.occasion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MedicalReport, MedicalReport, String>
  get medicalReport => $composableBuilder(
    column: $table.medicalReport,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  Expression<bool> annualTicketsRefs(
    Expression<bool> Function($$AnnualTicketsTableFilterComposer f) f,
  ) {
    final $$AnnualTicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annualTickets,
      getReferencedColumn: (t) => t.leaveId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnualTicketsTableFilterComposer(
            $db: $db,
            $table: $db.annualTickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LeaveEntriesTableOrderingComposer
    extends Composer<_$LedgerDatabase, $LeaveEntriesTable> {
  $$LeaveEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDay => $composableBuilder(
    column: $table.endDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occasion => $composableBuilder(
    column: $table.occasion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicalReport => $composableBuilder(
    column: $table.medicalReport,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaveEntriesTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $LeaveEntriesTable> {
  $$LeaveEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeaveKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeaveStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get startDay =>
      $composableBuilder(column: $table.startDay, builder: (column) => column);

  GeneratedColumn<int> get endDay =>
      $composableBuilder(column: $table.endDay, builder: (column) => column);

  GeneratedColumn<String> get occasion =>
      $composableBuilder(column: $table.occasion, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MedicalReport, String> get medicalReport =>
      $composableBuilder(
        column: $table.medicalReport,
        builder: (column) => column,
      );

  Expression<T> annualTicketsRefs<T extends Object>(
    Expression<T> Function($$AnnualTicketsTableAnnotationComposer a) f,
  ) {
    final $$AnnualTicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annualTickets,
      getReferencedColumn: (t) => t.leaveId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnualTicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.annualTickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LeaveEntriesTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $LeaveEntriesTable,
          LeaveEntry,
          $$LeaveEntriesTableFilterComposer,
          $$LeaveEntriesTableOrderingComposer,
          $$LeaveEntriesTableAnnotationComposer,
          $$LeaveEntriesTableCreateCompanionBuilder,
          $$LeaveEntriesTableUpdateCompanionBuilder,
          (LeaveEntry, $$LeaveEntriesTableReferences),
          LeaveEntry,
          PrefetchHooks Function({bool annualTicketsRefs})
        > {
  $$LeaveEntriesTableTableManager(_$LedgerDatabase db, $LeaveEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<LeaveKind> kind = const Value.absent(),
                Value<LeaveStatus> status = const Value.absent(),
                Value<int> startDay = const Value.absent(),
                Value<int> endDay = const Value.absent(),
                Value<String> occasion = const Value.absent(),
                Value<MedicalReport> medicalReport = const Value.absent(),
              }) => LeaveEntriesCompanion(
                id: id,
                kind: kind,
                status: status,
                startDay: startDay,
                endDay: endDay,
                occasion: occasion,
                medicalReport: medicalReport,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required LeaveKind kind,
                required LeaveStatus status,
                required int startDay,
                required int endDay,
                required String occasion,
                required MedicalReport medicalReport,
              }) => LeaveEntriesCompanion.insert(
                id: id,
                kind: kind,
                status: status,
                startDay: startDay,
                endDay: endDay,
                occasion: occasion,
                medicalReport: medicalReport,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LeaveEntriesTable, LeaveEntry>(table),
                  $$LeaveEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({annualTicketsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (annualTicketsRefs) db.annualTickets,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (annualTicketsRefs)
                    await $_getPrefetchedDataByColumns<
                      LeaveEntry,
                      $LeaveEntriesTable,
                      AnnualTicket,
                      $AnnualTicketsTable
                    >(
                      currentTable: table,
                      referencedTable: $$LeaveEntriesTableReferences
                          ._annualTicketsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LeaveEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).annualTicketsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'leave_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LeaveEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $LeaveEntriesTable,
      LeaveEntry,
      $$LeaveEntriesTableFilterComposer,
      $$LeaveEntriesTableOrderingComposer,
      $$LeaveEntriesTableAnnotationComposer,
      $$LeaveEntriesTableCreateCompanionBuilder,
      $$LeaveEntriesTableUpdateCompanionBuilder,
      (LeaveEntry, $$LeaveEntriesTableReferences),
      LeaveEntry,
      PrefetchHooks Function({bool annualTicketsRefs})
    >;
typedef $$LeaveHolidaysTableCreateCompanionBuilder =
    LeaveHolidaysCompanion Function({Value<int> day, required String name});
typedef $$LeaveHolidaysTableUpdateCompanionBuilder =
    LeaveHolidaysCompanion Function({Value<int> day, Value<String> name});

class $$LeaveHolidaysTableFilterComposer
    extends Composer<_$LedgerDatabase, $LeaveHolidaysTable> {
  $$LeaveHolidaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeaveHolidaysTableOrderingComposer
    extends Composer<_$LedgerDatabase, $LeaveHolidaysTable> {
  $$LeaveHolidaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaveHolidaysTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $LeaveHolidaysTable> {
  $$LeaveHolidaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$LeaveHolidaysTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $LeaveHolidaysTable,
          LeaveHoliday,
          $$LeaveHolidaysTableFilterComposer,
          $$LeaveHolidaysTableOrderingComposer,
          $$LeaveHolidaysTableAnnotationComposer,
          $$LeaveHolidaysTableCreateCompanionBuilder,
          $$LeaveHolidaysTableUpdateCompanionBuilder,
          (
            LeaveHoliday,
            BaseReferences<_$LedgerDatabase, $LeaveHolidaysTable, LeaveHoliday>,
          ),
          LeaveHoliday,
          PrefetchHooks Function()
        > {
  $$LeaveHolidaysTableTableManager(
    _$LedgerDatabase db,
    $LeaveHolidaysTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveHolidaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveHolidaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveHolidaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> day = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => LeaveHolidaysCompanion(day: day, name: name),
          createCompanionCallback: ({
            Value<int> day = const Value.absent(),
            required String name,
          }) => LeaveHolidaysCompanion.insert(day: day, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LeaveHolidaysTable, LeaveHoliday>(table),
                  BaseReferences<
                    _$LedgerDatabase,
                    $LeaveHolidaysTable,
                    LeaveHoliday
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeaveHolidaysTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $LeaveHolidaysTable,
      LeaveHoliday,
      $$LeaveHolidaysTableFilterComposer,
      $$LeaveHolidaysTableOrderingComposer,
      $$LeaveHolidaysTableAnnotationComposer,
      $$LeaveHolidaysTableCreateCompanionBuilder,
      $$LeaveHolidaysTableUpdateCompanionBuilder,
      (
        LeaveHoliday,
        BaseReferences<_$LedgerDatabase, $LeaveHolidaysTable, LeaveHoliday>,
      ),
      LeaveHoliday,
      PrefetchHooks Function()
    >;
typedef $$DashainPlansTableCreateCompanionBuilder =
    DashainPlansCompanion Function({
      Value<int> year,
      required int festivalDay,
      required String currency,
      required int salaryMinor,
      required int allowancesMinor,
      Value<int?> receiptId,
      Value<int> revision,
    });
typedef $$DashainPlansTableUpdateCompanionBuilder =
    DashainPlansCompanion Function({
      Value<int> year,
      Value<int> festivalDay,
      Value<String> currency,
      Value<int> salaryMinor,
      Value<int> allowancesMinor,
      Value<int?> receiptId,
      Value<int> revision,
    });

final class $$DashainPlansTableReferences
    extends BaseReferences<_$LedgerDatabase, $DashainPlansTable, DashainPlan> {
  $$DashainPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CurrenciesTable _currencyTable(_$LedgerDatabase db) =>
      db.currencies.createAlias('dashain_plans__currency__currencies__code');

  $$CurrenciesTableProcessedTableManager get currency {
    final $_column = $_itemColumn<String>('currency')!;

    final manager = $$CurrenciesTableTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $JournalEntriesTable _receiptIdTable(_$LedgerDatabase db) => db
      .journalEntries
      .createAlias('dashain_plans__receipt_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager? get receiptId {
    final $_column = $_itemColumn<int>('receipt_id');
    if ($_column == null) return null;
    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_receiptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DashainPlansTableFilterComposer
    extends Composer<_$LedgerDatabase, $DashainPlansTable> {
  $$DashainPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get festivalDay => $composableBuilder(
    column: $table.festivalDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salaryMinor => $composableBuilder(
    column: $table.salaryMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allowancesMinor => $composableBuilder(
    column: $table.allowancesMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $$CurrenciesTableFilterComposer get currency {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableFilterComposer get receiptId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DashainPlansTableOrderingComposer
    extends Composer<_$LedgerDatabase, $DashainPlansTable> {
  $$DashainPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get festivalDay => $composableBuilder(
    column: $table.festivalDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salaryMinor => $composableBuilder(
    column: $table.salaryMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allowancesMinor => $composableBuilder(
    column: $table.allowancesMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $$CurrenciesTableOrderingComposer get currency {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableOrderingComposer get receiptId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DashainPlansTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $DashainPlansTable> {
  $$DashainPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get festivalDay => $composableBuilder(
    column: $table.festivalDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get salaryMinor => $composableBuilder(
    column: $table.salaryMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allowancesMinor => $composableBuilder(
    column: $table.allowancesMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $$CurrenciesTableAnnotationComposer get currency {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$JournalEntriesTableAnnotationComposer get receiptId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DashainPlansTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $DashainPlansTable,
          DashainPlan,
          $$DashainPlansTableFilterComposer,
          $$DashainPlansTableOrderingComposer,
          $$DashainPlansTableAnnotationComposer,
          $$DashainPlansTableCreateCompanionBuilder,
          $$DashainPlansTableUpdateCompanionBuilder,
          (DashainPlan, $$DashainPlansTableReferences),
          DashainPlan,
          PrefetchHooks Function({bool currency, bool receiptId})
        > {
  $$DashainPlansTableTableManager(_$LedgerDatabase db, $DashainPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DashainPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DashainPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DashainPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> year = const Value.absent(),
                Value<int> festivalDay = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> salaryMinor = const Value.absent(),
                Value<int> allowancesMinor = const Value.absent(),
                Value<int?> receiptId = const Value.absent(),
                Value<int> revision = const Value.absent(),
              }) => DashainPlansCompanion(
                year: year,
                festivalDay: festivalDay,
                currency: currency,
                salaryMinor: salaryMinor,
                allowancesMinor: allowancesMinor,
                receiptId: receiptId,
                revision: revision,
              ),
          createCompanionCallback:
              ({
                Value<int> year = const Value.absent(),
                required int festivalDay,
                required String currency,
                required int salaryMinor,
                required int allowancesMinor,
                Value<int?> receiptId = const Value.absent(),
                Value<int> revision = const Value.absent(),
              }) => DashainPlansCompanion.insert(
                year: year,
                festivalDay: festivalDay,
                currency: currency,
                salaryMinor: salaryMinor,
                allowancesMinor: allowancesMinor,
                receiptId: receiptId,
                revision: revision,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DashainPlansTable, DashainPlan>(table),
                  $$DashainPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({currency = false, receiptId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (currency) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.currency,
                        referencedTable: $$DashainPlansTableReferences
                            ._currencyTable(db),
                        referencedColumn: $$DashainPlansTableReferences
                            ._currencyTable(db)
                            .code,
                      ) as T;
                    }
                    if (receiptId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.receiptId,
                        referencedTable: $$DashainPlansTableReferences
                            ._receiptIdTable(db),
                        referencedColumn: $$DashainPlansTableReferences
                            ._receiptIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DashainPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $DashainPlansTable,
      DashainPlan,
      $$DashainPlansTableFilterComposer,
      $$DashainPlansTableOrderingComposer,
      $$DashainPlansTableAnnotationComposer,
      $$DashainPlansTableCreateCompanionBuilder,
      $$DashainPlansTableUpdateCompanionBuilder,
      (DashainPlan, $$DashainPlansTableReferences),
      DashainPlan,
      PrefetchHooks Function({bool currency, bool receiptId})
    >;
typedef $$AnnualTicketsTableCreateCompanionBuilder =
    AnnualTicketsCompanion Function({
      Value<int> year,
      required int policyVersion,
      Value<int?> receivedDay,
      Value<int?> usedDay,
      Value<int?> leaveId,
    });
typedef $$AnnualTicketsTableUpdateCompanionBuilder =
    AnnualTicketsCompanion Function({
      Value<int> year,
      Value<int> policyVersion,
      Value<int?> receivedDay,
      Value<int?> usedDay,
      Value<int?> leaveId,
    });

final class $$AnnualTicketsTableReferences
    extends
        BaseReferences<_$LedgerDatabase, $AnnualTicketsTable, AnnualTicket> {
  $$AnnualTicketsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LeaveEntriesTable _leaveIdTable(_$LedgerDatabase db) => db
      .leaveEntries
      .createAlias('annual_tickets__leave_id__leave_entries__id');

  $$LeaveEntriesTableProcessedTableManager? get leaveId {
    final $_column = $_itemColumn<int>('leave_id');
    if ($_column == null) return null;
    final manager = $$LeaveEntriesTableTableManager(
      $_db,
      $_db.leaveEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_leaveIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnnualTicketsTableFilterComposer
    extends Composer<_$LedgerDatabase, $AnnualTicketsTable> {
  $$AnnualTicketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get policyVersion => $composableBuilder(
    column: $table.policyVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receivedDay => $composableBuilder(
    column: $table.receivedDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usedDay => $composableBuilder(
    column: $table.usedDay,
    builder: (column) => ColumnFilters(column),
  );

  $$LeaveEntriesTableFilterComposer get leaveId {
    final $$LeaveEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaveId,
      referencedTable: $db.leaveEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaveEntriesTableFilterComposer(
            $db: $db,
            $table: $db.leaveEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnualTicketsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $AnnualTicketsTable> {
  $$AnnualTicketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get policyVersion => $composableBuilder(
    column: $table.policyVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receivedDay => $composableBuilder(
    column: $table.receivedDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usedDay => $composableBuilder(
    column: $table.usedDay,
    builder: (column) => ColumnOrderings(column),
  );

  $$LeaveEntriesTableOrderingComposer get leaveId {
    final $$LeaveEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaveId,
      referencedTable: $db.leaveEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaveEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.leaveEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnualTicketsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $AnnualTicketsTable> {
  $$AnnualTicketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get policyVersion => $composableBuilder(
    column: $table.policyVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receivedDay => $composableBuilder(
    column: $table.receivedDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usedDay =>
      $composableBuilder(column: $table.usedDay, builder: (column) => column);

  $$LeaveEntriesTableAnnotationComposer get leaveId {
    final $$LeaveEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leaveId,
      referencedTable: $db.leaveEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaveEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.leaveEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnualTicketsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $AnnualTicketsTable,
          AnnualTicket,
          $$AnnualTicketsTableFilterComposer,
          $$AnnualTicketsTableOrderingComposer,
          $$AnnualTicketsTableAnnotationComposer,
          $$AnnualTicketsTableCreateCompanionBuilder,
          $$AnnualTicketsTableUpdateCompanionBuilder,
          (AnnualTicket, $$AnnualTicketsTableReferences),
          AnnualTicket,
          PrefetchHooks Function({bool leaveId})
        > {
  $$AnnualTicketsTableTableManager(
    _$LedgerDatabase db,
    $AnnualTicketsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnnualTicketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnnualTicketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnnualTicketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> year = const Value.absent(),
                Value<int> policyVersion = const Value.absent(),
                Value<int?> receivedDay = const Value.absent(),
                Value<int?> usedDay = const Value.absent(),
                Value<int?> leaveId = const Value.absent(),
              }) => AnnualTicketsCompanion(
                year: year,
                policyVersion: policyVersion,
                receivedDay: receivedDay,
                usedDay: usedDay,
                leaveId: leaveId,
              ),
          createCompanionCallback:
              ({
                Value<int> year = const Value.absent(),
                required int policyVersion,
                Value<int?> receivedDay = const Value.absent(),
                Value<int?> usedDay = const Value.absent(),
                Value<int?> leaveId = const Value.absent(),
              }) => AnnualTicketsCompanion.insert(
                year: year,
                policyVersion: policyVersion,
                receivedDay: receivedDay,
                usedDay: usedDay,
                leaveId: leaveId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnnualTicketsTable, AnnualTicket>(table),
                  $$AnnualTicketsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({leaveId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (leaveId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.leaveId,
                        referencedTable: $$AnnualTicketsTableReferences
                            ._leaveIdTable(db),
                        referencedColumn: $$AnnualTicketsTableReferences
                            ._leaveIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnnualTicketsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $AnnualTicketsTable,
      AnnualTicket,
      $$AnnualTicketsTableFilterComposer,
      $$AnnualTicketsTableOrderingComposer,
      $$AnnualTicketsTableAnnotationComposer,
      $$AnnualTicketsTableCreateCompanionBuilder,
      $$AnnualTicketsTableUpdateCompanionBuilder,
      (AnnualTicket, $$AnnualTicketsTableReferences),
      AnnualTicket,
      PrefetchHooks Function({bool leaveId})
    >;
typedef $$TravelGoalsTableCreateCompanionBuilder =
    TravelGoalsCompanion Function({
      Value<int> id,
      required String currency,
      required int targetDay,
      required int tripMinor,
      required int airfareMinor,
    });
typedef $$TravelGoalsTableUpdateCompanionBuilder =
    TravelGoalsCompanion Function({
      Value<int> id,
      Value<String> currency,
      Value<int> targetDay,
      Value<int> tripMinor,
      Value<int> airfareMinor,
    });

final class $$TravelGoalsTableReferences
    extends BaseReferences<_$LedgerDatabase, $TravelGoalsTable, TravelGoal> {
  $$TravelGoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CurrenciesTable _currencyTable(_$LedgerDatabase db) =>
      db.currencies.createAlias('travel_goals__currency__currencies__code');

  $$CurrenciesTableProcessedTableManager get currency {
    final $_column = $_itemColumn<String>('currency')!;

    final manager = $$CurrenciesTableTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TravelContributionsTable,
    List<TravelContribution>
  >
  _travelContributionsRefsTable(_$LedgerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.travelContributions,
        aliasName: 'travel_goals__id__travel_contributions__goal_id',
      );

  $$TravelContributionsTableProcessedTableManager get travelContributionsRefs {
    final manager = $$TravelContributionsTableTableManager(
      $_db,
      $_db.travelContributions,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _travelContributionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TravelGoalsTableFilterComposer
    extends Composer<_$LedgerDatabase, $TravelGoalsTable> {
  $$TravelGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDay => $composableBuilder(
    column: $table.targetDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tripMinor => $composableBuilder(
    column: $table.tripMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get airfareMinor => $composableBuilder(
    column: $table.airfareMinor,
    builder: (column) => ColumnFilters(column),
  );

  $$CurrenciesTableFilterComposer get currency {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> travelContributionsRefs(
    Expression<bool> Function($$TravelContributionsTableFilterComposer f) f,
  ) {
    final $$TravelContributionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.travelContributions,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TravelContributionsTableFilterComposer(
            $db: $db,
            $table: $db.travelContributions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TravelGoalsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $TravelGoalsTable> {
  $$TravelGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDay => $composableBuilder(
    column: $table.targetDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tripMinor => $composableBuilder(
    column: $table.tripMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get airfareMinor => $composableBuilder(
    column: $table.airfareMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $$CurrenciesTableOrderingComposer get currency {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TravelGoalsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $TravelGoalsTable> {
  $$TravelGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get targetDay =>
      $composableBuilder(column: $table.targetDay, builder: (column) => column);

  GeneratedColumn<int> get tripMinor =>
      $composableBuilder(column: $table.tripMinor, builder: (column) => column);

  GeneratedColumn<int> get airfareMinor => $composableBuilder(
    column: $table.airfareMinor,
    builder: (column) => column,
  );

  $$CurrenciesTableAnnotationComposer get currency {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> travelContributionsRefs<T extends Object>(
    Expression<T> Function($$TravelContributionsTableAnnotationComposer a) f,
  ) {
    final $$TravelContributionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.travelContributions,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TravelContributionsTableAnnotationComposer(
                $db: $db,
                $table: $db.travelContributions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TravelGoalsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $TravelGoalsTable,
          TravelGoal,
          $$TravelGoalsTableFilterComposer,
          $$TravelGoalsTableOrderingComposer,
          $$TravelGoalsTableAnnotationComposer,
          $$TravelGoalsTableCreateCompanionBuilder,
          $$TravelGoalsTableUpdateCompanionBuilder,
          (TravelGoal, $$TravelGoalsTableReferences),
          TravelGoal,
          PrefetchHooks Function({bool currency, bool travelContributionsRefs})
        > {
  $$TravelGoalsTableTableManager(_$LedgerDatabase db, $TravelGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TravelGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TravelGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TravelGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> targetDay = const Value.absent(),
                Value<int> tripMinor = const Value.absent(),
                Value<int> airfareMinor = const Value.absent(),
              }) => TravelGoalsCompanion(
                id: id,
                currency: currency,
                targetDay: targetDay,
                tripMinor: tripMinor,
                airfareMinor: airfareMinor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String currency,
                required int targetDay,
                required int tripMinor,
                required int airfareMinor,
              }) => TravelGoalsCompanion.insert(
                id: id,
                currency: currency,
                targetDay: targetDay,
                tripMinor: tripMinor,
                airfareMinor: airfareMinor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TravelGoalsTable, TravelGoal>(table),
                  $$TravelGoalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({currency = false, travelContributionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (travelContributionsRefs) db.travelContributions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (currency) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.currency,
                            referencedTable: $$TravelGoalsTableReferences
                                ._currencyTable(db),
                            referencedColumn: $$TravelGoalsTableReferences
                                ._currencyTable(db)
                                .code,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (travelContributionsRefs)
                        await $_getPrefetchedDataByColumns<
                          TravelGoal,
                          $TravelGoalsTable,
                          TravelContribution,
                          $TravelContributionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TravelGoalsTableReferences
                              ._travelContributionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TravelGoalsTableReferences(
                                db,
                                table,
                                p0,
                              ).travelContributionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'goal_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TravelGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $TravelGoalsTable,
      TravelGoal,
      $$TravelGoalsTableFilterComposer,
      $$TravelGoalsTableOrderingComposer,
      $$TravelGoalsTableAnnotationComposer,
      $$TravelGoalsTableCreateCompanionBuilder,
      $$TravelGoalsTableUpdateCompanionBuilder,
      (TravelGoal, $$TravelGoalsTableReferences),
      TravelGoal,
      PrefetchHooks Function({bool currency, bool travelContributionsRefs})
    >;
typedef $$TravelContributionsTableCreateCompanionBuilder =
    TravelContributionsCompanion Function({
      required String operationId,
      required int goalId,
      required int accountId,
      required int day,
      required int minor,
      Value<int> rowid,
    });
typedef $$TravelContributionsTableUpdateCompanionBuilder =
    TravelContributionsCompanion Function({
      Value<String> operationId,
      Value<int> goalId,
      Value<int> accountId,
      Value<int> day,
      Value<int> minor,
      Value<int> rowid,
    });

final class $$TravelContributionsTableReferences
    extends
        BaseReferences<
          _$LedgerDatabase,
          $TravelContributionsTable,
          TravelContribution
        > {
  $$TravelContributionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TravelGoalsTable _goalIdTable(_$LedgerDatabase db) => db.travelGoals
      .createAlias('travel_contributions__goal_id__travel_goals__id');

  $$TravelGoalsTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<int>('goal_id')!;

    final manager = $$TravelGoalsTableTableManager(
      $_db,
      $_db.travelGoals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LedgerAccountsTable _accountIdTable(_$LedgerDatabase db) => db
      .ledgerAccounts
      .createAlias('travel_contributions__account_id__ledger_accounts__id');

  $$LedgerAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$LedgerAccountsTableTableManager(
      $_db,
      $_db.ledgerAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TravelContributionsTableFilterComposer
    extends Composer<_$LedgerDatabase, $TravelContributionsTable> {
  $$TravelContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minor => $composableBuilder(
    column: $table.minor,
    builder: (column) => ColumnFilters(column),
  );

  $$TravelGoalsTableFilterComposer get goalId {
    final $$TravelGoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.travelGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TravelGoalsTableFilterComposer(
            $db: $db,
            $table: $db.travelGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableFilterComposer get accountId {
    final $$LedgerAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableFilterComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TravelContributionsTableOrderingComposer
    extends Composer<_$LedgerDatabase, $TravelContributionsTable> {
  $$TravelContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minor => $composableBuilder(
    column: $table.minor,
    builder: (column) => ColumnOrderings(column),
  );

  $$TravelGoalsTableOrderingComposer get goalId {
    final $$TravelGoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.travelGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TravelGoalsTableOrderingComposer(
            $db: $db,
            $table: $db.travelGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableOrderingComposer get accountId {
    final $$LedgerAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TravelContributionsTableAnnotationComposer
    extends Composer<_$LedgerDatabase, $TravelContributionsTable> {
  $$TravelContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get minor =>
      $composableBuilder(column: $table.minor, builder: (column) => column);

  $$TravelGoalsTableAnnotationComposer get goalId {
    final $$TravelGoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.travelGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TravelGoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.travelGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LedgerAccountsTableAnnotationComposer get accountId {
    final $$LedgerAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.ledgerAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TravelContributionsTableTableManager
    extends
        RootTableManager<
          _$LedgerDatabase,
          $TravelContributionsTable,
          TravelContribution,
          $$TravelContributionsTableFilterComposer,
          $$TravelContributionsTableOrderingComposer,
          $$TravelContributionsTableAnnotationComposer,
          $$TravelContributionsTableCreateCompanionBuilder,
          $$TravelContributionsTableUpdateCompanionBuilder,
          (TravelContribution, $$TravelContributionsTableReferences),
          TravelContribution,
          PrefetchHooks Function({bool goalId, bool accountId})
        > {
  $$TravelContributionsTableTableManager(
    _$LedgerDatabase db,
    $TravelContributionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TravelContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TravelContributionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TravelContributionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<int> goalId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<int> minor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TravelContributionsCompanion(
                operationId: operationId,
                goalId: goalId,
                accountId: accountId,
                day: day,
                minor: minor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                required int goalId,
                required int accountId,
                required int day,
                required int minor,
                Value<int> rowid = const Value.absent(),
              }) => TravelContributionsCompanion.insert(
                operationId: operationId,
                goalId: goalId,
                accountId: accountId,
                day: day,
                minor: minor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TravelContributionsTable, TravelContribution>(
                    table,
                  ),
                  $$TravelContributionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false, accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.goalId,
                        referencedTable: $$TravelContributionsTableReferences
                            ._goalIdTable(db),
                        referencedColumn: $$TravelContributionsTableReferences
                            ._goalIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $$TravelContributionsTableReferences
                            ._accountIdTable(db),
                        referencedColumn: $$TravelContributionsTableReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TravelContributionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LedgerDatabase,
      $TravelContributionsTable,
      TravelContribution,
      $$TravelContributionsTableFilterComposer,
      $$TravelContributionsTableOrderingComposer,
      $$TravelContributionsTableAnnotationComposer,
      $$TravelContributionsTableCreateCompanionBuilder,
      $$TravelContributionsTableUpdateCompanionBuilder,
      (TravelContribution, $$TravelContributionsTableReferences),
      TravelContribution,
      PrefetchHooks Function({bool goalId, bool accountId})
    >;

class $LedgerDatabaseManager {
  final _$LedgerDatabase _db;
  $LedgerDatabaseManager(this._db);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db, _db.currencies);
  $$LedgerAccountsTableTableManager get ledgerAccounts =>
      $$LedgerAccountsTableTableManager(_db, _db.ledgerAccounts);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$JournalPostingsTableTableManager get journalPostings =>
      $$JournalPostingsTableTableManager(_db, _db.journalPostings);
  $$SalaryReceiptsTableTableManager get salaryReceipts =>
      $$SalaryReceiptsTableTableManager(_db, _db.salaryReceipts);
  $$SalaryPlansTableTableManager get salaryPlans =>
      $$SalaryPlansTableTableManager(_db, _db.salaryPlans);
  $$SalaryAllocationsTableTableManager get salaryAllocations =>
      $$SalaryAllocationsTableTableManager(_db, _db.salaryAllocations);
  $$SalaryExecutionsTableTableManager get salaryExecutions =>
      $$SalaryExecutionsTableTableManager(_db, _db.salaryExecutions);
  $$MovementConfirmationsTableTableManager get movementConfirmations =>
      $$MovementConfirmationsTableTableManager(_db, _db.movementConfirmations);
  $$CashSettingsTableTableManager get cashSettings =>
      $$CashSettingsTableTableManager(_db, _db.cashSettings);
  $$CashReconciliationsTableTableManager get cashReconciliations =>
      $$CashReconciliationsTableTableManager(_db, _db.cashReconciliations);
  $$ExpenseDetailsTableTableManager get expenseDetails =>
      $$ExpenseDetailsTableTableManager(_db, _db.expenseDetails);
  $$RemittancesTableTableManager get remittances =>
      $$RemittancesTableTableManager(_db, _db.remittances);
  $$RemittanceEventsTableTableManager get remittanceEvents =>
      $$RemittanceEventsTableTableManager(_db, _db.remittanceEvents);
  $$RemittancePurposesTableTableManager get remittancePurposes =>
      $$RemittancePurposesTableTableManager(_db, _db.remittancePurposes);
  $$RemittanceFamilyPaymentsTableTableManager get remittanceFamilyPayments =>
      $$RemittanceFamilyPaymentsTableTableManager(
        _db,
        _db.remittanceFamilyPayments,
      );
  $$LeaveRulesTableTableManager get leaveRules =>
      $$LeaveRulesTableTableManager(_db, _db.leaveRules);
  $$LeaveEntriesTableTableManager get leaveEntries =>
      $$LeaveEntriesTableTableManager(_db, _db.leaveEntries);
  $$LeaveHolidaysTableTableManager get leaveHolidays =>
      $$LeaveHolidaysTableTableManager(_db, _db.leaveHolidays);
  $$DashainPlansTableTableManager get dashainPlans =>
      $$DashainPlansTableTableManager(_db, _db.dashainPlans);
  $$AnnualTicketsTableTableManager get annualTickets =>
      $$AnnualTicketsTableTableManager(_db, _db.annualTickets);
  $$TravelGoalsTableTableManager get travelGoals =>
      $$TravelGoalsTableTableManager(_db, _db.travelGoals);
  $$TravelContributionsTableTableManager get travelContributions =>
      $$TravelContributionsTableTableManager(_db, _db.travelContributions);
}
