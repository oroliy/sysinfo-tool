# Homepage Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the landing page into a warmer, more polished product-style homepage with English as the default language.

**Architecture:** Keep the homepage self-contained in `public/index.html` with a richer semantic layout and CSS variable-driven styling. Keep language and copy-button behavior in `public/lang-toggle.js`, updating the script to target the redesigned DOM and default first-load behavior to English.

**Tech Stack:** Static HTML, CSS, vanilla JavaScript, shell regression checks

---

### Task 1: Lock redesign behavior with regression checks

**Files:**
- Modify: `tests/regression-checks.sh`
- Test: `tests/regression-checks.sh`

- [ ] Add assertions for the new homepage structure and English-default behavior.
- [ ] Run `bash tests/regression-checks.sh` and verify it fails before the redesign.

### Task 2: Rebuild homepage markup and styling

**Files:**
- Modify: `public/index.html`
- Test: `tests/regression-checks.sh`

- [ ] Replace the current centered card with a richer two-column hero layout.
- [ ] Introduce coherent CSS variables, warmer palette, editorial typography, and responsive rules.
- [ ] Preserve the install command, download CTA, copy button, language toggle, and live status area in the new structure.

### Task 3: Update homepage interaction logic

**Files:**
- Modify: `public/lang-toggle.js`
- Test: `tests/regression-checks.sh`

- [ ] Update translation targets to match the redesigned markup.
- [ ] Make English the default language when no explicit saved preference exists.
- [ ] Keep copy-button feedback localized and synchronized with the active language.

### Task 4: Verify end-to-end

**Files:**
- Test: `tests/regression-checks.sh`
- Test: `public/index.html`
- Test: `public/lang-toggle.js`

- [ ] Run `bash tests/regression-checks.sh` and verify it passes.
- [ ] Run `node --check public/lang-toggle.js` and verify it passes.
- [ ] Parse `public/index.html` with Python HTMLParser and verify it succeeds.
