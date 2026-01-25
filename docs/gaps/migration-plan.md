# Migration Plan - claude-workflow-agents Gap Resolution

> **Generated**: 2026-01-25
> **Based on**: gap-analysis.md (23 identified gaps)
> **Timeline**: 2-3 weeks across 3 phases
> **Total Effort**: 29-35 hours

## Overview

This plan addresses 23 identified gaps across documentation consistency, test coverage, template accuracy, and system quality. The focus is on fixing critical documentation inconsistencies first (user-facing), then improving test coverage and quality.

## Current State

- **Agents**: 12 (consolidated from 15)
- **Commands**: 22 (consolidated from 26)
- **Documentation**: Partially updated, inconsistent counts
- **Tests**: Exist but not verified to pass
- **Templates**: May have outdated references after consolidation
- **Self-Maintenance**: System in place, needs verification

---

## Phase 0: Critical Documentation Fixes (Do Immediately)

**Goal**: Fix all count inconsistencies and broken references
**Timeline**: ~2 hours
**Risk**: High - Users see inconsistent information, tests fail
**Dependencies**: None

### Tasks

- [ ] **GAP-001**: Update agent count to 12 in README.md
  - **Effort**: S (5 min)
  - **Action**: Find/replace "11 agents" → "12 agents" in README.md
  - **Verification**: `grep -c "12 agents" README.md` should return matches
  - **Files**: `/Users/anuj/dev/claude-workflow-agents/README.md`

- [ ] **GAP-005**: Update agent count to 12 in GUIDE.md
  - **Effort**: S (5 min)
  - **Action**: Find/replace "11 agents" → "12 agents" in GUIDE.md (3 instances)
  - **Verification**: `grep -c "11 agents" GUIDE.md` should return 0
  - **Files**: `/Users/anuj/dev/claude-workflow-agents/GUIDE.md`

- [ ] **GAP-006**: Update help.md agent count
  - **Effort**: S (5 min)
  - **Action**: Change "THE 11 AGENTS" → "THE 12 AGENTS" in commands/help.md line 153
  - **Verification**: `grep "THE 12 AGENTS" commands/help.md` should match
  - **Files**: `/Users/anuj/dev/claude-workflow-agents/commands/help.md`

- [ ] **GAP-002**: Fix command count in STATE.md
  - **Effort**: S (5 min)
  - **Action**: Change "25" → "22" in STATE.md line 11
  - **Verification**: `grep "Commands | 22" STATE.md` should match
  - **Files**: `/Users/anuj/dev/claude-workflow-agents/STATE.md`

- [ ] **GAP-004**: Verify STATE.md agent count logic
  - **Effort**: S (10 min)
  - **Action**:
    1. Check if STATE.md is hand-maintained or auto-updated
    2. Fix count from 14 → 12 in line 10
    3. Verify `scripts/update-claude-md.sh` logic if auto-updated
  - **Verification**: `grep "Agents | 12" STATE.md` should match
  - **Files**:
    - `/Users/anuj/dev/claude-workflow-agents/STATE.md`
    - `/Users/anuj/dev/claude-workflow-agents/scripts/update-claude-md.sh`

- [ ] **GAP-003**: Fix test file references to help.md
  - **Effort**: S (10 min)
  - **Action**:
    1. Update test_help_coverage.sh: `agent-wf-help.md` → `help.md`
    2. Update scripts/verify.sh if needed
  - **Verification**: `grep -r "agent-wf-help" tests/ scripts/` should only find deprecation warnings
  - **Files**:
    - `/Users/anuj/dev/claude-workflow-agents/tests/consistency/test_help_coverage.sh`

- [ ] **GAP-008**: Fix test command list
  - **Effort**: S (5 min)
  - **Action**: Update test_commands_exist.sh: "agent-wf-help" → "help" in REQUIRED_COMMANDS array
  - **Verification**: `grep '"help"' tests/structural/test_commands_exist.sh` should match
  - **Files**: `/Users/anuj/dev/claude-workflow-agents/tests/structural/test_commands_exist.sh`

### Milestone: Phase 0 Complete

**Success Criteria**:
- [ ] All documentation shows consistent counts (12 agents, 22 commands)
- [ ] Tests reference correct files
- [ ] `./scripts/verify.sh` passes with 0 errors, 0 warnings

**Verification Commands**:
```bash
./scripts/verify.sh  # Should show: Agents: 12, Commands: 22, Errors: 0, Warnings: 0
grep -r "11 agents" *.md  # Should return nothing
grep -r "agent-wf-help" tests/ scripts/ | grep -v "deprecation"  # Should return nothing
```

---

## Phase 1: Test Coverage & Verification (Week 1)

**Goal**: Verify system actually works, fix broken tests
**Timeline**: 3-5 days
**Risk**: Medium - Unknown test failures may exist
**Dependencies**: Phase 0 complete

### Test Verification

- [ ] **GAP-007**: Run full test suite and document results
  - **Effort**: M (1 hour)
  - **Action**:
    1. Execute: `./tests/run_all_tests.sh`
    2. Document all failures in `test-results.md`
    3. Create issues for each critical failure
    4. Fix blocking issues immediately
  - **Verification**: Exit code 0 = all tests pass
  - **Note**: This reveals current state, not a fix

- [ ] **GAP-009**: Add deprecation check to tests
  - **Effort**: M (2 hours)
  - **Action**:
    1. Create `tests/consistency/test_deprecated_commands.sh`
    2. Verify deprecated commands (sync, docs, llm, mcp, enforce) exist
    3. Verify they show deprecation warnings when invoked
    4. Verify they redirect to `/project` correctly
  - **Verification**: New test passes
  - **Files**: New file: `tests/consistency/test_deprecated_commands.sh`

### Template Accuracy

- [ ] **GAP-012**: Audit templates for outdated references
  - **Effort**: L (4 hours)
  - **Action**:
    1. Grep all templates for old agent names:
       - `ci-cd-engineer` → `project-ops`
       - `project-maintainer` → `project-ops`
       - `project-enforcer` → `project-ops`
       - `documentation-engineer` → `project-ops`
    2. Grep for old command names:
       - `/sync` → `/project sync`
       - `/docs` → `/project docs`
       - `/llm` → `/project ai`
       - `/mcp` → `/project mcp`
       - `/enforce` → `/project setup`
    3. Create list of needed updates in `template-audit-results.md`
    4. Update templates systematically
    5. Test one template by generating project and verifying output
  - **Verification**: Generate test project, verify no outdated references
  - **Files**:
    - `templates/project/CLAUDE.md.template`
    - `templates/project/FEATURE.md.template`
    - `templates/docs/*.template` (if exist)
    - `templates/infrastructure/*.template`
    - `templates/ci/*.template`

### Integration Testing

- [ ] **GAP-013**: Test installation end-to-end
  - **Effort**: M (1 hour)
  - **Action**:
    1. Fresh clone to /tmp/test-install
    2. Run: `./install.sh --user`
    3. Verify agents/commands copied to ~/.claude/
    4. Count: `ls ~/.claude/agents/*.md | wc -l` should be 12
    5. Count: `ls ~/.claude/commands/*.md | wc -l` should be 22
    6. Run: `./install.sh --project` in test directory
    7. Verify CLAUDE.md created in test directory
  - **Verification**: All files installed correctly, no errors
  - **Cleanup**: `rm -rf /tmp/test-install ~/.claude/agents ~/.claude/commands` after test

- [ ] **GAP-011**: Add design system preset tests
  - **Effort**: M (1 hour)
  - **Action**:
    1. Create `tests/structural/test_design_presets.sh`
    2. Verify 5 preset files exist:
       - modern-clean
       - minimal
       - playful
       - corporate
       - glassmorphism
    3. Verify each has required sections: colors, typography, components
    4. Verify JSON is valid
  - **Verification**: New test passes
  - **Files**: New file: `tests/structural/test_design_presets.sh`

### Milestone: Phase 1 Complete

**Success Criteria**:
- [ ] Test suite passes 100% (or known failures documented)
- [ ] Templates verified accurate (no outdated references)
- [ ] Installation works end-to-end
- [ ] Design presets validated

**Verification Commands**:
```bash
./tests/run_all_tests.sh  # All green (or known failures documented)
./install.sh --user --force  # Succeeds
ls ~/.claude/agents/*.md | wc -l  # Returns 12
ls ~/.claude/commands/*.md | wc -l  # Returns 22
grep -r "ci-cd-engineer\|project-maintainer\|documentation-engineer" templates/ | grep -v MIGRATION.md  # Returns nothing
```

---

## Phase 2: Quality & Documentation Improvements (Week 2)

**Goal**: Improve docs, add missing tests, enhance quality
**Timeline**: 3-5 days
**Risk**: Low - Improvements, not fixes
**Dependencies**: Phase 1 complete

### Documentation Audit

- [ ] **GAP-010**: Verify README TOC links
  - **Effort**: M (30 min)
  - **Action**:
    1. Extract all `[text](#anchor)` links from README.md
    2. Verify each anchor exists in README.md
    3. Fix broken anchors (update link or add anchor)
    4. Test by clicking links in rendered markdown
  - **Verification**: All TOC links navigate correctly
  - **Files**: `/Users/anuj/dev/claude-workflow-agents/README.md`

- [ ] **GAP-014**: Review MIGRATION.md completeness
  - **Effort**: M (1 hour)
  - **Action**:
    1. Read MIGRATION.md fully
    2. Ensure covers 15→12 agent consolidation
    3. Ensure covers 26→22 command consolidation
    4. Add examples of upgrading existing projects if missing
    5. Verify all commands in "Old → New" table are correct
  - **Verification**: MIGRATION.md is comprehensive and accurate
  - **Files**: `/Users/anuj/dev/claude-workflow-agents/MIGRATION.md`

- [ ] **GAP-016**: Audit EXAMPLES.md for outdated commands
  - **Effort**: M (1 hour)
  - **Action**:
    1. Search EXAMPLES.md for deprecated command usage:
       - `/sync` → `/project sync`
       - `/docs` → `/project docs`
       - `/llm` → `/project ai`
       - `/mcp` → `/project mcp`
       - `/enforce` → `/project setup`
    2. Update examples to use new syntax
    3. Add note about backward compatibility in introduction
  - **Verification**: All examples use current command syntax
  - **Files**: `/Users/anuj/dev/claude-workflow-agents/EXAMPLES.md`

- [ ] **GAP-018**: Review PATTERNS.md completeness
  - **Effort**: M (1 hour)
  - **Action**:
    1. Read PATTERNS.md fully
    2. Verify covers common patterns:
       - Greenfield workflow
       - Brownfield workflow
       - Change management
       - Parallel development
       - Save/restore state
    3. Add any missing patterns
    4. Ensure examples are current (no outdated commands)
  - **Verification**: PATTERNS.md is comprehensive
  - **Files**: `/Users/anuj/dev/claude-workflow-agents/PATTERNS.md`

### Test Coverage

- [ ] **GAP-015**: Generate test coverage report
  - **Effort**: M (2 hours)
  - **Action**:
    1. List all testable components:
       - 12 agents (existence, structure, frontmatter)
       - 22 commands (existence, structure, frontmatter)
       - Help topics (coverage, accuracy)
       - Templates (validity, completeness)
       - Scripts (functionality, error handling)
    2. Document what's tested vs untested
    3. Create coverage report: `docs/test-coverage-report.md`
    4. Identify critical gaps
    5. Prioritize new tests
  - **Verification**: Coverage report shows >80% coverage
  - **Dependencies**: GAP-007 (test results)
  - **Files**: New file: `docs/test-coverage-report.md`

- [ ] **GAP-017**: Update MANUAL_TEST_CHECKLIST.md
  - **Effort**: L (2 hours)
  - **Action**:
    1. Read existing MANUAL_TEST_CHECKLIST.md
    2. Update to cover current 12 agents
    3. Update to cover current 22 commands
    4. Add integration test scenarios:
       - Greenfield: Full /analyze → /plan → /implement flow
       - Brownfield: /audit → /gap → /improve flow
       - Change management: /change → /update → /replan flow
    5. Add regression test scenarios
  - **Verification**: MANUAL_TEST_CHECKLIST.md is current
  - **Files**: `/Users/anuj/dev/claude-workflow-agents/MANUAL_TEST_CHECKLIST.md`

### Script Quality

- [ ] **GAP-019**: Audit scripts for error handling
  - **Effort**: L (3 hours)
  - **Action**:
    1. Review `scripts/verify.sh`:
       - Add error handling for missing files
       - Add user-friendly error messages
       - Test error scenarios
    2. Review `scripts/install.sh`:
       - Add error handling for missing directories
       - Add validation of source files before copy
       - Test error scenarios
    3. Review `scripts/update-claude-md.sh`:
       - Add error handling
       - Verify backup before overwrite
    4. Review `scripts/update-system-docs.sh`:
       - Add error handling
  - **Verification**: Scripts handle errors gracefully with helpful messages
  - **Files**:
    - `/Users/anuj/dev/claude-workflow-agents/scripts/verify.sh`
    - `/Users/anuj/dev/claude-workflow-agents/scripts/install.sh`
    - `/Users/anuj/dev/claude-workflow-agents/scripts/update-claude-md.sh`
    - `/Users/anuj/dev/claude-workflow-agents/scripts/update-system-docs.sh`

### Milestone: Phase 2 Complete

**Success Criteria**:
- [ ] All documentation reviewed and accurate
- [ ] Coverage report shows >80% test coverage
- [ ] Scripts handle errors gracefully
- [ ] Manual test checklist is current

**Verification Commands**:
```bash
# Verify all links work (manual check in rendered markdown)

# Coverage documented
cat docs/test-coverage-report.md  # Shows what's tested

# Scripts handle errors
./scripts/install.sh --invalid-flag  # Shows helpful error, not cryptic failure
./scripts/verify.sh /nonexistent/path  # Shows helpful error
```

---

## Phase 3: Polish & Community (Backlog)

**Goal**: Prepare for open-source contributions
**Timeline**: When time permits
**Risk**: None - Nice to have
**Dependencies**: None (can do anytime)

- [ ] **GAP-022**: Add VERSION file
  - **Effort**: S (15 min)
  - **Action**:
    1. Create `VERSION` file with "2.0.0"
    2. Update README.md to reference version
    3. Update install.sh to show version on execution
  - **Verification**: `cat VERSION` shows 2.0.0
  - **Files**: New file: `VERSION`

- [ ] **GAP-021**: Create CHANGELOG.md
  - **Effort**: M (1 hour)
  - **Action**:
    1. Create CHANGELOG.md following Keep a Changelog format
    2. Backfill from STATE.md:
       - v2.0.0: Consolidation (15→12 agents, 26→22 commands)
       - v1.x: Previous changes from STATE.md
    3. Add version numbers to releases
  - **Verification**: CHANGELOG.md exists and is comprehensive
  - **Files**: New file: `CHANGELOG.md`

- [ ] **GAP-020**: Create CONTRIBUTING.md
  - **Effort**: M (2 hours)
  - **Action**:
    1. Create CONTRIBUTING.md with:
       - How to add new agents (structure, frontmatter, tools)
       - How to add new commands (structure, frontmatter, invocation)
       - Self-maintenance checklist (what to update when adding agent/command)
       - Testing requirements (what tests to add)
       - Documentation requirements (what docs to update)
       - PR process
    2. Reference CLAUDE.md maintenance headers
  - **Verification**: CONTRIBUTING.md is comprehensive
  - **Files**: New file: `CONTRIBUTING.md`

- [ ] **GAP-023**: Enhance templates with examples
  - **Effort**: M (2 hours)
  - **Action**:
    1. Add inline comments to templates explaining each section
    2. Add example values (commented out) showing what to fill in
    3. Make templates more self-documenting
  - **Verification**: Template comments are helpful
  - **Dependencies**: GAP-012 (template audit)
  - **Files**:
    - `templates/project/CLAUDE.md.template`
    - `templates/project/FEATURE.md.template`
    - All other templates

### Milestone: Phase 3 Complete

**Success Criteria**:
- [ ] Project ready for community contributions
- [ ] Versioning in place
- [ ] Change history documented

**Verification Commands**:
```bash
cat VERSION  # Shows 2.0.0
cat CHANGELOG.md  # Shows version history
cat CONTRIBUTING.md  # Shows how to contribute
```

---

## Dependencies Graph

```
Phase 0 (Critical)
├─ GAP-001 → README count
├─ GAP-002 → STATE count
├─ GAP-003 → Test refs
├─ GAP-004 → STATE logic
├─ GAP-005 → GUIDE count
├─ GAP-006 → Help count
└─ GAP-008 → Test list
     │
     ├─→ Phase 1 (Foundation)
     │   ├─ GAP-007 → Run tests (reveals status)
     │   │    └─→ GAP-015 → Coverage report
     │   ├─ GAP-009 → Deprecation tests
     │   ├─ GAP-011 → Design preset tests
     │   ├─ GAP-012 → Template audit
     │   │    └─→ GAP-023 → Template examples (Phase 3)
     │   └─ GAP-013 → Test install
     │        │
     │        └─→ Phase 2 (Quality)
     │            ├─ GAP-010 → README links
     │            ├─ GAP-014 → MIGRATION review
     │            ├─ GAP-016 → EXAMPLES audit
     │            ├─ GAP-017 → Manual test checklist
     │            ├─ GAP-018 → PATTERNS review
     │            └─ GAP-019 → Script error handling
     │                 │
     │                 └─→ Phase 3 (Community)
     │                     ├─ GAP-020 → CONTRIBUTING.md
     │                     ├─ GAP-021 → CHANGELOG.md
     │                     ├─ GAP-022 → VERSION file
     │                     └─ GAP-023 → Template examples
```

---

## Effort Estimates

| Phase | Tasks | Total Effort | Timeline |
|-------|-------|--------------|----------|
| **Phase 0 (Critical)** | 7 tasks | ~2 hours | Immediate (today) |
| **Phase 1 (Foundation)** | 5 tasks | 12-15 hours | Week 1 (3-5 days) |
| **Phase 2 (Quality)** | 8 tasks | 10-12 hours | Week 2 (3-5 days) |
| **Phase 3 (Community)** | 4 tasks | 5-6 hours | Backlog (when time permits) |
| **TOTAL** | 24 tasks | **29-35 hours** | **2-3 weeks** |

### Breakdown by Effort Size

- **Small (S)**: 10 tasks × ~5-10 min = 1-2 hours
- **Medium (M)**: 11 tasks × ~1-2 hours = 11-22 hours
- **Large (L)**: 3 tasks × ~3-4 hours = 9-12 hours

---

## Risks & Mitigations

### Risk 1: Tests Fail When Run (GAP-007)
- **Probability**: Medium
- **Impact**: High (blocks Phase 1)
- **Mitigation**:
  - Run tests early in Phase 0 (or immediately after Phase 0)
  - Document failures immediately
  - Fix critical failures before proceeding to rest of Phase 1
  - Non-critical failures can be tracked as issues

### Risk 2: Templates Have Many Outdated References (GAP-012)
- **Probability**: Medium
- **Impact**: Medium (more work in Phase 1)
- **Mitigation**:
  - Use grep/sed for batch updates (faster than manual)
  - Test one template fully before updating others
  - Get user feedback on generated output
  - Keep backup of templates before changes

### Risk 3: Installation Script Broken (GAP-013)
- **Probability**: Low
- **Impact**: High (users can't install)
- **Mitigation**:
  - Test early in Phase 1
  - Fix immediately if broken (top priority)
  - Add to CI/manual checklist for future changes
  - Test both --user and --project modes

### Risk 4: Coverage Report Shows Major Gaps (GAP-015)
- **Probability**: Medium
- **Impact**: Medium (more work in Phase 2)
- **Mitigation**:
  - Prioritize gaps by criticality (user-facing > internal)
  - Move low-priority gaps to Phase 3 or backlog
  - Focus on user-facing functionality first
  - Accept some gaps (perfect coverage not required)

### Risk 5: Time Constraints
- **Probability**: Medium
- **Impact**: Medium (plan not completed)
- **Mitigation**:
  - Phase 0 is mandatory (2 hours)
  - Phase 1 is high priority (can be done over multiple sessions)
  - Phase 2 can be done partially (prioritize docs over scripts)
  - Phase 3 is optional (can be skipped entirely)

---

## Quick Wins

Can be done in parallel with phased approach for immediate impact:

1. **Phase 0 Critical Fixes** - 2 hours, zero dependencies, maximum user impact
2. **GAP-007: Run Test Suite** - 1 hour, reveals current state immediately
3. **GAP-013: Test Installation** - 1 hour, verifies core functionality
4. **GAP-022: Add VERSION File** - 15 minutes, professional polish

Total quick wins: ~4 hours, high visibility improvements

---

## Rollback Plan

If issues discovered during implementation:

### Phase 0
- **Changes**: Documentation-only text changes
- **Rollback**: Revert individual file commits via git
- **Risk**: Very low (just text changes)

### Phase 1
- **Changes**: Test files, templates
- **Rollback**:
  - Tests: Can disable failing tests temporarily
  - Templates: Keep backup before updates, can restore
- **Risk**: Low (changes are isolated)

### Phase 2
- **Changes**: Documentation improvements, new test files
- **Rollback**:
  - Docs: Can revert commits
  - Tests: Can disable new tests
  - Scripts: Keep backup before changes
- **Risk**: Very low (changes are additive)

### Phase 3
- **Changes**: New files (CONTRIBUTING, CHANGELOG, VERSION)
- **Rollback**: Simply delete new files
- **Risk**: None (all optional files)

---

## Success Criteria

### Phase 0 Success ✅
- [ ] `./scripts/verify.sh` passes with 0 errors, 0 warnings
- [ ] `grep -r "11 agents" *.md` returns nothing (excluding MIGRATION.md)
- [ ] All documentation shows "12 agents, 22 commands"
- [ ] Tests reference correct file names (help.md not agent-wf-help.md)

### Phase 1 Success ✅
- [ ] `./tests/run_all_tests.sh` returns exit code 0 (or failures documented)
- [ ] Installation script works on clean machine
- [ ] Templates generate valid project files (no outdated references)
- [ ] Design presets validated (5 presets exist and are valid)

### Phase 2 Success ✅
- [ ] All documentation reviewed and accurate
- [ ] Coverage report shows >80% test coverage
- [ ] Scripts handle errors gracefully with helpful messages
- [ ] Manual test checklist is current

### Phase 3 Success ✅
- [ ] CONTRIBUTING.md exists and is comprehensive
- [ ] CHANGELOG.md tracks versions
- [ ] VERSION file shows 2.0.0
- [ ] Project ready for community PRs

---

## Next Steps

### Immediate (Today - Phase 0)
```bash
# 1. Fix documentation counts
sed -i 's/11 agents/12 agents/g' README.md GUIDE.md
sed -i 's/THE 11 AGENTS/THE 12 AGENTS/g' commands/help.md
sed -i 's/Commands | 25/Commands | 22/g' STATE.md
sed -i 's/Agents | 14/Agents | 12/g' STATE.md

# 2. Fix test references
sed -i 's/agent-wf-help\.md/help.md/g' tests/consistency/test_help_coverage.sh
sed -i 's/"agent-wf-help"/"help"/g' tests/structural/test_commands_exist.sh

# 3. Verify
./scripts/verify.sh  # Should show 0 errors, 0 warnings
```

### This Week (Phase 1)
```bash
# 1. Run tests and document results
./tests/run_all_tests.sh > test-results.md 2>&1

# 2. Test installation
cd /tmp && git clone <repo> test-install && cd test-install
./install.sh --user
ls ~/.claude/agents/*.md | wc -l  # Should be 12
ls ~/.claude/commands/*.md | wc -l  # Should be 22

# 3. Audit templates
grep -r "ci-cd-engineer\|project-maintainer\|documentation-engineer" templates/
# Document findings, update systematically
```

### Next Week (Phase 2)
- Review all documentation files
- Generate test coverage report
- Improve script error handling
- Update manual test checklist
