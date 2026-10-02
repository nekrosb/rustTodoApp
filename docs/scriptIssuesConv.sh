#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# GitHub Issues importer
#
# Usage:
#   ./import-issues.sh issues.md
#
# Requirements:
#   - bash
#   - git
#   - GitHub CLI (gh)
#   - authenticated gh CLI
#
# Expected issue format:
#
# ## Issue #1 — Initialize the project
#
# ### User Story
# ...
#
# ### Tasks
# ...
#
# ---
#
# ## Issue #2 — Add a Todo
# ...
# ============================================================

ISSUES_FILE="${1:-issues.md}"

# ------------------------------------------------------------
# Check input file
# ------------------------------------------------------------

if [[ ! -f "$ISSUES_FILE" ]]; then
    echo "❌ Error: file '$ISSUES_FILE' not found."
    echo
    echo "Usage:"
    echo "  ./import-issues.sh issues.md"
    exit 1
fi

# ------------------------------------------------------------
# Check gh
# ------------------------------------------------------------

if ! command -v gh >/dev/null 2>&1; then
    echo "❌ Error: GitHub CLI 'gh' is not installed."
    echo
    echo "Install it from:"
    echo "https://cli.github.com/"
    exit 1
fi

# ------------------------------------------------------------
# Check authentication
# ------------------------------------------------------------

if ! gh auth status >/dev/null 2>&1; then
    echo "❌ Error: GitHub CLI is not authenticated."
    echo
    echo "Run:"
    echo "  gh auth login"
    exit 1
fi

# ------------------------------------------------------------
# Detect GitHub repository
# ------------------------------------------------------------

if ! gh repo view >/dev/null 2>&1; then
    echo "❌ Error: current directory is not a GitHub repository."
    echo
    echo "Run this script from inside your cloned GitHub repository."
    exit 1
fi

REPO=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')

echo
echo "=============================================="
echo " GitHub Issues Importer"
echo "=============================================="
echo
echo "Repository : $REPO"
echo "Source     : $ISSUES_FILE"
echo

# ------------------------------------------------------------
# Temporary directory
# ------------------------------------------------------------

TMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

# ------------------------------------------------------------
# Split issues.md into separate files
# ------------------------------------------------------------

CURRENT_FILE=""

while IFS= read -r line || [[ -n "$line" ]]; do

    # Detect:
    # ## Issue #1 — Title
    if [[ "$line" =~ ^[[:space:]]*##[[:space:]]+Issue[[:space:]]+\#[0-9]+[[:space:]]*—[[:space:]]*(.+)[[:space:]]*$ ]]; then

        ISSUE_TITLE="${BASH_REMATCH[1]}"

        # Extract issue number
        if [[ "$line" =~ Issue[[:space:]]+\#([0-9]+) ]]; then
            ISSUE_NUMBER="${BASH_REMATCH[1]}"
        else
            echo "❌ Could not determine issue number."
            exit 1
        fi

        CURRENT_FILE="$TMP_DIR/issue-${ISSUE_NUMBER}.md"

        # Start new issue file
        printf '%s\n' "$line" > "$CURRENT_FILE"

        continue
    fi

    # Add line to current issue
    if [[ -n "$CURRENT_FILE" ]]; then
        printf '%s\n' "$line" >> "$CURRENT_FILE"
    fi

done < "$ISSUES_FILE"

# ------------------------------------------------------------
# Find created temporary issue files
# ------------------------------------------------------------

mapfile -t ISSUE_FILES < <(
    find "$TMP_DIR" \
        -maxdepth 1 \
        -type f \
        -name 'issue-*.md' \
        -print |
    sort -V
)

if [[ ${#ISSUE_FILES[@]} -eq 0 ]]; then
    echo "❌ No issues found."
    echo
    echo "Expected headings like:"
    echo
    echo "  ## Issue #1 — Initialize the project"
    exit 1
fi

TOTAL=${#ISSUE_FILES[@]}

echo "Found $TOTAL issues."
echo

# ------------------------------------------------------------
# Ask for confirmation
# ------------------------------------------------------------

echo "The following GitHub Issues will be created:"
echo

for ISSUE_FILE in "${ISSUE_FILES[@]}"; do

    TITLE=$(
        sed -nE \
            's/^[[:space:]]*##[[:space:]]+Issue[[:space:]]+\#[0-9]+[[:space:]]*—[[:space:]]*(.+)[[:space:]]*$/\1/p' \
            "$ISSUE_FILE" |
        head -n 1
    )

    echo "  • $TITLE"
done

echo
read -r -p "Create these $TOTAL Issues in $REPO? [y/N] " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo
    echo "Cancelled."
    exit 0
fi

echo

# ------------------------------------------------------------
# Create GitHub Issues
# ------------------------------------------------------------

CREATED=0
FAILED=0

for ISSUE_FILE in "${ISSUE_FILES[@]}"; do

    # Extract title
    TITLE=$(
        sed -nE \
            's/^[[:space:]]*##[[:space:]]+Issue[[:space:]]+\#[0-9]+[[:space:]]*—[[:space:]]*(.+)[[:space:]]*$/\1/p' \
            "$ISSUE_FILE" |
        head -n 1
    )

    if [[ -z "$TITLE" ]]; then
        echo "❌ Could not determine title from:"
        echo "   $ISSUE_FILE"
        FAILED=$((FAILED + 1))
        continue
    fi

    # Remove the "## Issue #N — Title" line.
    # GitHub has its own title field, so we don't need
    # to duplicate the heading inside the body.

    BODY_FILE="$TMP_DIR/body.md"

    sed -E \
        '/^[[:space:]]*##[[:space:]]+Issue[[:space:]]+\#[0-9]+[[:space:]]*—[[:space:]]*(.+)[[:space:]]*$/d' \
        "$ISSUE_FILE" > "$BODY_FILE"

    echo "Creating:"
    echo "  $TITLE"

    if ISSUE_URL=$(
        gh issue create \
            --repo "$REPO" \
            --title "$TITLE" \
            --body-file "$BODY_FILE"
    ); then

        echo "  ✅ $ISSUE_URL"
        echo

        CREATED=$((CREATED + 1))

    else

        echo "  ❌ Failed to create issue."
        echo

        FAILED=$((FAILED + 1))
    fi

done

# ------------------------------------------------------------
# Summary
# ------------------------------------------------------------

echo
echo "=============================================="
echo " Import finished"
echo "=============================================="
echo
echo "Repository : $REPO"
echo "Found      : $TOTAL"
echo "Created    : $CREATED"
echo "Failed     : $FAILED"
echo

if [[ "$FAILED" -gt 0 ]]; then
    echo "⚠️ Some Issues could not be created."
    exit 1
fi

echo "🎉 All Issues were successfully created!"