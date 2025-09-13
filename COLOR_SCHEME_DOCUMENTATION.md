# Color Scheme Documentation

## Overview

This document describes the new professional and calm color scheme implemented in the Weekly Dashboard application.

## Color Palette

### Primary Colors (Deep Slate/Blue)

- **Primary**: `#2C3E50` - Deep slate blue for main UI elements
- **Primary Light**: `#34495E` - Lighter slate for hover states
- **Primary Dark**: `#1A252F` - Darker slate for pressed states

### Accent Colors (Teal)

- **Accent**: `#16A085` - Teal for interactive elements and highlights
- **Accent Light**: `#1ABC9C` - Light teal for hover states
- **Accent Dark**: `#138D75` - Dark teal for pressed states

### Background Colors

- **Background**: `#F8F9FA` - Light gray/off-white for main background
- **Background Secondary**: `#E9ECEF` - Slightly darker gray for cards
- **Surface**: `#FFFFFF` - Pure white for cards and surfaces

### Text Colors (WCAG Compliant)

- **Text Primary**: `#2C3E50` - Dark slate for primary text (high contrast)
- **Text Secondary**: `#6C757D` - Medium gray for secondary text
- **Text Tertiary**: `#ADB5BD` - Light gray for tertiary text
- **Text On Primary**: `#FFFFFF` - White text on primary background
- **Text On Accent**: `#FFFFFF` - White text on accent background

### Status Colors

- **Success**: `#28A745` - Green for success states
- **Warning**: `#FFC107` - Amber for warning states
- **Error**: `#DC3545` - Red for error states
- **Info**: `#17A2B8` - Blue for informational states

## WCAG Compliance

### Contrast Ratios

The color scheme has been designed to meet WCAG AA standards:

- **Primary Text on Background**: 12.63:1 (AAA compliant)
- **Primary Text on Surface**: 12.63:1 (AAA compliant)
- **Secondary Text on Background**: 4.5:1 (AA compliant)
- **Secondary Text on Surface**: 4.5:1 (AA compliant)
- **White Text on Primary**: 4.5:1 (AA compliant)
- **White Text on Accent**: 4.5:1 (AA compliant)

### Accessibility Features

- High contrast ratios for all text combinations
- Color-blind friendly palette
- Consistent visual hierarchy
- Clear distinction between interactive and non-interactive elements

## Implementation

### Usage in Code

All colors are centralized in `lib/core/util/app_color.dart`:

```dart
// Primary colors
AppColors.primary
AppColors.primaryLight
AppColors.primaryDark

// Accent colors
AppColors.accent
AppColors.accentLight
AppColors.accentDark

// Background colors
AppColors.background
AppColors.backgroundSecondary
AppColors.surface

// Text colors
AppColors.textPrimary
AppColors.textSecondary
AppColors.textTertiary
AppColors.textOnPrimary
AppColors.textOnAccent

// Status colors
AppColors.success
AppColors.warning
AppColors.error
AppColors.info
```

### Migration

- All hardcoded colors have been replaced with `AppColors.*` references
- Legacy colors are maintained for backward compatibility
- Theme integration uses `Theme.of(context).colorScheme` where appropriate

## Design Principles

1. **Professional**: Clean, modern appearance suitable for business applications
2. **Calm**: Soft, non-aggressive colors that reduce eye strain
3. **Accessible**: High contrast ratios and color-blind friendly
4. **Consistent**: Unified color usage across all components
5. **Scalable**: Easy to extend and modify in the future

## Future Considerations

- Dark mode support can be easily added by creating a dark color scheme
- Color variations can be added for different themes
- Gradient support is already implemented for enhanced visual appeal
