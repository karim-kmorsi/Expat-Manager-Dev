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

abstract class _$LedgerDatabase extends GeneratedDatabase {
  _$LedgerDatabase(QueryExecutor e) : super(e);
  $LedgerDatabaseManager get managers => $LedgerDatabaseManager(this);
  late final $CurrenciesTable currencies = $CurrenciesTable(this);
  late final $LedgerAccountsTable ledgerAccounts = $LedgerAccountsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $JournalPostingsTable journalPostings = $JournalPostingsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    currencies,
    ledgerAccounts,
    journalEntries,
    journalPostings,
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
          PrefetchHooks Function({bool ledgerAccountsRefs})
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
          prefetchHooksCallback: ({ledgerAccountsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ledgerAccountsRefs) db.ledgerAccounts,
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
      PrefetchHooks Function({bool ledgerAccountsRefs})
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
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (journalEntriesRefs) db.journalEntries,
                    if (journalPostingsRefs) db.journalPostings,
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
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (journalPostingsRefs) db.journalPostings,
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
}
