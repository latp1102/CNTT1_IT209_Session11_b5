#!/bin/bash
set -euo pipefail

PROJECT_DIR="."
cd "$PROJECT_DIR" || exit 1

echo "=== Git Init ==="
git init
git add .
git commit -m "Initial commit"

echo "=== Create branch feature/product-service ==="
git checkout -b feature/product-service

echo "=== On feature/product-service: set server.port to 8080 ==="
sed -i 's/^  port: .*/  port: 8080/' src/main/resources/application.yaml || true
git add .
git commit -m "feat: configure application port to 8080"

echo "=== Switch to main and set server.port to 9090 ==="
git checkout main
sed -i 's/^  port: .*/  port: 9090/' src/main/resources/application.yaml || true
git add .
git commit -m "chore: set server.port to 9090"

echo "=== Merge feature/product-service into main ==="
if git merge feature/product-service --no-ff --no-edit; then
  echo "Merge completed without conflict"
else
  echo "=== Merge conflict detected, resolving by keeping server.port: 8080 ==="
  sed -i 's/^  port: .*/  port: 8080/' src/main/resources/application.yaml
  git add src/main/resources/application.yaml
  git commit -m "Merge branch 'feature/product-service' - keep server.port 8080"
fi

echo "=== Git log ==="
git log --oneline --graph --all
