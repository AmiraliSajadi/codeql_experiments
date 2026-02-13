#!/usr/bin/env bash
set -e

rm -rf /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/codeql-db
rm -rf /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/classes
rm -f /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/security-and-quality.sarif

mkdir -p /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/classes

javac -d /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/classes \
  /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/single_sanitizer.java \
  /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/split_sanitizer.java

/Users/amirali/Documents/code/iris_all/iris-v2-fork/codeql/codeql database create \
  /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/codeql-db \
  --language=java \
  --source-root /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization \
  --command="javac -d /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/classes /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/single_sanitizer.java /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/split_sanitizer.java"

/Users/amirali/Documents/code/iris_all/iris-v2-fork/codeql/codeql database analyze \
  /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/codeql-db \
  /Users/amirali/Documents/code/iris_all/iris-v2-fork/codeql/qlpacks/codeql/java-queries/0.8.6/codeql-suites/java-security-and-quality.qls \
  --format=sarifv2.1.0 \
  --output=/Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/security-and-quality.sarif

grep -n "java/path-injection" /Users/amirali/Documents/code/codeql_experiments/scattered_sanitization/security-and-quality.sarif || true
