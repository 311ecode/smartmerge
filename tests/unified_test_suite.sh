#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

echo "🌟 SmartMerge Unified Test Suite"
echo "================================"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📁 Test directory: $SCRIPT_DIR"

# Source and run the main test suite
echo "⚡ Sourcing main test runner..."
source "$SCRIPT_DIR/run_smartmerge_tests.sh"

echo "🚀 Starting unified test execution..."
run_smartmerge_tests

echo "🎉 Unified test suite completed!"