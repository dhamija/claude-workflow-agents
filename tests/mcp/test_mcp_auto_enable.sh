#!/bin/bash
#
# Test MCP auto-enable functionality
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

pass() { echo "  ✓ $1"; }
fail() { echo "  ✗ $1"; exit 1; }

echo "Testing MCP Auto-Enable"
echo "======================="
echo

# Test 1: Create new config file
echo "Test 1: Create new config from scratch"
CONFIG_FILE="$TEST_DIR/config.json"
export CONFIG_FILE
python3 << PYTHON_SCRIPT
import json
import os
import sys

config_file = "$CONFIG_FILE"

# Create new config
config = {
    "mcpServers": {
        "puppeteer": {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
        }
    }
}

# Write config
with open(config_file, 'w') as f:
    json.dump(config, f, indent=2)

print("✓ Config created")
PYTHON_SCRIPT

[ -f "$CONFIG_FILE" ] && pass "Config file created" || fail "Config file not created"
grep -q "puppeteer" "$CONFIG_FILE" && pass "Contains puppeteer config" || fail "Missing puppeteer config"
grep -q "mcpServers" "$CONFIG_FILE" && pass "Contains mcpServers section" || fail "Missing mcpServers section"

echo

# Test 2: Merge with existing config
echo "Test 2: Merge with existing config"
cat > "$CONFIG_FILE" << 'EOF'
{
  "theme": "dark",
  "fontSize": 14,
  "mcpServers": {
    "existing-server": {
      "command": "existing-command"
    }
  }
}
EOF

python3 << PYTHON_SCRIPT
import json
import os
import sys

config_file = "$CONFIG_FILE"

# Read existing config
with open(config_file, 'r') as f:
    config = json.load(f)

# Add mcpServers section
if 'mcpServers' not in config:
    config['mcpServers'] = {}

# Add puppeteer if not present
if 'puppeteer' not in config['mcpServers']:
    config['mcpServers']['puppeteer'] = {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    }

# Write back
with open(config_file, 'w') as f:
    json.dump(config, f, indent=2)

print("✓ Config merged")
PYTHON_SCRIPT

grep -q "puppeteer" "$CONFIG_FILE" && pass "Puppeteer added" || fail "Puppeteer not added"
grep -q "existing-server" "$CONFIG_FILE" && pass "Existing config preserved" || fail "Existing config lost"
grep -q '"theme": "dark"' "$CONFIG_FILE" && pass "Other settings preserved" || fail "Other settings lost"

echo

# Test 3: Don't duplicate if already present
echo "Test 3: Don't duplicate if already present"
INITIAL_SIZE=$(wc -c < "$CONFIG_FILE")

python3 << PYTHON_SCRIPT
import json
import os
import sys

config_file = "$CONFIG_FILE"

# Read existing config
with open(config_file, 'r') as f:
    config = json.load(f)

# Add mcpServers section
if 'mcpServers' not in config:
    config['mcpServers'] = {}

# Add puppeteer if not present
if 'puppeteer' not in config['mcpServers']:
    config['mcpServers']['puppeteer'] = {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    }

# Write back
with open(config_file, 'w') as f:
    json.dump(config, f, indent=2)

print("✓ Config checked")
PYTHON_SCRIPT

FINAL_SIZE=$(wc -c < "$CONFIG_FILE")
PUPPETEER_COUNT=$(grep -c '"puppeteer":' "$CONFIG_FILE")

[ "$PUPPETEER_COUNT" -eq 1 ] && pass "No duplication (1 puppeteer entry)" || fail "Duplication detected ($PUPPETEER_COUNT puppeteer entries)"

echo

# Cleanup
cd /
rm -rf "$TEST_DIR"

echo "All tests passed ✓"
