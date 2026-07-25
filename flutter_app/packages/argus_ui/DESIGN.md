# Argus Design System Specification

This document defines the design tokens, visual rules, and branding system for **Argus** (Bundle ID: `com.signode.argus`), an offline-first, high-precision Quality Control (QC) issue tracking platform for manufacturing plant floors.

---

## 1. Palette Architecture

The Argus interface uses a high-contrast industrial aesthetic designed for readability under factory lighting.

### 1.1 Core Brand Colors
- **Brand Accent (Light)**: `#F59E0B` (Amber 500)
- **Brand Accent (Dark/Hover)**: `#D97706` (Amber 600)

### 1.2 Neutrals (Slate Scale)
- **Slate 900 (Deep Dark)**: `#0F172A` (Scaffold background in Dark mode)
- **Slate 800 (Panel Dark)**: `#1E293B` (Card/Panel background in Dark mode)
- **Slate 700 (Border Dark)**: `#334155` (Border color in Dark mode)
- **Slate 500 (Muted/Secondary)**: `#64748B` (Secondary text, inactive elements)
- **Slate 200 (Border Light)**: `#E2E8F0` (Border color in Light mode)
- **Slate 50 (Scaffold Light)**: `#F8FAFC` (Scaffold background in Light mode)

### 1.3 Semantic Status Colors
Used to represent issue ticket lifecycle states:
- **Open**: `#3B82F6` (Blue 500)
- **Assigned**: `#8B5CF6` (Purple 500)
- **In Progress**: `#F59E0B` (Amber 500)
- **Resolved**: `#10B981` (Emerald 500)
- **Closed**: `#64748B` (Slate 500)
- **SLA-Breached**: `#EF4444` (Red 500)

### 1.4 Severity Colors
Used to immediately highlight issue severity levels:
- **Critical**: `#EF4444` (Red 500)
- **Major**: `#F97316` (Orange 500)
- **Minor**: `#EAB308` (Yellow 500)

---

## 2. Typography Scale

All typography rules use offline-first bundled fonts to guarantee reliable rendering without internet connectivity.

| Face | Font Family | Usage |
| :--- | :--- | :--- |
| **Heading / Display** | `Space Grotesk` | Large titles, stats, main header elements |
| **Body / UI** | `Inter` | Labels, buttons, description texts, standard UI |
| **Monospace** | `JetBrains Mono` | IDs (e.g. `ARG-2026-00142`), Timestamps, TAT counters |

### Font Style Tokens
- **Display Large**: 32pt, Space Grotesk, Bold
- **Headline Medium**: 20pt, Space Grotesk, SemiBold
- **Title Large**: 16pt, Space Grotesk, SemiBold
- **Body Large**: 16pt, Inter, Regular
- **Body Medium / UI**: 14pt, Inter, Regular
- **Body Small**: 12pt, Inter, Medium
- **Monospace Text**: 12pt / 14pt, JetBrains Mono, Regular / Bold

---

## 3. Layout & Geometry

Argus enforces a strict, rigid layout to feel like a dashboard from high-end machinery rather than a consumer social media app.

- **Grid Spacing Scale**: 8pt base grid (8px, 16px, 24px, 32px, 48px, 64px padding and margins).
- **Sharp Radius Rules**: 
  - Smaller interactive elements (buttons, inputs, badges): **4px** radius.
  - Larger container blocks (cards, panels): **6px** radius.
  - *No consumer-grade rounded pills (e.g. 50px) or circular buttons.*
- **Borders**: Thin, high-contrast borders (**1px** thickness) to outline panels rather than using soft drop shadows.

---

## 4. Motion Curves & Durations

Transitions must feel responsive and snapping, matching the industrial environment.
- **Duration Fast**: `150ms` (for hover states, small transitions)
- **Duration Standard**: `250ms` (for page route changes, larger panel slides)
- **Motion Curve**: `Curves.easeInOutCubic` (snappy, acceleration-deceleration curve)

---

## 5. Branding Rules

- **Platform Name**: `Argus`
- **Package / Bundle ID**: `com.signode.argus`
- **Standard Notification/Alert Format**: 
  > *"Argus flagged a new issue on Line [X]"*
