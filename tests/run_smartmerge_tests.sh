#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

run_smartmerge_tests() {
  echo "======================"
  echo "STARTING TEST SUITE"
  echo "======================"

  # Basic tests
  test_smartmerge_fast_forward
  test_smartmerge_conflict_resolution
  test_smartmerge_squash_merge

  # Complex tests
  test_complex_smartmerge_sequential
  test_complex_smartmerge_diverged

  echo "======================"
  echo "TEST SUITE COMPLETED"
  echo "======================"
}

[ "${BASH_SOURCE[0]}" == "${0}" ] && run_smartmerge_tests
