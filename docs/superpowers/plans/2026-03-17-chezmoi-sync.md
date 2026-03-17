# Chezmoi Home Sync Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Update chezmoi source so the current durable dotfile state in the home directory persists through future chezmoi applies.

**Architecture:** Reconcile existing managed files by re-importing the live target state, then selectively add unmanaged dotfiles that represent real configuration rather than caches, databases, secrets, or machine-local state. Verify both `chezmoi` and git output before stopping.

**Tech Stack:** `chezmoi`, git, shell utilities

---

### Task 1: Refresh Existing Managed Files

**Files:**
- Modify: existing managed source files corresponding to `chezmoi status`

- [ ] Step 1: Inspect `chezmoi status` and `chezmoi diff`
- [ ] Step 2: Re-add managed target files with `chezmoi add --force` so source matches the live home directory
- [ ] Step 3: Confirm the managed drift is cleared

### Task 2: Add Durable Unmanaged Configs

**Files:**
- Create: source files for selected unmanaged targets

- [ ] Step 1: Review unmanaged candidates and exclude caches, generated files, secrets, and app state
- [ ] Step 2: Add the selected durable configs with `chezmoi add`
- [ ] Step 3: Confirm they appear as intended in the source tree

### Task 3: Verify Result

**Files:**
- Verify: repo status and chezmoi status

- [ ] Step 1: Run `chezmoi status`
- [ ] Step 2: Run `chezmoi diff`
- [ ] Step 3: Run `git status --short`
- [ ] Step 4: Review final source changes for anything accidental
