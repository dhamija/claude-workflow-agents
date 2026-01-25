#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Command Frontmatter"

COMMANDS_DIR="$REPO_ROOT/commands"

for cmd_file in "$COMMANDS_DIR"/*.md; do
    if [ -f "$cmd_file" ]; then
        basename="${cmd_file##*/}"
        info "Checking $basename"

        # Check frontmatter exists
        if ! head -1 "$cmd_file" | grep -q "^---$"; then
            fail "$basename: No frontmatter"
            continue
        fi

        # Check required fields (name or description)
        if grep -q "^name:" "$cmd_file" || grep -q "^description:" "$cmd_file"; then
            pass "$basename has name or description"
        else
            fail "$basename missing name and description"
        fi
    fi
done

summary
