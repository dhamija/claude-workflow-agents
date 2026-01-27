#!/bin/bash

# Main verification script - ensures all documentation is in sync
# Used by CI and developers before committing
#
# This is a wrapper that runs the comprehensive documentation checker

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run comprehensive documentation verification
exec "$SCRIPT_DIR/verify-docs.sh"
