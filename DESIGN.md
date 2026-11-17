---
name: Tactile Mecha-OS Light
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#424656'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#737687'
  outline-variant: '#c2c6d9'
  surface-tint: '#0053da'
  primary: '#004cca'
  on-primary: '#ffffff'
  primary-container: '#0062ff'
  on-primary-container: '#f3f3ff'
  inverse-primary: '#b4c5ff'
  secondary: '#006a6a'
  on-secondary: '#ffffff'
  secondary-container: '#56f9f9'
  on-secondary-container: '#007071'
  tertiary: '#ad1220'
  on-tertiary: '#ffffff'
  tertiary-container: '#d13035'
  on-tertiary-container: '#fff1ef'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#56f9f9'
  secondary-fixed-dim: '#26dcdd'
  on-secondary-fixed: '#002020'
  on-secondary-fixed-variant: '#004f50'
  tertiary-fixed: '#ffdad7'
  tertiary-fixed-dim: '#ffb3ae'
  on-tertiary-fixed: '#410004'
  on-tertiary-fixed-variant: '#930015'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  headline-xl:
    fontFamily: Space Grotesk
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Space Grotesk
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Space Grotesk
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Space Grotesk
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Space Grotesk
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 26px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: JetBrains Mono
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.04em
  label-md:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.06em
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 9px
    fontWeight: '600'
    lineHeight: 12px
    letterSpacing: 0.08em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-lg: 1.5rem
  margin: 1rem
  margin-lg: 2rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1.25rem
  space-xl: 2rem
---

## Brand & Style

This design system translates the precision, ergonomic tactility, and high-performance clarity of flagship white gaming handheld hardware (inspired by the Nintendo Switch OLED, white Steam Deck, and ROG Ally) into an industrial robotics controller. 

The aesthetic merges clean consumer hardware industrial design with mission-critical robotics telemetry. It rejects the stereotypical gritty, low-contrast dark sci-fi HUD in favor of a crisp, sunlit, technical dashboard. Every element feels machined, molded, and immediately responsive under thumb or stylus pressure. The interface evokes effortless mastery, safety, precision, and the tactile joy of premium gaming hardware. Surfaces balance soft matte shell plastics with micro-beveled tactile triggers, pill-shaped instrument clusters, and vivid electronic signal cues.

## Colors

The palette reproduces the tactile materials of premium white matte handheld plastics paired with saturated electronic telemetry status lights:

- **Primary (`#0062FF` / Cobalt Drive):** Used for primary hardware execution, active drive states, and high-priority action toggles.
- **Secondary (`#00D2D3` / Hyper Cyan):** Diagnostic indicators, sensor telemetry, LiDAR tracking points, and thumbstick active zones.
- **Tertiary (`#FF5252` / Hot Coral/Amber):** Critical safety limits, e-stop warnings, gripper lock engages, and high-torque thermal spikes.
- **Surface Foundations:** 
  - Off-white shell ground: `#F4F5F8`
  - Elevated instrument pod white: `#FFFFFF`
  - Machined structural gutters & chassis divisions: `#E2E5EB`
- **Text & Readout Hierarchy:**
  - High-torque text: `#0F172A`
  - Secondary label/spec text: `#334155`
  - Neutral HUD calibration text: `#64748B`

Color is deployed with purpose: neutral shell whites preserve spatial awareness, while hyper-saturated neon accents simulate LED surface light-pipes and illuminated tactile buttons.

## Typography

The typographic strategy balances tech-forward geometry with instant legibility:

- **Headlines (Space Grotesk):** Provides mechanical, angled terminals reminiscent of etched industrial hardware chassis markings and gaming console OS dashboards.
- **Body (Plus Jakarta Sans):** Offers ergonomic, soft, yet disciplined readability for operator documentation, telemetry details, and control mappings.
- **Labels & Values (JetBrains Mono):** Formatted for zero-jitter, fixed-width telemetry values, coordinate readouts (X/Y/Z rotational axes), actuator thermal output, and millisecond-level round-trip latency metrics. Always set uppercase when used in diagnostic status pills and mode badges.

## Layout & Spacing

The layout philosophy mirrors the ergonomic split of modern handheld consoles, optimizing for thumb zones and central viewport awareness:

- **Grid Architecture:** A responsive 12-column layout on wide touch displays (7" to 11" 16:10 or 16:9 displays) transitions to a 4-column layout on compact handheld devices. 
- **Zonal Partitioning:**
  - **Left Flank:** Movement/Locomotion telemetry, D-pad actuator statuses, and speed profile clusters.
  - **Center Viewport:** Clear sensor feeds, spatial meshes, point-cloud streams, and battery/connection status ribbons.
  - **Right Flank:** Gripper state, payload articulators, and ABXY diamond trigger matrix.
- **Touch Margins & Hit Targets:** Minimum interactive touch bounding boxes are 44x44px. Critical emergency interventions leverage 56px minimum heights to prevent thumb slippage under vibrating or field operating conditions.

## Elevation & Depth

Visual hierarchy uses physical injection-molded chassis depth rather than high-elevation drop shadows:

- **Surface Plastic Shell (Level 0):** `#F4F5F8` background with an inset hairline border (`#E2E5EB`) evoking a clean matte hardware casing.
- **Recessed Bays & Trays (Level -1):** Subtle 1px inner shadows (`inset 0 1px 3px rgba(15, 23, 42, 0.08)`) with `#EBEDF2` background, framing telemetry clusters and thumbstick boundary wells.
- **Floating Sensor Pods & Cards (Level 1):** Solid `#FFFFFF` fills paired with dual-layer micro-shadows: a crisp directional contact shadow (`0 2px 4px rgba(15, 23, 42, 0.04)`) and a diffused ambient cushion (`0 8px 16px rgba(15, 23, 42, 0.06)`).
- **Injection-Molded Tactile Buttons (ABXY / D-Pad):** Multi-layered tactile depth using top highlight borders (`inset 0 1px 0 rgba(255, 255, 255, 0.9)`) and a dense bottom lip (`0 3px 0 #CBD5E1`) creating an authentic physical push-button extrusion.
- **Active Optical Light-Pipes:** High-state toggles emit localized, subtle glows (`0 0 12px rgba(0, 210, 211, 0.35)` or `0 0 12px rgba(0, 98, 255, 0.35)`).

## Shapes

The interface balances ergonomic rounded corners with mechanical pill envelopes:

- **Hardware Cards & Viewports:** Utilize `rounded-lg` (1rem) for an organic handheld contour that feels molded to the controller body.
- **Status Badges, Telemetry Pills & Toggles:** Fully pill-shaped (`rounded-full` / 9999px) for HUD badges, telemetry metrics, and mode switch toggles.
- **ABXY & D-Pad Virtual Touch Triggers:** Geometric circular discs and cross-axial chamfered caps for thumbpad control.
- **Outlines:** Razor-sharp 1px micro-borders (`#E2E5EB`) preserve structural boundary definitions between overlapping white surfaces in sunlight conditions.

## Components

### Buttons & Physical Handheld Triggers
- **Primary Drive Button:** Cobalt blue base (`#0062FF`) with white text, micro-molded top bevel (`inset 0 1px 0 rgba(255, 255, 255, 0.35)`), and lower bezel shadow (`0 3px 0 #0045B5`). Active state drops the bottom bezel to 0px with an internal inset shadow.
- **Tactile ABXY Diamond Clusters:** Circular 48px tactile pads (`#FFFFFF`) housing sharp Space Grotesk single glyphs (`A`, `B`, `X`, `Y`) color-coded with electronic rings (Green, Red, Blue, Yellow). Raised plastic profile with `0 3px 0 #CBD5E1`.
- **Directional Pad (D-Pad):** Sculpted cross module in `#E2E5EB` with directional arrowhead stamps and smooth micro-depressions.

### Pill-Shaped Telemetry Cards & HUD Chips
- **Status HUD Badges:** JetBrains Mono font encased in pill geometries with low-opacity tint backgrounds (e.g., Coral Alert: `#FEE2E2` fill, `#DC2626` text, `#FCA5A5` 1px border).
- **Latency & Signal Pills:** Ultra-compact badges featuring a pulsating LED dot indicator paired with live millisecond timing readouts (`12ms | 60FPS`).

### Sensor & Video Feeds
- **Camera Viewport Cards:** Crisp white outer bezel with 12px padding surrounding the live robot camera or depth-point mesh. Features clean monospaced overlay crosshairs and corner tick marks in Cyan (`#00D2D3`).

### Input Sliders & Analog Throttle Bars
- **Thumb Sliders:** Wide, knurled-texture touch bars housed in recessed tracks with segmented tick increments. Active fills use Cobalt-to-Cyan smooth gradients.
- **Rotary Gripper Indicators:** Circular gauge cards displaying millimeter clamp extension and pressure limits via segmented progress rings.

### Checkboxes & Toggle Switches
- **Toggle Switches:** Ergonomic mechanical toggles styled as physical sliding sliders on gaming handheld shells: matte pill well with a circular knob that projects a crisp hardware drop shadow.