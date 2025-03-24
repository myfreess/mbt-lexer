#!/usr/bin/env bash

CORE="$HOME/.moon/lib/core/"

# build executable
moon build --target native

# iterate
echo > src/cli_test/results.md
for file in $(find "$CORE" -name "*.mbt"); do
  ./target/native/release/build/cli_test/cli_test.exe "$file" >> src/cli_test/results.md
done