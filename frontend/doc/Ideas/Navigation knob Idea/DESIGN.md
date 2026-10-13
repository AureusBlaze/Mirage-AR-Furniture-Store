# Design System Strategy: Ethereal Tech

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Digital Forest."** It is a philosophy that marries the precision of futuristic interfaces with the atmospheric, unpredictable beauty of a misty woodland. This system breaks away from the "flat grid" monotony of modern SaaS by embracing **Organic Editorialism**.

We achieve this through:
*   **Intentional Asymmetry:** Foregoing rigid center-alignment for staggered layouts that mimic natural growth.
*   **Tonal Depth:** Replacing harsh lines with overlapping, semi-transparent layers that create a sense of mist and fog.
*   **Textured Atmosphere:** Utilizing a "Grain & Glow" approach where backgrounds are never solid, but rather a blend of deep forest hues and warm amber light leaks.

This is not a template; it is a signature digital environment designed to feel premium, quiet, and deeply intentional.

---

## 2. Colors & Atmospheric Surface
The palette is a sophisticated interplay of `deep forest greens`, `warm ambers`, and `misty grays`. It is intentionally desaturated to maintain a professional, high-end aesthetic.

### The "No-Line" Rule
**Standard 1px solid borders are strictly prohibited.** To define sections, designers must use tonal shifts. A section should be distinguished by moving from `surface` to `surface-container-low`, or by using a subtle gradient transition. Boundaries are felt, not seen.

### Surface Hierarchy & Nesting
Think of the UI as physical layers of frosted glass.
*   **Lowest Level:** `surface-container-lowest` (#0d0f0d) for deep, recessed areas.
*   **Base:** `surface` (#121412) for the primary canvas.
*   **Elevated Layers:** Use `surface-container` through `surface-container-highest` to stack elements. An inner card should always be 1-2 tiers higher than its parent container to create natural lift.

### The "Glass & Gradient" Rule
To achieve the "Ethereal Tech" look, use **Backdrop Blur (20px-40px)** on floating elements. Use the `secondary` amber (#f8bb73) sparingly as a "light leak" gradient (at 5-10% opacity) behind glass panels to simulate sunlight hitting mist.

---

## 3. Typography
Our typography is a dialogue between the technical and the humanistic.

*   **Display & Headlines (Epilogue):** This is our "Editorial" voice. Use `display-lg` and `headline-lg` with generous tracking adjustments to anchor pages. The heavy weight of Epilogue against a misty background provides the "Tech" in Ethereal Tech.
*   **Body & Titles (Manrope):** Chosen for its modern, clean legibility. `body-md` is the workhorse for information density.
*   **Technical Labels (Space Grotesk):** Used for `label-md` and `label-sm`. The monospaced feel of Space Grotesk adds a layer of futuristic precision to data points and small metadata.

---

## 4. Elevation & Depth
In this design system, depth is a product of light and transparency, not shadow alone.

*   **Tonal Layering:** Avoid shadows for standard cards. Instead, place a `surface-container-low` card on top of a `surface` background. The contrast in value is sufficient for the eye to perceive hierarchy.
*   **Ambient Shadows:** When an object must "float" (like a modal or dropdown), use a shadow with a blur of `32px` or higher, set to `4-8%` opacity. The shadow color should be a tinted version of `on-surface` (#e2e3df) to mimic the way light scatters in a foggy environment.
*   **The "Ghost Border" Fallback:** If a container requires a border for accessibility, use the `outline-variant` token at **15% opacity**. This creates a "glint" on the edge of the glass rather than a structural line.

---

## 5. Components

### Buttons
*   **Primary:** A soft gradient from `primary` (#bfc9be) to `primary-container` (#2d362e). Text is `on-primary`. Corner radius: `md` (0.375rem).
*   **Secondary (Ghost):** No background. `outline-variant` at 20% opacity for the border. Text is `primary`.
*   **Tertiary:** Transparent background, `label-md` typography. Used for low-emphasis actions.

### Cards & Lists
*   **The "No-Divider" Mandate:** Dividers are forbidden. Separate list items using `spacing-4` (1.4rem) of vertical white space or by alternating background tones between `surface-container-low` and `surface-container`.
*   **Glassmorphic Cards:** High-level summary cards should use a 60% opacity `surface-container-high` with a `backdrop-filter: blur(12px)`.

### Input Fields
*   **Container:** `surface-container-lowest` with a "Ghost Border."
*   **Focus State:** The border transitions to `secondary` (amber) at 40% opacity, creating a subtle "glow" effect rather than a harsh stroke.
*   **Helper Text:** Always use `label-sm` in `on-surface-variant` to maintain a technical, clean look.

### Additional Signature Component: The "Atmospheric Glow"
For high-priority data points or CTAs, place a blurred radial gradient of `secondary_container` (#694000) behind the element to create a "halo" effect, drawing the eye without using intrusive arrows or bright colors.

---

## 6. Do's and Don'ts

### Do
*   **Do** use asymmetrical layouts. If a headline is left-aligned, try right-aligning the supporting body text to create a dynamic, editorial flow.
*   **Do** use the full range of the Spacing Scale. Large gaps (e.g., `spacing-16`) are essential to give the "Ethereal" aesthetic room to breathe.
*   **Do** leverage `surface-tint` to give a slight greenish-gray wash to overlay elements.

### Don't
*   **Don't** use 100% black (#000000). Always use `surface-container-lowest` to maintain the "misty" depth.
*   **Don't** use high-contrast borders. If you can see the line clearly from a distance, it is too heavy.
*   **Don't** crowd the interface. This system relies on "The Digital Forest" being a calm, quiet place. If the UI feels busy, increase your spacing tokens.