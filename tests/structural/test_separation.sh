#!/bin/bash

source "$(dirname "$0")/../test_utils.sh"

section "Test: Repo vs Template Separation"

# Repo files exist
[ -f "$REPO_ROOT/CLAUDE.md" ] && pass "Repo CLAUDE.md exists" || fail "Repo CLAUDE.md missing"
[ -f "$REPO_ROOT/README.md" ] && pass "Repo README.md exists" || fail "Repo README.md missing"
[ -f "$REPO_ROOT/CHANGELOG.md" ] && pass "Repo CHANGELOG.md exists" || fail "Repo CHANGELOG.md missing"

# Templates exist
[ -f "$REPO_ROOT/templates/project/CLAUDE.md.template" ] && pass "CLAUDE.md template exists" || fail "CLAUDE.md template missing"
[ -f "$REPO_ROOT/templates/project/README.md.template" ] && pass "README.md template exists" || fail "README.md template missing"
[ -f "$REPO_ROOT/templates/release/CHANGELOG.md.template" ] && pass "CHANGELOG template exists" || fail "CHANGELOG template missing"
[ -f "$REPO_ROOT/templates/infrastructure/scripts/verify.sh.template" ] && pass "verify.sh template exists" || fail "verify.sh template missing"
[ -f "$REPO_ROOT/templates/infrastructure/github/workflows/verify.yml.template" ] && pass "verify.yml template exists" || fail "verify.yml template missing"

# Repo CLAUDE.md mentions it's for repo
grep -q "THIS repo\|THIS repository" "$REPO_ROOT/CLAUDE.md" && pass "Repo CLAUDE.md identifies itself" || fail "Repo CLAUDE.md doesn't identify as repo file"

# Template CLAUDE.md has workflow markers
grep -q "workflow:" "$REPO_ROOT/templates/project/CLAUDE.md.template" && pass "Template has workflow marker" || fail "Template missing workflow marker"

# Docs templates exist
[ -f "$REPO_ROOT/templates/docs/intent/product-intent.md.template" ] && pass "product-intent template exists" || fail "product-intent template missing"
[ -f "$REPO_ROOT/templates/docs/ux/user-journeys.md.template" ] && pass "user-journeys template exists" || fail "user-journeys template missing"
[ -f "$REPO_ROOT/templates/docs/architecture/agent-design.md.template" ] && pass "agent-design template exists" || fail "agent-design template missing"

summary
