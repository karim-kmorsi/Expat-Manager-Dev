import 'model.dart';

const transferCurrencies = ['USD', 'EGP', 'NPR'];

enum AllocationCategory { family, living, obligations, savings, cash, personal }

typedef TransferNeed = ({
  AllocationCategory category,
  String label,
  String currency,
  int minor,
});

typedef TransferTerms = ({
  String rate,
  int marginBps,
  int feeBps,
  int fixedFee,
});

typedef TransferRoute = ({int received, int principal, int fee, int debit});

/// A decimal quote in destination major units per source major unit.
BigInt? exchangeRateUnits(String rate) {
  if (!RegExp(r'^[0-9]{1,12}(\.[0-9]{1,8})?$').hasMatch(rate)) return null;
  final parts = rate.split('.');
  final fraction = parts.length == 2 ? parts.last : '';
  final value = BigInt.parse(parts.first + fraction.padRight(8, '0'));
  return value > BigInt.zero ? value : null;
}

class TransferCalculator {
  TransferCalculator({
    required this.sourceScale,
    required this.destinationScale,
    required TransferTerms terms,
  }) : _terms = terms {
    if (terms.marginBps < 0 ||
        terms.marginBps >= 10000 ||
        terms.feeBps < 0 ||
        terms.feeBps >= 10000 ||
        terms.fixedFee < 0) {
      throw const LedgerException(LedgerIssue.invalidInput);
    }
    final rate = exchangeRateUnits(terms.rate);
    if (rate == null) throw const LedgerException(LedgerIssue.invalidInput);
    _destination =
        rate *
        BigInt.from(10000 - terms.marginBps) *
        BigInt.from(10).pow(destinationScale);
    _source = BigInt.from(1000000000000) * BigInt.from(10).pow(sourceScale);
  }

  final int sourceScale;
  final int destinationScale;
  final TransferTerms _terms;
  late final BigInt _destination;
  late final BigInt _source;

  /// Converts the source principal before fees, rounding down to minor units.
  int receivedForPrincipal(int principal) {
    if (principal < 0) throw const LedgerException(LedgerIssue.invalidInput);
    return checkedMinor(BigInt.from(principal) * _destination ~/ _source);
  }

  /// Finds the smallest debit covering the target and its rounded-up fees.
  /// The percentage applies to the full debit, including the fee itself.
  TransferRoute forTarget(int received) {
    if (received <= 0) throw const LedgerException(LedgerIssue.invalidInput);
    final principal = _ceil(BigInt.from(received) * _source, _destination);
    final debit = _ceil(
      (principal + BigInt.from(_terms.fixedFee)) * BigInt.from(10000),
      BigInt.from(10000 - _terms.feeBps),
    );
    return (
      received: received,
      principal: checkedMinor(principal),
      fee: checkedMinor(debit - principal),
      debit: checkedMinor(debit),
    );
  }
}

BigInt _ceil(BigInt numerator, BigInt denominator) =>
    (numerator + denominator - BigInt.one) ~/ denominator;

class TransferPlan {
  TransferPlan({
    required List<TransferNeed> needs,
    required Map<String, TransferTerms> terms,
  }) : needs = List.unmodifiable(needs),
       terms = Map.unmodifiable(terms);

  final List<TransferNeed> needs;
  final Map<String, TransferTerms> terms;

  ({Map<String, TransferRoute> routes, int principal, int fee, int debit})
  calculate(Map<String, int> scales) {
    if (needs.isEmpty) throw const LedgerException(LedgerIssue.invalidInput);
    final totals = <String, BigInt>{};
    for (final need in needs) {
      if (!transferCurrencies.contains(need.currency) ||
          need.minor <= 0 ||
          need.label.length > 100) {
        throw const LedgerException(LedgerIssue.invalidInput);
      }
      totals.update(
        need.currency,
        (sum) => sum + BigInt.from(need.minor),
        ifAbsent: () => BigInt.from(need.minor),
      );
    }
    final routes = <String, TransferRoute>{};
    var principal = BigInt.zero;
    var fee = BigInt.zero;
    for (final entry in totals.entries) {
      final amount = checkedMinor(entry.value);
      final TransferRoute route;
      if (entry.key == usdCurrency) {
        route = (received: amount, principal: amount, fee: 0, debit: amount);
      } else {
        final quote = terms[entry.key];
        if (quote == null) {
          throw const LedgerException(LedgerIssue.invalidInput);
        }
        route = TransferCalculator(
          sourceScale: scales[usdCurrency]!,
          destinationScale: scales[entry.key]!,
          terms: quote,
        ).forTarget(amount);
      }
      routes[entry.key] = route;
      principal += BigInt.from(route.principal);
      fee += BigInt.from(route.fee);
    }
    return (
      routes: routes,
      principal: checkedMinor(principal),
      fee: checkedMinor(fee),
      debit: checkedMinor(principal + fee),
    );
  }

  Map<String, Object?> toJson() => {
    'needs': [
      for (final need in needs)
        {
          'category': need.category.name,
          'label': need.label,
          'currency': need.currency,
          'minor': need.minor,
        },
    ],
    'terms': {
      for (final entry in terms.entries)
        entry.key: {
          'rate': entry.value.rate,
          'margin': entry.value.marginBps,
          'fee': entry.value.feeBps,
          'fixed': entry.value.fixedFee,
        },
    },
  };

  factory TransferPlan.fromJson(Map<String, dynamic> json) => TransferPlan(
    needs: [
      for (final need in json['needs'] as List)
        (
          category: AllocationCategory.values.byName(
            need['category'] as String,
          ),
          label: need['label'] as String,
          currency: need['currency'] as String,
          minor: need['minor'] as int,
        ),
    ],
    terms: {
      for (final MapEntry(:key, :value)
          in (json['terms'] as Map<String, dynamic>).entries)
        key: (
          rate: value['rate'] as String,
          marginBps: value['margin'] as int,
          feeBps: value['fee'] as int,
          fixedFee: value['fixed'] as int,
        ),
    },
  );
}
