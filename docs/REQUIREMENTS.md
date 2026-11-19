# Requirements — v0.1 scope baseline

## Goal
Offline-first Android personal expatriate manager encompassing Work • Leave • Money • Home. Focus on simple salary-day planning and accurate leave, saving and asset tracking. The interface is Arabic-first with right-to-left layout. Product implementation requires a separate authorization and the applicable M0 gate.

## Confirmed leave and work rules
- Annual leave: 30 paid calendar days per January–December year; no carryover; Fridays and Saturdays count when within leave dates.
- Casual leave: 13 days/year. Sick leave: 15 days/year with hospital report. Counting details/carryover for both require confirmation.
- Fridays and Saturdays are weekends.
- Employer-funded employee-only round-trip flight once annually; eligibility/use details still to verify.
- Nepal/mission holidays require employer-approved calendar; do not assume all Nepal public holidays apply or automatically exclude annual leave days.

## Salary and finance
- Salary paid in USD into Nepal bank. Salary-day workflow distinguishes planned, executed and confirmed actions.
- One bank remittance to Egypt can be apportioned to family support, own Egypt savings, later gold purchases, etc. Do not count purpose allocations as independent bank transfers.
- Direct transfers may go to user's own Egypt account or directly to a beneficiary; only actual family payout is an expense. Optional fee/rate margin without mandatory fee breakdown.
- Nepal living expenses in NPR: larger items separately and small transactions aggregated daily/weekly, paid by cash or card/account without duplicating a card as an asset.
- USD cash withdrawal from Nepal bank up to user-reported USD 500 per month; configurable limit and optional cash savings. Bank-to-cash movement is not spending.
- Start with USD, NPR and EGP and allow additional currencies. Opening balances are optional. Where no opening balance is supplied, show net recorded movements and mark the real balance as unknown.
- Use the simplified double-entry ledger described in [Architecture](ARCHITECTURE.md). Record actual amounts, dates and observed exchange information when known. Support pending settlement, linked corrections and manual statement reconciliation. Show planned, executed and confirmed amounts separately.
- Fixed and flexible family support, savings and living commitments; no current debt/instalments.
- Leave saving: flexible contributions toward a target, recalculate monthly suggestion; employer-paid airfare not automatically a personal cost.

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
Official leave rules and calendar remain pending under T-002. Show provisional leave results as such. The real account layout, remittance custody and evidence, and correction treatment for a reconciled period remain open under T-003. Record confirmed inputs before enabling affected financial workflows. Release branding and licensing remain separate decisions.