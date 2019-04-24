# Parsers Changelog

## 2.0.0

- Dart 2.0 compatible
- Operators disabled for now, so instead of `parser1 | parser2` use `parser1.or(parser2)`
- `%` operator is an exception as it does not require any type parameters

## 1.0.0

- Make strong mode and dart 2 compatible.
- Introduce non-infix generic methods for all the infix operators.

## 0.14.5

- Lazy computation of the error messages (PR #18).

## 0.14.4

- Support setting the value of a tabstop in position calculation (PR #16).

## 0.14.3

- Move run_all_tests.sh to tests/run.sh to adhere to pub.drone.io's conventions.

## 0.14.2

- Fix type annotation leading to failure in checked mode

## 0.14.1

- Added `CHANGELOG.md`
- Fix type annotation leading to failure in checked mode
