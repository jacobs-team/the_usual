---
name: design-mockups
description: Use when the user wants to mock up, explore, or compare UI designs for a widget or screen before building it — "mock this up", "show me some designs", "design options", "what could this look like". Produces phone-framed HTML mockups that match the app's real design tokens and screenshots them inline.
---

# Design Mockups

Mock UI ideas as a single self-contained HTML file in a phone frame, styled with the app's real design tokens, then screenshot it so the options appear inline in chat. HTML is the medium because the Flutter app is run by the developer from VS Code, not by you — you can render and screenshot HTML, you cannot run the app.

## Workflow

1. **Read the real tokens.** Pull values from the design system so mockups look like the app, not a generic guess:
   - `lib/design_system/app_palette.dart` — colors (use the light scheme; note the macro colors).
   - `lib/design_system/app_design.dart` — spacing and radius scales.
   - `lib/design_system/app_theme.dart` — fonts (the Google Fonts used for headings vs body) and component shapes (cards, sheets, chips, buttons).
   - The widget being redesigned and its neighbors, so you reuse the app's existing visual language (cards, dashed quick-pick chips, the macro/nutrition bar, etc.).

2. **Build one HTML file** under `design/mockups/<feature>_designs.html`. Mirror the tokens into CSS variables (`:root { --primary: ...; --surface: ...; }`) copied from the palette, and load the matching Google Fonts via `<link>`. Frame each design in a phone-sized container with a dimmed scrim behind a bottom sheet / screen so it reads like the real app.

3. **Show N distinct directions side by side, plus the current version for reference.** Make them genuinely different approaches (A/B/C), not three tweaks of one. Label each column with a short name and a one-line description of the idea and its trade-off.

4. **Screenshot it** with the chrome-devtools tools so the images land in chat:
   ```
   new_page        → file:///<abs-path-to-html>
   resize_page     → width ~1480, height ~900
   take_screenshot → fullPage: true
   ```

5. **Present and recommend.** Describe each direction, give a recommendation with reasoning, then ask which to build (offer a "mix / iterate" option). Build only after the user picks.

## Defaults and options

- Default output dir is `design/mockups/`.
- Reuse existing components where they fit rather than inventing look-alikes; map a design back to real widgets when asked.
- Offer light + dark only if the user asks for both.
- Keep the mockup as a rough reference. What ships is the Flutter implementation, which may diverge (e.g. a real shared widget replaces a mocked element). Say so rather than implying the HTML is the source of truth.

## Common mistakes

- Inventing colors, radii, or fonts instead of reading them from `lib/design_system/`. The point is fidelity to the app.
- Producing three near-identical variants. Make them distinct directions.
- Returning a file path with no screenshot. Always screenshot so the user sees the options without opening anything.
- Trying to run the Flutter app to render the UI. You don't run the app; mock in HTML.