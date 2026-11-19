enum AccountKind {
  bank,
  cash,
  savings,
  opening,
  income,
  expense,
  cashAdjustment;

  bool get isPersonal => switch (this) {
    bank || cash || savings => true,
    opening || income || expense || cashAdjustment => false,
  };
}

enum JournalKind {
  opening,
  entry,
  internalTransfer,
  reversal,
  salary,
  cashIncome,
  cashExpense,
  expense,
  cashAdjustment,
}

enum ExpensePeriod { individual, day, week }

enum ExpenseCategory { food, transport, housing, bills, health, other }

const usdCurrency = 'USD';

enum CashIssue {
  walletRequired,
  walletAlreadySelected,
  duplicateCashAccount,
  invalidAmount,
  insufficientCash,
  staleBalance,
  openingAfterSettlement,
  uncorrectableMovement,
}

class CashException implements Exception {
  const CashException(this.issue);

  final CashIssue issue;
}

enum LedgerIssue {
  invalidInput,
  accountNotFound,
  unbalanced,
  currencyMismatch,
  duplicateConflict,
  openingAlreadyRecorded,
  overflow,
  entryNotFound,
  reversalNotAllowed,
  alreadyReversed,
}

class LedgerException implements Exception {
  const LedgerException(this.issue);
  final LedgerIssue issue;

  @override
  String toString() => 'LedgerException: ${issue.name}';
}

typedef Posting = ({int accountId, int minor});
typedef Balance = ({int minor, bool openingKnown});

const maxMinor = 9223372036854775807;
const minMinor = -maxMinor;

int checkedMinor(BigInt value) {
  if (value < BigInt.from(minMinor) || value > BigInt.from(maxMinor)) {
    throw const LedgerException(LedgerIssue.overflow);
  }
  return value.toInt();
}
