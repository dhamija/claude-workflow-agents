#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: Agent Frontmatter"

AGENTS_DIR="$REPO_ROOT/agents"

for agent_file in "$AGENTS_DIR"/*.md; do
    if [ -f "$agent_file" ]; then
        basename="${agent_file##*/}"
        info "Checking $basename"

        # Check frontmatter exists
        if ! head -1 "$agent_file" | grep -q "^---$"; then
            fail "$basename: No frontmatter (missing opening ---)"
            continue
        fi

        # Check required fields
        assert_frontmatter_field "$agent_file" "name"
        assert_frontmatter_field "$agent_file" "description"
        assert_frontmatter_field "$agent_file" "tools"
    fi
done

summary
