#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

dart --enable-checked-mode $ROOT_DIR/example/simple_arith.dart
dart --enable-checked-mode $ROOT_DIR/example/full_arith.dart
dart --enable-checked-mode $ROOT_DIR/test/parsers_test.dart
