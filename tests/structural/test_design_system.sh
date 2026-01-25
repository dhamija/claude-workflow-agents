#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Design System Templates and Presets Exist"

TEMPLATES_DIR="$REPO_ROOT/templates/docs/ux"
PRESETS_DIR="$TEMPLATES_DIR/presets"

# Check design system template exists
assert_file_exists "$TEMPLATES_DIR/design-system.md.template"

# Check preset directory exists
assert_dir_exists "$PRESETS_DIR"

# Check all required presets exist
REQUIRED_PRESETS=(
    "modern-clean"
    "minimal"
    "playful"
    "corporate"
    "glassmorphism"
)

for preset in "${REQUIRED_PRESETS[@]}"; do
    assert_file_exists "$PRESETS_DIR/$preset.md"
done

# Check design system template has required sections
TEMPLATE_FILE="$TEMPLATES_DIR/design-system.md.template"

assert_file_contains "$TEMPLATE_FILE" "## Color Palette"
assert_file_contains "$TEMPLATE_FILE" "## Typography"
assert_file_contains "$TEMPLATE_FILE" "## Spacing & Layout"
assert_file_contains "$TEMPLATE_FILE" "## Components"
assert_file_contains "$TEMPLATE_FILE" "## Accessibility"
assert_file_contains "$TEMPLATE_FILE" "## Implementation"
assert_file_contains "$TEMPLATE_FILE" "### Tailwind CSS Config"
assert_file_contains "$TEMPLATE_FILE" "### CSS Variables"

# Check each preset has required sections
for preset in "${REQUIRED_PRESETS[@]}"; do
    PRESET_FILE="$PRESETS_DIR/$preset.md"

    assert_file_contains "$PRESET_FILE" "## Color Palette"
    assert_file_contains "$PRESET_FILE" "## Typography"
    assert_file_contains "$PRESET_FILE" "## Components"
    assert_file_contains "$PRESET_FILE" "## Implementation Notes"
done

summary
