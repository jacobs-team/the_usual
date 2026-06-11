# Design System Document

## 1. Overview & Creative North Star
**Creative North Star: The Sensory Sommelier**

This design system is built to evoke the tactile and aromatic experience of a premium espresso bar. We are moving away from the "app-as-a-utility" and toward "app-as-an-editorial." The experience is defined by breathable layouts, intentional asymmetry, and a depth model that mimics fine glassware resting on a polished marble counter. By rejecting traditional borders and rigid grids in favor of tonal layering and glassmorphism, we create an interface that feels less like software and more like a high-end coffee journal.

## 2. Colors
Our palette is a curated spectrum of roast profiles—from the deep intensity of a ristretto to the airy lightness of steamed milk.

### The "No-Line" Rule
Designers are strictly prohibited from using 1px solid borders to section content. Boundaries must be defined through background color shifts. For example, a card using `surface-container-lowest` should sit on a `surface-container-low` background. This creates "soft edges" that feel organic rather than clinical.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of materials.
- **Base Layer:** `surface` (#faf9f5) or `background` (#faf9f5).
- **Secondary Sectioning:** `surface-container-low` (#f4f4f0).
- **Elevated Components:** `surface-container-lowest` (#ffffff) for maximum "pop" against warmer backgrounds.
- **Functional Depth:** Use `surface-variant` (#e2e3df) for deactivated or secondary states to provide a tactile "recessed" look.

### The "Glass & Gradient" Rule
Floating elements (navigation bars, hero cards, or overlays) must utilize **Glassmorphism**.
- **Token Use:** Semi-transparent `surface-container` tiers with a `backdrop-blur` (recommended 12px to 20px).
- **Signature Textures:** For primary CTAs, use a subtle linear gradient transitioning from `primary` (#271310) to `primary_container` (#3e2723) at a 135-degree angle. This prevents "flatness" and adds a liquid, coffee-like depth.

## 3. Typography
We use **Manrope** as our sole typeface. Its clean, geometric forms provide a contemporary edge that balances the warm, traditional color palette.

- **Display (lg/md/sm):** Used for "Hero" moments—roast names or welcome messages. These should use tight letter-spacing (-0.02em) to feel like a premium magazine header.
- **Headline & Title:** Used for navigation and category headers. Use `on_surface` (#1a1c1a) for maximum authority.
- **Body:** `body-lg` is your workhorse. Use `on_surface_variant` (#504442) for body text to reduce visual vibration and maintain a sophisticated, "latte" tonal quality.
- **Labels:** Reserved for metadata (e.g., brew temperature, origin). Always in `label-md` or `label-sm` with increased letter-spacing (+0.05em) for an architectural feel.

## 4. Elevation & Depth
Depth in this design system is achieved through **Tonal Layering**, not structural lines.

- **The Layering Principle:** Avoid shadows for static elements. Instead, "stack" your surface tokens. A `surface-container-highest` card on a `surface` background provides enough contrast to imply elevation without visual clutter.
- **Ambient Shadows:** When an element must "float" (like a Modal or a Floating Action Button), use an extra-diffused shadow.
    - **Blur:** 30px - 40px.
    - **Opacity:** 6% of `primary` (#271310). This creates a warm, natural "coffee-stain" shadow rather than a cold grey one.
- **The "Ghost Border" Fallback:** If a border is required for accessibility, use the `outline_variant` (#d3c3c0) at 20% opacity. Never use a 100% opaque border.
- **Glassmorphism Depth:** To mimic the reference image’s "Morning Ritual" card, use a semi-transparent fill of `surface_container_low` with a subtle `outline` (#827472) at 10% opacity to define the "rim" of the glass.

## 5. Components

### Buttons
- **Primary:** `primary` background with `on_primary` text. Use `roundness-lg` (1rem).
- **Secondary:** Glassmorphic—`surface-container` (60% opacity) with backdrop-blur.
- **Tertiary:** Text-only using `primary` color, reserved for low-priority actions like "Cancel" or "View All."

### Cards & Lists
- **Forbid Dividers:** Use vertical white space (`spacing-6` or `spacing-8`) to separate list items.
- **Product Cards:** Use `surface-container-lowest` for the card body. Images should have a subtle `roundness-md` to nest within the card’s `roundness-lg`.

### Input Fields
- **Styling:** Use a "soft-inset" look. Background should be `surface-container-low` with a `roundness-md`.
- **States:** On focus, transition the background to `surface-container-lowest` and add a "Ghost Border" using `surface_tint`.

### Navigation (Bottom Bar)
- **Visual Style:** Should be a floating glassmorphic container centered at the bottom of the screen.
- **Active State:** Use a `primary` icon with a tiny dot (indicator) below it. The dot color should be `surface_tint`.

### Additional Components: Brew Timers & Sensory Chips
- **Brew Timer:** A circular "Liquid Progress" bar using a gradient of `primary` to `primary_fixed_dim`.
- **Flavor Chips:** Small, `full-round` (pill-shaped) chips using `secondary_container` with `on_secondary_container` text.

## 6. Do's and Don'ts

### Do
- **Do** use generous white space. If a layout feels "full," increase the spacing by one tier in our scale.
- **Do** use "Editorial Asymmetry." For example, left-align your headlines while right-aligning your call-to-action buttons to create a dynamic eye-path.
- **Do** ensure all text on glassmorphic backgrounds meets WCAG AA contrast ratios by adjusting the opacity of the backdrop.

### Don't
- **Don't** use pure black (#000000). Always use `primary` (#271310) or `on_surface` (#1a1c1a).
- **Don't** use standard 1px dividers. If you feel you need a divider, you likely need more `spacing-6`.
- **Don't** use sharp corners. Every element should have at least `roundness-sm` to maintain the "soft minimalism" aesthetic.
- **Don't** use high-intensity shadows. If the shadow is clearly visible, it’s too dark. It should feel like an ambient glow.