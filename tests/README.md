# Test Suite for Claude Workflow Agents

Comprehensive automated and manual testing for the claude-workflow-agents system.

## Quick Start

```bash
# Run all automated tests
./tests/run_all_tests.sh

# Run specific category
./tests/run_all_tests.sh --structural
./tests/run_all_tests.sh --content
./tests/run_all_tests.sh --consistency
./tests/run_all_tests.sh --documentation
./tests/run_all_tests.sh --integration
```

## Test Categories

### 1. Structural Tests (`structural/`)
Verify files and directories exist in correct locations.

- **test_agents_exist.sh** - All 11 required agents present
- **test_commands_exist.sh** - All required commands present
- **test_docs_exist.sh** - Documentation files exist
- **test_directory_structure.sh** - Template directories exist

### 2. Content Tests (`content/`)
Verify file contents are valid and complete.

- **test_agent_frontmatter.sh** - Agents have valid frontmatter (name, description, tools)
- **test_agent_sections.sh** - Agents have required sections (WHEN TO USE, OUTPUTS)
- **test_command_frontmatter.sh** - Commands have valid frontmatter
- **test_template_completeness.sh** - CLAUDE.md template has all required sections

### 3. Consistency Tests (`consistency/`)
Verify cross-references and consistency across files.

- **test_agent_references.sh** - Template references valid agents
- **test_help_coverage.sh** - Help command mentions all agents and topics
- **test_doc_links.sh** - Internal links in docs are valid

### 4. Documentation Tests (`documentation/`)
Verify documentation quality and completeness.

- **test_readme_sections.sh** - README has essential sections
- **test_guide_accuracy.sh** - GUIDE is concise and complete
- **test_examples_valid.sh** - EXAMPLES has variety and conversation format

### 5. Integration Tests (`integration/`)
Verify system components work together.

- **test_install_script.sh** - Install script has required features
- **test_workflow_simulation.sh** - Agent workflow chain is complete

## Manual Testing

See `MANUAL_TEST_CHECKLIST.md` for manual tests that require Claude Code.

Tests include:
- Greenfield workflow (new projects)
- Brownfield workflow (existing codebases)
- Change management
- Commands (/agent-wf-help, /review, etc.)
- Debugging
- Code review
- Natural language understanding

## Test Infrastructure

### test_utils.sh
Shared testing utilities with functions:
- `pass()`, `fail()`, `skip()`, `warn()`, `info()`
- `section()` - Test section headers
- `summary()` - Test result summary
- `assert_file_exists()` - File existence check
- `assert_dir_exists()` - Directory existence check
- `assert_file_contains()` - Pattern matching in files
- `assert_frontmatter_field()` - YAML frontmatter validation

### run_all_tests.sh
Master test runner that:
- Runs all test categories in sequence
- Supports running individual categories
- Provides colored output
- Returns exit code 1 if any tests fail

## Test Reporting

### TEST_REPORT_TEMPLATE.md
Template for documenting test results including:
- Automated test results by category
- Manual test results
- Issues found (Critical/High/Medium)
- Recommendations
- Sign-off checklist

## Test Results (Latest)

Run `./tests/run_all_tests.sh` to see current status.

Expected results:
- **Structural**: 4 tests with ~35 checks
- **Content**: 4 tests with ~30 checks
- **Consistency**: 3 tests with ~15 checks
- **Documentation**: 3 tests with ~15 checks
- **Integration**: 2 tests with ~20 checks

**Total**: ~115 automated checks across 16 test files

## Common Issues

### Pattern Not Found Errors
Some tests use case-sensitive grep. If you see failures like "Greenfield\|New Project", check that the exact capitalization exists in the file.

### Missing Directories
Template directories must exist even if empty. Run:
```bash
mkdir -p templates/docs/plans/{overview,features}
mkdir -p templates/docs/changes
```

### Bash Version Compatibility
Scripts use POSIX-compatible syntax. If you see "bad substitution" errors, ensure you're using bash (not sh).

## Adding New Tests

1. Create test file in appropriate category directory
2. Name it `test_*.sh`
3. Source test_utils.sh
4. Use test utility functions
5. Call `summary` at end
6. Make it executable: `chmod +x your_test.sh`

Example:
```bash
#!/bin/bash
source "$(dirname "$0")/../test_utils.sh"

section "Test: My Feature"

assert_file_exists "$REPO_ROOT/my_file.txt"
assert_file_contains "$REPO_ROOT/my_file.txt" "expected pattern"

summary
```

## Continuous Integration

To use in CI:
```bash
#!/bin/bash
set -e

# Run automated tests
./tests/run_all_tests.sh

# Exit with test suite exit code
exit $?
```

## Test Coverage

| Component | Tested | Coverage |
|-----------|--------|----------|
| Agent files | ✓ | 100% (11/11) |
| Command files | ✓ | 100% (11/11) |
| Documentation | ✓ | 100% (4/4) |
| Templates | ✓ | 100% |
| Install script | ✓ | Functionality |
| Workflow chain | ✓ | L1+L2+Brownfield |
| Cross-references | ✓ | Agents, Help, Links |

## Known Limitations

Automated tests **cannot** verify:
- Actual functionality with Claude Code
- Natural language understanding
- Agent orchestration logic
- Real-world workflows
- User experience

For these, use **MANUAL_TEST_CHECKLIST.md**.

## Support

If tests fail:
1. Read the error message carefully
2. Check which pattern/file is missing
3. Fix the issue
4. Re-run tests
5. If stuck, check this README for common issues
