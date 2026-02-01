#!/bin/bash

# Check if version bump is needed based on changed files
# This script should be run as part of pre-commit or CI

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Checking if version bump is needed..."

# Get list of changed files (staged for commit)
CHANGED_FILES=$(git diff --cached --name-only)

# Check for template changes
TEMPLATE_CHANGED=false
if echo "$CHANGED_FILES" | grep -q "templates/project/.*\.template"; then
    TEMPLATE_CHANGED=true
    echo -e "${YELLOW}⚠️  Template files changed${NC}"
fi

# Check for skill changes that affect workflow
WORKFLOW_SKILL_CHANGED=false
if echo "$CHANGED_FILES" | grep -q "templates/skills/workflow/"; then
    WORKFLOW_SKILL_CHANGED=true
    echo -e "${YELLOW}⚠️  Workflow skill changed${NC}"
fi

# Check for workflow-affecting agent changes
WORKFLOW_AGENT_CHANGED=false
if echo "$CHANGED_FILES" | grep -E "agents/(intent-guardian|ux-architect|iteration-analyzer|change-analyzer)\.md"; then
    WORKFLOW_AGENT_CHANGED=true
    echo -e "${YELLOW}⚠️  Workflow-affecting agent changed${NC}"
fi

# Check if version.txt was updated
VERSION_UPDATED=false
if echo "$CHANGED_FILES" | grep -q "version.txt"; then
    VERSION_UPDATED=true
    echo -e "${GREEN}✓ version.txt updated${NC}"
fi

# Determine if version bump is required
VERSION_BUMP_REQUIRED=false
if [ "$TEMPLATE_CHANGED" = true ] || [ "$WORKFLOW_SKILL_CHANGED" = true ] || [ "$WORKFLOW_AGENT_CHANGED" = true ]; then
    VERSION_BUMP_REQUIRED=true
fi

# Check for version bump compliance
if [ "$VERSION_BUMP_REQUIRED" = true ]; then
    if [ "$VERSION_UPDATED" = false ]; then
        echo ""
        echo -e "${RED}❌ ERROR: Version bump required but not done!${NC}"
        echo ""
        echo "Changes detected that require a version bump:"
        [ "$TEMPLATE_CHANGED" = true ] && echo "  • Template files modified"
        [ "$WORKFLOW_SKILL_CHANGED" = true ] && echo "  • Workflow skill modified"
        [ "$WORKFLOW_AGENT_CHANGED" = true ] && echo "  • Workflow agents modified"
        echo ""
        echo "These changes require users to run workflow-patch."
        echo "Please bump the version in:"
        echo "  1. version.txt"
        echo "  2. templates/project/*.template (workflow.version field)"
        echo "  3. CHANGELOG.md"
        echo ""
        echo "See VERSION-BUMP-PROTOCOL.md for details."
        exit 1
    else
        # Check if CHANGELOG was also updated
        if ! echo "$CHANGED_FILES" | grep -q "CHANGELOG.md"; then
            echo -e "${YELLOW}⚠️  Warning: version.txt updated but CHANGELOG.md not updated${NC}"
            echo "Don't forget to document changes in CHANGELOG.md"
        fi
        echo -e "${GREEN}✓ Version bump detected for workflow changes${NC}"
    fi
else
    if [ "$VERSION_UPDATED" = true ]; then
        echo -e "${YELLOW}Note: Version bumped but no workflow-affecting changes detected.${NC}"
        echo "Version bumps are only required for:"
        echo "  • Template changes"
        echo "  • Workflow skill/agent changes"
        echo "  • Breaking changes"
    else
        echo -e "${GREEN}✓ No version bump needed (no workflow-affecting changes)${NC}"
    fi
fi

echo ""
echo "Version bump check complete."