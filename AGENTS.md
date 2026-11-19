# Agent working rules — Expat Manager

Status: **planning only**. Do not implement features, install dependencies, initialize code, publish, or change other repositories without explicit authorization.

Before acting: read README.md, docs/REQUIREMENTS.md, docs/DECISIONS.md, docs/ARCHITECTURE.md, docs/ACCEPTANCE.md and planning/ROADMAP.md; inspect branch, working tree, SDK and actual files; identify task ID, acceptance criteria and dependencies.

AI Project Manager is the primary task tracker. Do not create GitHub Issues or duplicate tasks unless explicitly approved. Maintain stable T-IDs. This repository is the source of truth for code and documentation, not task status synchronization.

When implementation is authorized: work in bounded scope; do not silently expand it; use synthetic data and never banking credentials; preserve accounting invariants (plan != payment; own-account transfer != expense; earmarking != money movement); test relevant invariants; verify and report tests, file changes and blockers. No automatic merges, publishing, releases or destructive actions without specific approval.

Review third-party licenses before copying code, especially GPL. Do not claim production readiness merely because tests pass.