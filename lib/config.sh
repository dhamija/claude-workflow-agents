#!/bin/bash

# ============================================================================
# SINGLE SOURCE OF TRUTH: Workflow Configuration
# ============================================================================
#
# ALL scripts should source this file for constants and shared logic.
# When adding/removing skills, subagents, or old agents, ONLY update this file.
#
# Usage in scripts:
#   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#   source "$SCRIPT_DIR/../lib/config.sh"  # From bin/
#   # or
#   source "$REPO_ROOT/lib/config.sh"       # From scripts/
#
# ============================================================================

# Prevent multiple inclusion
[[ -n "$_WORKFLOW_CONFIG_LOADED" ]] && return 0
_WORKFLOW_CONFIG_LOADED=1

# ============================================================================
# DIRECTORIES
# ============================================================================

INSTALL_DIR="$HOME/.claude-workflow-agents"
CLAUDE_DIR="$HOME/.claude"
REPO_URL="https://github.com/dhamija/claude-workflow-agents"

# ============================================================================
# CORE SUBAGENTS (symlinked to ~/.claude/agents/)
# ============================================================================
# These are agents invoked via Task tool with isolated context.
# Only 3 subagents - others are skills (on-demand) or agent files (reference).

CORE_SUBAGENTS=(
    "code-reviewer"
    "debugger"
    "ui-debugger"
)
CORE_SUBAGENT_COUNT=${#CORE_SUBAGENTS[@]}

# ============================================================================
# WORKFLOW SKILLS (copied to ~/.claude/skills/)
# ============================================================================
# Skills loaded on-demand by Claude. 12 skills in v3.2+

WORKFLOW_SKILLS=(
    "backend"
    "brownfield"
    "code-quality"
    "debugging"
    "frontend"
    "gap-resolver"
    "llm-user-testing"
    "solution-iteration"
    "testing"
    "ux-design"
    "validation"
    "workflow"
)
WORKFLOW_SKILL_COUNT=${#WORKFLOW_SKILLS[@]}

# Build regex pattern for cleanup (used in multiple scripts)
# Creates: ^(backend|brownfield|code-quality|...)$
WORKFLOW_SKILL_REGEX="^($(IFS='|'; echo "${WORKFLOW_SKILLS[*]}"))$"

# ============================================================================
# OLD AGENT FILES (for cleanup from v2.0 and earlier)
# ============================================================================
# These were copied as files in old versions. Now they're only agent reference
# files in the repo, not installed to ~/.claude/agents/

OLD_WORKFLOW_AGENTS=(
    "acceptance-validator"
    "agentic-architect"
    "backend-engineer"
    "brownfield-analyzer"
    "change-analyzer"
    "frontend-engineer"
    "gap-analyzer"
    "implementation-planner"
    "intent-guardian"
    "project-ops"
    "test-engineer"
    "ux-architect"
    "workflow-orchestrator"
    "llm-user-architect"
)

# Build regex pattern for cleanup
OLD_AGENT_REGEX="^($(IFS='|'; echo "${OLD_WORKFLOW_AGENTS[*]}"))\.md$"

# ============================================================================
# VERSION INFORMATION
# ============================================================================

get_installed_version() {
    cat "$INSTALL_DIR/version.txt" 2>/dev/null || echo "unknown"
}

get_repo_version() {
    local repo_root="${1:-$INSTALL_DIR}"
    cat "$repo_root/version.txt" 2>/dev/null || echo "unknown"
}

# ============================================================================
# SHARED FUNCTIONS: Cleanup
# ============================================================================

# Clean up old workflow agent symlinks AND files from ~/.claude/agents/
cleanup_agents() {
    local claude_dir="${1:-$CLAUDE_DIR}"

    if [ -d "$claude_dir/agents" ]; then
        for file in "$claude_dir/agents"/*; do
            [ -e "$file" ] || continue

            if [ -L "$file" ]; then
                # Remove symlinks pointing to workflow-agents
                local target
                target=$(readlink "$file")
                if [[ "$target" == *"workflow-agents"* ]]; then
                    rm -f "$file"
                fi
            elif [ -f "$file" ]; then
                # Remove known old workflow agent files
                local filename
                filename=$(basename "$file")
                if [[ "$filename" =~ $OLD_AGENT_REGEX ]]; then
                    rm -f "$file"
                fi
            fi
        done
    fi
}

# Clean up old workflow command symlinks from ~/.claude/commands/
cleanup_commands() {
    local claude_dir="${1:-$CLAUDE_DIR}"

    if [ -d "$claude_dir/commands" ]; then
        for file in "$claude_dir/commands"/*; do
            [ -L "$file" ] || continue
            local target
            target=$(readlink "$file")
            if [[ "$target" == *"workflow-agents"* ]]; then
                rm -f "$file"
            fi
        done
    fi
}

# Clean up old workflow skill directories from ~/.claude/skills/
cleanup_skills() {
    local claude_dir="${1:-$CLAUDE_DIR}"

    if [ -d "$claude_dir/skills" ]; then
        for skill_dir in "$claude_dir/skills"/*; do
            [ -d "$skill_dir" ] || continue
            local skill_name
            skill_name=$(basename "$skill_dir")
            if [[ "$skill_name" =~ $WORKFLOW_SKILL_REGEX ]]; then
                rm -rf "$skill_dir"
            fi
        done
    fi
}

# ============================================================================
# SHARED FUNCTIONS: Installation
# ============================================================================

# Install skills from templates/skills/ to ~/.claude/skills/
install_skills() {
    local install_dir="${1:-$INSTALL_DIR}"
    local claude_dir="${2:-$CLAUDE_DIR}"

    mkdir -p "$claude_dir/skills"
    cp -r "$install_dir/templates/skills"/* "$claude_dir/skills/"
}

# Symlink core subagents to ~/.claude/agents/
install_subagents() {
    local install_dir="${1:-$INSTALL_DIR}"
    local claude_dir="${2:-$CLAUDE_DIR}"

    mkdir -p "$claude_dir/agents"

    for agent_name in "${CORE_SUBAGENTS[@]}"; do
        local agent_file="$install_dir/agents/${agent_name}.md"
        if [ -f "$agent_file" ]; then
            ln -sf "$agent_file" "$claude_dir/agents/${agent_name}.md"
        fi
    done
}

# Symlink commands to ~/.claude/commands/
install_commands() {
    local install_dir="${1:-$INSTALL_DIR}"
    local claude_dir="${2:-$CLAUDE_DIR}"

    mkdir -p "$claude_dir/commands"

    for command_file in "$install_dir/commands"/*.md; do
        [ -f "$command_file" ] || continue
        local filename
        filename=$(basename "$command_file")
        ln -sf "$command_file" "$claude_dir/commands/$filename"
    done
}

# ============================================================================
# SHARED FUNCTIONS: Verification
# ============================================================================

# Count installed subagent symlinks
count_subagents() {
    local claude_dir="${1:-$CLAUDE_DIR}"
    local count=0

    for agent in "${CORE_SUBAGENTS[@]}"; do
        if [ -L "$claude_dir/agents/${agent}.md" ]; then
            ((count++))
        fi
    done

    echo "$count"
}

# Count installed skills
count_skills() {
    local claude_dir="${1:-$CLAUDE_DIR}"
    local count=0

    for skill in "${WORKFLOW_SKILLS[@]}"; do
        if [ -d "$claude_dir/skills/$skill" ]; then
            ((count++))
        fi
    done

    echo "$count"
}

# Count installed command symlinks
count_commands() {
    local claude_dir="${1:-$CLAUDE_DIR}"
    local count=0

    if [ -d "$claude_dir/commands" ]; then
        for cmd_file in "$claude_dir/commands"/*.md; do
            [ -L "$cmd_file" ] || continue
            local target
            target=$(readlink "$cmd_file")
            if [[ "$target" == *"workflow-agents"* ]]; then
                ((count++))
            fi
        done
    fi

    echo "$count"
}

# Count zombie agents (old files that shouldn't exist)
count_zombies() {
    local claude_dir="${1:-$CLAUDE_DIR}"
    local count=0

    for agent in "${OLD_WORKFLOW_AGENTS[@]}"; do
        if [ -f "$claude_dir/agents/${agent}.md" ] || [ -L "$claude_dir/agents/${agent}.md" ]; then
            ((count++))
        fi
    done

    echo "$count"
}

# Check if workflow is enabled (has symlinks in ~/.claude/)
is_workflow_enabled() {
    local claude_dir="${1:-$CLAUDE_DIR}"
    local count
    count=$(count_subagents "$claude_dir")

    if [ "$count" -gt 0 ]; then
        return 0  # true
    else
        return 1  # false
    fi
}

# ============================================================================
# SHARED FUNCTIONS: Version cloning
# ============================================================================

clone_repo() {
    local target_dir="$1"
    local version="$2"

    case "$version" in
        master|main|dev)
            echo "Installing from: master branch (bleeding edge)"
            git clone --depth 1 --quiet "$REPO_URL" "$target_dir"
            ;;
        latest)
            echo "Installing from: latest stable release"
            local latest_tag
            latest_tag=$(git ls-remote --tags --refs --sort="v:refname" "$REPO_URL" | tail -n1 | sed 's/.*\///')
            if [ -z "$latest_tag" ]; then
                echo "Warning: No tags found, using master branch"
                git clone --depth 1 --quiet "$REPO_URL" "$target_dir"
            else
                echo "  Version: $latest_tag"
                git clone --depth 1 --branch "$latest_tag" --quiet "$REPO_URL" "$target_dir"
            fi
            ;;
        v*.*.*)
            echo "Installing from: $version"
            git clone --depth 1 --branch "$version" --quiet "$REPO_URL" "$target_dir"
            ;;
        *)
            echo "Error: Invalid version '$version'"
            echo ""
            echo "Valid options:"
            echo "  latest       - Latest stable release (default)"
            echo "  master       - Latest development version"
            echo "  v3.1.0       - Specific tagged version"
            echo ""
            return 1
            ;;
    esac
}

# ============================================================================
# COLORS (for scripts that need them)
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color
