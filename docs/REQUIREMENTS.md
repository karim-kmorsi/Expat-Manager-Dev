# Requirements — v0.1 scope baseline

## Goal
Personal Android app for managing expatriate affairs across Work • Leave • Money • Home. It runs locally without an internet connection and covers salary-day planning, leave, savings and assets. The interface is Arabic-first with right-to-left layout. Product implementation requires a separate authorization and the applicable M0 gate.

## Personal leave and travel rules (T-002)

The user is the authority for leave and entitlement rules. The app serves personal planning only, outside the scope of government services and official HR systems. The user can set rules without a legal citation, employer approval or an official employer reference. The app assumes no applicability of Qatari labor law. The user can adjust the rules in the future. Retain each rule version and its effective date. Keep requested, approved and used leave distinct. Leave planning works locally without an internet connection, AI or a chat interface.

### Approved settings

- Annual leave is 30 paid calendar days per January–December year, with no carryover in the current setting. Fridays and Saturdays count when they fall within the approved annual leave period.
- Casual leave is 13 days per year.
- Sick leave is 15 days per year. Record the presence or status of the medical report without storing sensitive medical documents.
- Weekly rest days are Friday and Saturday.
- The employee has one round-trip flight entitlement per year, funded by the employer under the current personal setting.
- Planning uses the remaining leave balance, holidays and weekly rest days. It supports a specific date, a future period or a particular occasion.

### Details awaiting user decisions

- Which holiday dates apply and how holidays affect deductions for each leave type. How weekly rest days affect casual and sick leave deductions remains open.
- Inclusivity of start and end dates, return-to-work timing, and the treatment of leave that spans two entitlement years.
- Counting units, carryover and renewal dates for casual and sick leave, and any prorating rules.
- How to handle edits and cancellations, including when to debit, release or restore a balance.
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