#!/bin/bash
# verify.sh - Verification script for MQ3S
# This script performs common verification checks on the repository

set -e

echo "=== MQ3S Verification Script ==="
echo ""

# Check if git repository
verify_git_repo() {
    echo "Checking if this is a git repository..."
    if [ -d ".git" ]; then
        echo "✓ Git repository detected"
        return 0
    else
        echo "✗ Not a git repository"
        return 1
    fi
}

# Check if README exists
verify_readme() {
    echo "Checking for README.md..."
    if [ -f "README.md" ]; then
        echo "✓ README.md exists"
        return 0
    else
        echo "✗ README.md not found"
        return 1
    fi
}

# Check file permissions
verify_permissions() {
    echo "Checking script permissions..."
    local has_issues=0

    for script in *.sh; do
        if [ -f "$script" ]; then
            if [ -x "$script" ]; then
                echo "✓ $script is executable"
            else
                echo "✗ $script is not executable"
                has_issues=1
            fi
        fi
    done

    return $has_issues
}

# Check for trailing whitespace in files
verify_whitespace() {
    echo "Checking for trailing whitespace..."
    local has_issues=0

    for file in *.md *.sh; do
        if [ -f "$file" ]; then
            if grep -q '[[:space:]]$' "$file" 2>/dev/null; then
                echo "✗ $file has trailing whitespace"
                has_issues=1
            else
                echo "✓ $file has no trailing whitespace"
            fi
        fi
    done

    return $has_issues
}

# Run all verification checks
main() {
    local exit_code=0

    verify_git_repo || exit_code=1
    echo ""

    verify_readme || exit_code=1
    echo ""

    verify_permissions || exit_code=1
    echo ""

    verify_whitespace || exit_code=1
    echo ""

    if [ $exit_code -eq 0 ]; then
        echo "=== All verifications passed ==="
    else
        echo "=== Some verifications failed ==="
        echo "Run ./fix.sh to attempt automatic fixes"
    fi

    exit $exit_code
}

main "$@"
