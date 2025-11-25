#!/bin/bash
# fix.sh - Fix script for MQ3S
# This script attempts to fix common issues detected by verify.sh

set -e

echo "=== MQ3S Fix Script ==="
echo ""

# Initialize git repository if not present
fix_git_repo() {
    echo "Checking git repository..."
    if [ ! -d ".git" ]; then
        echo "Initializing git repository..."
        git init
        echo "✓ Git repository initialized"
    else
        echo "✓ Git repository already exists"
    fi
}

# Create README if missing
fix_readme() {
    echo "Checking README.md..."
    if [ ! -f "README.md" ]; then
        echo "Creating README.md..."
        cat > README.md << 'EOF'
# MQ3S

MQ3S is a repository management toolkit with verification and fix utilities.

## Usage

### Verification
Run the verification script to check for common issues:
```bash
./verify.sh
```

### Fixing Issues
Run the fix script to automatically fix common issues:
```bash
./fix.sh
```
EOF
        echo "✓ README.md created"
    else
        echo "✓ README.md already exists"
    fi
}

# Fix script permissions
fix_permissions() {
    echo "Fixing script permissions..."

    for script in *.sh; do
        if [ -f "$script" ]; then
            if [ ! -x "$script" ]; then
                chmod +x "$script"
                echo "✓ Made $script executable"
            else
                echo "✓ $script already executable"
            fi
        fi
    done
}

# Fix trailing whitespace
fix_whitespace() {
    echo "Fixing trailing whitespace..."

    shopt -s nullglob
    for file in *.md *.sh; do
        if [ -f "$file" ]; then
            if grep -q '[[:space:]]$' "$file" 2>/dev/null; then
                # Create backup before modifying
                cp "$file" "$file.bak"
                sed -i 's/[[:space:]]*$//' "$file"
                rm "$file.bak"
                echo "✓ Removed trailing whitespace from $file"
            else
                echo "✓ $file has no trailing whitespace"
            fi
        fi
    done
    shopt -u nullglob
}

# Run all fixes
main() {
    fix_git_repo
    echo ""

    fix_readme
    echo ""

    fix_permissions
    echo ""

    fix_whitespace
    echo ""

    echo "=== Fixes complete ==="
    echo "Run ./verify.sh to verify all issues are resolved"
}

main "$@"
