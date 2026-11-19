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
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (journalEntriesRefs) db.journalEntries,
                    if (journalPostingsRefs) db.journalPostings,
                    if (salaryReceiptsRefs) db.salaryReceipts,
                    if (cashSettingsRefs) db.cashSettings,
                    if (cashReconciliationsRefs) db.cashReconciliations,
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
}
