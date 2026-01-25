#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Agent Content Sections"

AGENTS_DIR="$REPO_ROOT/agents"

for agent_file in "$AGENTS_DIR"/*.md; do
    if [ -f "$agent_file" ]; then
        basename="${agent_file##*/}"
        info "Checking $basename content"

        # Check description has WHEN TO USE
        if grep -q "WHEN TO USE" "$agent_file"; then
            pass "$basename has WHEN TO USE"
        else
            fail "$basename missing WHEN TO USE in description"
        fi

        # Check description has WHAT IT DOES or similar
        if grep -qE "WHAT IT DOES|OUTPUTS|Creates:" "$agent_file"; then
            pass "$basename has output description"
        else
            warn "$basename might be missing output description"
        fi
    fi
done

summary
