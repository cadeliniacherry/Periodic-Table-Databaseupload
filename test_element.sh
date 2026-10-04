#!/bin/bash
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
element_script="$script_dir/element.sh"

assert_output() {
  expected=$1
  shift
  actual=$("$element_script" "$@")
  if [[ "$actual" != "$expected" ]]; then
    printf 'Expected: %s\nActual: %s\n' "$expected" "$actual" >&2
    exit 1
  fi
}

hydrogen="The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
assert_output "Please provide an element as an argument."
assert_output "$hydrogen" 1
assert_output "$hydrogen" H
assert_output "$hydrogen" Hydrogen
assert_output "The element with atomic number 10 is Neon (Ne). It's a nonmetal, with a mass of 20.18 amu. Neon has a melting point of -248.6 celsius and a boiling point of -246.1 celsius." 10
assert_output "I could not find that element in the database." 999

printf 'All element lookup tests passed.\n'
