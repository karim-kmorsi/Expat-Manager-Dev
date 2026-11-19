# Architecture proposal — not an implementation decision

Android-first, offline-first independent app. Candidate Flutter UI with SQLite/Drift persistent data; desktop later if justified.

## Modules
- Work/Leave: entitlements, leave periods, holidays, employer-funded flight.
- Money: bank/cash accounts, salary receipts, plans, allocations, remittances and purposes, expenses, FX and reconciliation.
- Home: holiday saving goal, physical gold items and custodian, manual Thndr snapshots.
- Core: settings, backups, validation, local data protection.

## Conceptual records
Account, PaymentMethod, SalaryReceipt, SalaryPlan, Allocation, Transfer, TransferPurpose, Transaction, FXConversion, ExpenseCategory, SavingsGoal, LeavePolicy, LeaveEntry, Holiday, FlightEntitlement, GoldItem, GoldCustodyEvent, PortfolioSnapshot, BackupManifest.

## Invariants
- A plan or earmark does not reduce a real account balance until a transaction occurs.
- Own-account transfer and bank-to-cash withdrawal change asset locations, not spending (except actual costs).
- Grouped remittance = one actual outgoing transfer, multiple purpose allocations that reconcile to known received amount or remain explicitly pending.
- Use observed exchange rates; no fabricated fees, prices or balances.
- USD cash withdrawal monthly ceiling is configurable and based on executed transactions.
- Thndr valuation changes are not spendable cash; custody does not imply gold ownership.
- Approved, requested and used leave are separate concepts.

Before coding: verify actual Flutter/Android toolchain and licenses; select secure migrations, encryption/restore model and run device feasibility checks. Prefer maintained libraries; review GPL obligations before copying external code.