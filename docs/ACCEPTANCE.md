# v0.1 acceptance scenarios

All values are fictional fixtures. Scenarios below describe product acceptance. The isolated probe has its own [record of executed checks](TOOLCHAIN.md).

1. Salary USD 2,000: allocate USD 500 family, USD 400 Egypt savings, USD 300 cash withdrawal, USD 600 Nepal living budget; USD 200 remains. Allocation alone never reduces bank balance.
2. Execute USD 300 cash withdrawal: bank -300, cash +300, no expense. If total withdrawals for month reach USD 550, warn on user-reported USD 500 ceiling.
3. Remit to own Egypt bank at observed FX: change accounts only; no spending. Unknown fees/rates are not invented.
4. One Egypt bank transfer has several purpose allocations, without multiple source withdrawals. Prevent unexplained surplus allocations.
5. Direct family remittance counts as support expense, unlike own-account remittance.
6. NPR cash and bank/card expenses post once to the correct account, including daily aggregation.
7. Earmark cash for travel without duplicating money; changing target/date recalculates the suggestion.
8. Verify the current annual leave setting of 30 paid calendar days per January–December year with no carryover. Verify that Fridays and Saturdays inside an approved annual leave period count against the balance. Verify offline planning for a specific date, a future period and an occasion using the balance, holiday calendar and Friday/Saturday weekly rest days. Where a result depends on an unresolved rule, show it as provisional.
9. Verify 13 casual days per year, 15 sick days per year and one employer-funded round trip per year for the employee under the current settings. Verify that sick leave records capture the presence or status of a medical report without storing sensitive medical documents. Verify that requested, approved and used leave remain distinct. Verify that users can edit leave rules and travel entitlement settings, and that edits to leave rules retain previous versions and their effective dates.
10. Gold item can lack cost and have holder separate from owner; Thndr manual valuation does not create bank cash.
11. Offline entry persists across app restart (M1 and M2). In M3, an encrypted backup imports to a clean installation with matching totals, including all supported source schema versions.
12. No real financial data, beneficiary details or keys in repository or test samples; verify no unintended financial-data network traffic.
## Financial failure and recovery scenarios

- Record a bank debit, restart before destination evidence is available and reopen a single pending transfer. Completing it with actual receipt records the destination once and prevents purpose allocations beyond the net receipt. Retry after interruption and check the balances and per-currency posting sums.
- Cancel before debit and observe zero ledger movement. For cancellation after debit, record only the actual linked return at its observed date and keep the unexplained residual open. Unknown fees or FX rates stay unset.
- Retry the same save and confirmation. Each movement and confirmation is represented once. A legitimate repeated expense can be recorded after a similarity warning.
- Reconcile an account with and without a known opening balance. Preserve the variance until resolved. Correct a matched entry by linked reversal/replacement, retain the historical statement evidence and re-match affected entries after preview. Apply the previously reconciled period rule once the owner confirms it under T-003.
- The Arabic salary flow covers draft, partial execution, pending settlement, confirmation, duplicates and correction. Verify RTL with signed money, currency codes, dates and statement references in the same row.

## Full recovery and device scenarios — M3

- Restore to a clean physical Android installation with a distinct local key and match records and balances. Cover wrong password, malformed or newer format, truncation, invalid references, insufficient storage and interruption on both sides of commit.
- Verify successful migration from each supported schema, retained old data on failed migration, integrity and per-currency balance invariants. Cover local key loss or invalidation and the password-backup recovery path.
- On a physical arm64 device, record OS, ABI, page size, APK checksum and test output. Verify offline, native library loading, Keystore and data recovery. Physical 16 KB compatibility needs a device reporting that page size. Record coverage gaps as untested.
