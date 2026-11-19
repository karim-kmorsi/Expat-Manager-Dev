enum AccountKind {
  bank,
  cash,
  savings,
  opening,
  income,
  expense;

  bool get isPersonal => switch (this) {
    bank || cash || savings => true,
    opening || income || expense => false,
  };
}

enum JournalKind { opening, entry, internalTransfer, reversal }

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
