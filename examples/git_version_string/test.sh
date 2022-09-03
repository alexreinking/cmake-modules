#!/bin/bash

set -e

trap cleanup 1 2 3 6

cleanup () {
  echo "Cleaning up..."
  rm -rf build .git
}

run_test () {
  echo "-----------------------------------------------"
  echo "-- $1"
  echo
  cmake -G Ninja -S . -B build -DCMAKE_MODULE_PATH=$PWD/.. -UEXAMPLE_VERSION_STRING >/dev/null
  cmake --build build >/dev/null
  ./build/example
  echo
}

run_test "No git repo"

git init >/dev/null 2>&1
git add . >/dev/null
git commit -m "initial commit" >/dev/null
run_test "Initial git repo"

git tag foobar >/dev/null
run_test "After tagging with foobar"

git commit --allow-empty -m "poke" >/dev/null
git commit --allow-empty -m "poke" >/dev/null
git commit --allow-empty -m "poke" >/dev/null
run_test "After committing three times"

git tag 1.42.3 >/dev/null
run_test "After tagging with 1.42.3 (to match version)"

cleanup
