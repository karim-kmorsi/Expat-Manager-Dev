# v0.1 architecture

Use one Android-first Flutter app with Arabic-first RTL screens, Dart use cases and one encrypted Drift database. Keep ledger and leave rules in the domain layer. Isolate Android Keystore and the file picker behind small platform adapters. See the [tested toolchain](TOOLCHAIN.md) and [storage and restore design](SECURITY.md).

## Modules and records

| Module | Data and responsibilities |
|---|---|
| Money | Currency, account, payment method, journal entry and posting, salary plan and allocation, execution link, transfer, purpose, observed FX, expense category, reconciliation session and match |
| Work and Leave | Effective-dated leave policy, dated leave entry, holiday calendar and flight entitlement. Requested, approved and used leave remain distinct. Provisional rules stay configurable and visibly provisional |
| Savings and assets | Travel goal and earmarks, gold item and custody history, Thndr valuation snapshots and cash flows. Link actual cash movements to their ledger entries |
| Core | Database migrations, local encryption, backup, restore, settings and validation |

## Financial model

- A user account has one currency and a type such as bank, cash or a separate real savings account. A card is a payment method for its account. Use integer minor units with fixed precision per currency once used. Report totals per currency. Any converted display value requires a known, dated rate.
- A journal entry is posted atomically with its signed postings, with a zero sum for each currency. Internal offset accounts cover opening balances, income, expenses, settlement in transit and currency exchange. Derive book balances from posted account entries. Without an optional opening entry, show net recorded movement and identify the actual balance as unknown.
- Record a salary deposit once. A plan or earmark affects its allocation and unallocated budget. Only actual execution affects book balances. Allow partial execution through links to actual entries whose allocated values do not exceed the amounts executed. Confirmation records the evidence or match on the existing entry.
- A transfer between the user's accounts, including a bank-to-cash withdrawal, moves money. A known actual fee can be an expense whether charged separately or included in the debit. Count it once. Use actual debits and credits. Keep unknown rates, fees and margins unknown. If both sides are known, a derived effective rate can be labelled with its gross/net basis.
- A grouped remittance has one source debit. When the source is debited before receipt is known, post it against the clearing account and mark settlement pending. Post the actual destination credit and settle clearing when the evidence becomes available. Keep unexplained differences pending and visible. Actual purpose allocations are limited to known net receipts, with the remainder shown as unallocated. A family purpose is a plan until an actual family payment occurs. A direct payment to a beneficiary is itself the supporting expense. If the money goes first to the user's account, record the later family payout separately and link it to the purpose.
- An instruction cancelled before debit changes status only. After debit, retain the original entry and pending settlement. Record an actual return as a linked entry on the date received. Keep any unexplained residual unresolved. A correction reverses the affected posting and can add a linked replacement, with the reason and history retained. Reopen or supersede the affected reconciliation match, preserve the earlier evidence and preview the impact. The effective date for a correction in a previously reconciled period remains subject to T-003. The confirmed date of an actual refund is independent of that policy.
- Manual reconciliation records the statement date, balance and matches per account and currency. Show the variance and unresolved items. Any financial adjustment requires a separate reasoned entry. A stable idempotency key prevents duplicate posting on retry. An account-scoped statement reference can be unique when reliable. Similarity in date or amount prompts review because legitimate repeat movements are possible.
- Count the principal of executed USD cash withdrawals once against the configurable monthly warning threshold. Earmarking creates no movement. A Thndr valuation change creates no cash. Gold owner and custodian may be different people.

## T-009 manual remittance recording

- Select the Nepal source and Egypt destination manually. Attach a unique reference to the observed debit, each receipt and each refund. A foreign receipt can be posted immediately against the exchange offset while its unproven source share remains in transit. Later source evidence settles that share through a separate posting without duplicating the receipt. Unexplained differences remain open.
- Refunds apply only to observed returns to the source account in its own currency, up to the outstanding principal. A refund does not rewrite historical salary execution links. New salary links are unavailable once a refund exists. Corrections retain the original entry and are limited to the latest eligible movement before dependent family, salary or reconciliation records constrain it.
- Real account routes, acceptable real-world evidence and correction dates for previously reconciled balances remain open under T-003. No foreign-currency refund, inferred charge, or automatic reallocation of refunded salary is applied.

## Persistence

Use foreign keys and uniqueness checks on identifiers and reliable references. Validate cross-row balance and allocation constraints before committing every affected transaction. Persist correction links, match history and policy versions. Index account and date lookups and pending settlements. Version the schema and retain synthetic fixtures for every supported migration. The probe schema establishes feasibility. Review its code, error paths and licenses before considering reuse in the product.
