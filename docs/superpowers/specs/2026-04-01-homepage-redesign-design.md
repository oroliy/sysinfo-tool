# Homepage Redesign Design

Date: 2026-04-01

## Goal

Redesign the GitHub Pages homepage so it feels intentional and polished rather than plain. The new page should keep the current functional behavior, but present the project more like a compact product landing page.

## User-Approved Direction

- Visual direction: Product Lab
- Palette reference: Claude-style warm neutrals
- Default language: English

## Scope

- Redesign `public/index.html`
- Update homepage interaction logic in `public/lang-toggle.js`
- Preserve the existing install command, download action, copy interaction, and language toggle

Out of scope:

- Changing installer URLs
- Changing script behavior
- Adding new pages or sections outside the landing page

## Design

### Visual Language

- Use a warm paper-like background with soft radial highlights instead of flat gray
- Use dark graphite text rather than pure black
- Use muted sand and cocoa accents rather than bright blue-first SaaS styling
- Use a more editorial hero heading paired with restrained product-style supporting text

### Layout

- Keep a single-page landing experience
- Use a two-column hero on desktop:
  - Left: headline, description, primary action, install command card
  - Right: compact visual panel showing example output / product context
- Collapse to a single column on smaller screens

### Content Hierarchy

- Put the install command card at the center of the page
- Keep `Download Script` as the primary CTA
- Keep the copy button adjacent to the command
- Keep the language toggle visible, but visually quieter than the main CTA

### Language Behavior

- Default to English on first load
- Continue to support switching between English and Chinese
- Continue to persist explicit user choice in `localStorage`
- Keep all homepage UI copy synchronized across both languages, including copy button labels and copy feedback text

### Accessibility and Interaction

- Keep the language toggle and copy button keyboard accessible
- Keep `aria-live` feedback for copy status
- Maintain readable contrast even with the warmer palette

## Implementation Notes

- Prefer CSS variables to make palette and spacing changes coherent
- Keep the page self-contained in `public/index.html` unless logic clearly belongs in `public/lang-toggle.js`
- Rework the markup enough to support the new hierarchy rather than trying to style around the old minimal layout

## Verification

- HTML parses successfully
- `public/lang-toggle.js` passes syntax check
- Regression checks continue to pass after the redesign
- Manual review should confirm:
  - English is the default language
  - Chinese can still be toggled on
  - Copy interaction still works
  - Layout remains usable on mobile widths
