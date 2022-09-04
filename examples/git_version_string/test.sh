#!/bin/bash

set -e

trap cleanup EXIT

cleanup () {
  echo "Cleaning up..."
  rm -rf build .git
}

run_test () {
  echo "-----------------------------------------------"
  echo "-- $1"
  echo
  cmake --build build
  ./build/example
  echo
}

cmake -G Ninja -S . -B build -DCMAKE_MODULE_PATH=$PWD/.. >/dev/null
run_test "No git repo (fresh)"

git init >/dev/null 2>&1
git add . >/dev/null
git commit -m "initial commit" >/dev/null
cmake -G Ninja -S . -B build -DCMAKE_MODULE_PATH=$PWD/.. >/dev/null
run_test "Initial git repo (fresh)"

git tag foobar >/dev/null
run_test "After tagging with foobar (incremental)"

git commit --allow-empty -m "poke" >/dev/null
git commit --allow-empty -m "poke" >/dev/null
git commit --allow-empty -m "poke" >/dev/null
run_test "After committing three times (incremental)"

git tag 1.42.3 >/dev/null
run_test "After tagging with 1.42.3 (incremental)"

run_test "No change (incremental)"
