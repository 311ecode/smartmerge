#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

runAll_smartmerge_tests(){
  # Fix for localization issue with decimal points
  # export LC_NUMERIC=C
  
  # Define test functions (our test suites)
  local test_suites=(
   
    "test_smartmerge_conflict_resolution"
    "test_smartmerge_fast_forward"
    "test_smartmerge_squash_merge"
    "test_complex_smartmerge_diverged"
    "test_complex_smartmerge_sequential"

  )

  
  local ignored_suites=(

  )
  
  # Run bashTestRunner to execute all test suites
  bashTestRunner test_suites ignored_suites
  return $?
}
