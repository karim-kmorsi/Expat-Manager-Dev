# Acceptance scenarios — proposal for v0.1

All values are fictional fixtures.

1. Salary USD 2,000: allocate USD 500 family, USD 400 Egypt savings, USD 300 cash withdrawal, USD 600 Nepal living budget; USD 200 remains. Allocation alone never reduces bank balance.
2. Execute USD 300 cash withdrawal: bank -300, cash +300, no expense. If total withdrawals for month reach USD 550, warn on user-reported USD 500 ceiling.
3. Remit to own Egypt bank at observed FX: change accounts only; no spending. Unknown fees/rates are not invented.
4. One Egypt bank transfer has several purpose allocations, without multiple source withdrawals. Prevent unexplained surplus allocations.
5. Direct family remittance counts as support expense, unlike own-account remittance.
6. NPR cash and bank/card expenses post once to the correct account, including daily aggregation.
7. Earmark cash for travel without duplicating money; changing target/date recalculates the suggestion.
8. Thirty annual days Jan–Dec with zero carryover; Fri/Sat in approved range count; unknown public-holiday edge cases remain configurable/unresolved.
9. Casual 13 and sick 15 recorded; sick leave report-status recorded without requiring personal medical files.
10. Gold item can lack cost and have holder separate from owner; Thndr manual valuation does not create bank cash.
11. Offline entry persists across app restart; encrypted backup imports to clean installation with matching totals.
12. No real financial data, beneficiary details or keys in repository or test samples; verify no unintended financial-data network traffic.