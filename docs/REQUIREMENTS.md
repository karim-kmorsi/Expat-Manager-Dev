# Requirements — v0.1 scope baseline

## Goal
Personal Android app for managing expatriate affairs across Work • Leave • Money • Home. It runs locally without an internet connection and covers salary-day planning, leave, savings and assets. The interface is Arabic-first with right-to-left layout. Product implementation requires a separate authorization and the applicable M0 gate.

## Personal leave and travel rules (T-002)

The user is the authority for leave and entitlement rules. The app serves personal planning only, outside the scope of government services and official HR systems. The user can set rules without a legal citation, employer approval or an official employer reference. The app assumes no applicability of Qatari labor law. The user can adjust the rules in the future. Retain each rule version and its effective date. Keep requested, approved and used leave distinct. Leave planning works locally without an internet connection, AI or a chat interface.

### Approved settings

- Annual leave is 30 paid calendar days per January–December year, with no carryover in the current setting. The approved period includes both the start and end date.
- Casual leave is 13 calendar days per year.
- Sick leave is 15 calendar days per year. Record the presence or status of the medical report without storing sensitive medical documents.
- Weekly rest days are Friday and Saturday. Rest days and official holidays inside the leave period count for all types. Holidays after the period do not reduce the balance. Return to work is the first workday after the end date.
- When leave spans two years, charge every day to the start year, subject to sufficient balance. The new year is not charged for that entry.
- The employee has one round-trip flight entitlement per year, funded by the employer under the current personal setting.
- Planning uses the remaining leave balance, holidays and weekly rest days. It supports a specific date, a future period or a particular occasion.

### Details awaiting user decisions

- The user maintains the list of applicable official holidays.
- Carryover, renewal dates and prorating for casual and sick leave remain open. The app shows provisional balances for those types using the start calendar year, with no inferred carryover.
- Formal approval procedures remain open. For personal tracking, requested entries have no balance impact. Approved entries reserve days and used entries count as used once. Cancellation releases only unused days. When cancelling the remainder of a partly used approved period, record the last day actually used and keep the used part charged to the original start year. Used periods allow edits to descriptive details only.
- When a medical report is required, and whether any pay or other conditions apply to casual or sick leave.
- The dates of the travel entitlement cycle, booking and usage conditions, and treatment of an unused trip.

Use only rules approved by the user. Where a planning result depends on an undecided rule, identify the result as provisional.

## Salary and finance
- Salary paid in USD into Nepal bank. Salary-day workflow distinguishes planned, executed and confirmed actions.
- One bank remittance to Egypt can be apportioned to family support, own Egypt savings, later gold purchases, etc. Do not count purpose allocations as independent bank transfers.
- Direct transfers may go to user's own Egypt account or directly to a beneficiary; only actual family payout is an expense. Optional fee/rate margin without mandatory fee breakdown.
- Nepal living expenses in NPR: larger items separately and small transactions aggregated daily/weekly, paid by cash or card/account without duplicating a card as an asset.
- USD cash withdrawal from Nepal bank up to user-reported USD 500 per month; configurable limit and optional cash savings. Bank-to-cash movement is not spending.
- Start with USD, NPR and EGP and allow additional currencies. Opening balances are optional. Where no opening balance is supplied, show net recorded movements and mark the real balance as unknown.
- Use the simplified double-entry ledger described in [Architecture](ARCHITECTURE.md). Record actual amounts, dates and observed exchange information when known. Support pending settlement, linked corrections and manual statement reconciliation. Show planned, executed and confirmed amounts separately.
- Fixed and flexible family support, savings and living commitments; no current debt/instalments.
- Leave saving uses flexible contributions toward a target and recalculates the monthly suggestion. Include airfare in the target only when the user identifies it as a personal expense.

## Assets and investments
- Physical gold in Egypt: piece/purchase entries, weight, purity, cost if known, owner, holder/custodian (mother or brother), distinct from brokerage investments.
- Thndr: manual portfolio total snapshots as of date and deposited/withdrawn cash; detailed positions and live feeds deferred. Unrealized appreciation is not cash.

## Must-have flows
1. Salary received -> allocate to remittance, bank/cash, NPR living and savings; show unallocated money.
2. Record actual account movements independently of allocations, avoiding duplicated expenses/assets.
3. Record one Egypt remittance and multiple allocations to purposes.
4. Account balances, dated FX, grouped or detailed Nepal expenses.
5. Leave ledger/balances, holiday/calendar view, flight entitlement and trip savings.
6. Gold item register and manual Thndr portfolio snapshot.
7. Fully offline entry and local password-encrypted backup/restore without a cloud account.
8. Arabic navigation and financial forms with RTL support. Keep dates, signed amounts, currency codes and statement references legible in mixed-direction text.

## Not in v0.1
Bank/broker integrations; live stock/gold pricing; investment order execution; AI advisor; multi-device sync; complex debt management; public release.

## Open questions
The real account layout, remittance custody and evidence, and correction treatment for a reconciled period remain open under T-003. Record confirmed inputs before enabling affected financial workflows. Release branding and licensing remain separate decisions.