#!/bin/bash
set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
info() { echo -e "${BLUE}ℹ${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }

# Function to extract repo info from git remote
get_repo_info() {
    local remote_url=$(git config --get remote.origin.url 2>/dev/null || echo "")
    if [[ -z "$remote_url" ]]; then
        error "Git remote origin not found"
        return 1
    fi

    # Extract owner/repo from various GitHub URL formats
    if [[ $remote_url =~ github.com[:/]([^/]+)/([^/\.]+) ]]; then
        echo "${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
    else
        error "Could not parse GitHub repository from remote URL: $remote_url"
        return 1
    fi
}

# Function to sanitize branch name
sanitize_branch_name() {
    local name="$1"
    # Convert to lowercase, replace spaces/special chars with hyphens, remove consecutive hyphens
    echo "$name" | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-z0-9-]/-/g' -e 's/--*/-/g' -e 's/^-//' -e 's/-$//'
}

# Main script
main() {
    local issue_number="$1"
    local base_branch="${2:-main}"

    if [[ -z "$issue_number" ]]; then
        error "Usage: $0 <issue-number> [base-branch]"
        exit 1
    fi

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        error "Not a git repository"
        exit 1
    fi

    # Get repository info
    info "Fetching repository information..."
    local repo_info=$(get_repo_info)
    if [[ -z "$repo_info" ]]; then
        exit 1
    fi
    success "Repository: $repo_info"

    # Fetch issue information using gh CLI
    info "Fetching issue #${issue_number}..."
    if ! command -v gh &> /dev/null; then
        error "GitHub CLI (gh) is not installed. Please install it from https://cli.github.com/"
        exit 1
    fi

    local issue_title=$(gh issue view "$issue_number" --json title --jq '.title' 2>/dev/null)
    if [[ -z "$issue_title" ]]; then
        error "Could not fetch issue #${issue_number}. Make sure it exists and you have access."
        exit 1
    fi
    success "Issue title: $issue_title"

    # Generate branch name from issue title
    local sanitized_title=$(sanitize_branch_name "$issue_title")
    local branch_name="issue-${issue_number}-${sanitized_title}"

    # Limit branch name length
    if [[ ${#branch_name} -gt 50 ]]; then
        branch_name="${branch_name:0:50}"
        branch_name="${branch_name%-}" # Remove trailing hyphen if any
    fi

    info "Branch name: $branch_name"

    # Check if gtr is installed
    if ! command -v git-gtr &> /dev/null; then
        error "git-gtr is not installed. Please install it from https://github.com/coderabbitai/git-worktree-runner"
        exit 1
    fi

    # Check if worktree already exists
    if git gtr list 2>/dev/null | grep -q "$branch_name"; then
        warn "Worktree '$branch_name' already exists"
        info "Using existing worktree"
        worktree_path=$(git gtr list | grep "$branch_name" | awk '{print $2}')
        cd "$worktree_path"
        echo "$worktree_path"
    else
        # Fetch latest changes
        info "Fetching latest changes from remote..."
        git fetch origin "$base_branch" 2>/dev/null || warn "Could not fetch from remote"

        # Check if branch exists remotely or locally
        if git show-ref --verify --quiet "refs/heads/$branch_name"; then
            info "Branch $branch_name already exists locally"
            # Create worktree from existing branch
            git gtr new "$branch_name" --from "$branch_name"
        elif git show-ref --verify --quiet "refs/remotes/origin/$branch_name"; then
            info "Branch $branch_name exists on remote"
            # Checkout remote branch
            git checkout -b "$branch_name" "origin/$branch_name" 2>/dev/null || true
            git gtr new "$branch_name" --from "$branch_name"
        else
            info "Creating new branch from $base_branch..."
            # Create new branch with gtr
            git gtr new "$branch_name" --from "$base_branch"
        fi

        success "Worktree created successfully with gtr!"

        # Get the worktree path from gtr
        worktree_path=$(git gtr list | grep "$branch_name" | awk '{print $2}')

        if [[ -z "$worktree_path" ]]; then
            error "Failed to get worktree path from gtr"
            exit 1
        fi
    fi

    # Save issue context
    info "Saving issue context..."
    local issue_body=$(gh issue view "$issue_number" --json body --jq '.body')
    local issue_url=$(gh issue view "$issue_number" --json url --jq '.url')
    local issue_labels=$(gh issue view "$issue_number" --json labels --jq '.labels[].name' | tr '\n' ', ' | sed 's/,$//')

    cat > "${worktree_path}/.issue-context.md" <<EOF
# Issue #${issue_number}: ${issue_title}

**URL**: ${issue_url}
**Labels**: ${issue_labels}
**Base Branch**: ${base_branch}

## Description

${issue_body}

---
*This file was automatically generated. Do not commit this file.*
EOF

    success "Issue context saved to .issue-context.md"

    # Add .issue-context.md to .git/info/exclude if not already there
    local exclude_file="${worktree_path}/.git/info/exclude"
    if [[ -f "$exclude_file" ]] && ! grep -q ".issue-context.md" "$exclude_file"; then
        echo ".issue-context.md" >> "$exclude_file"
    fi

    # Output the worktree path for the caller
    echo "$worktree_path"

    success "✨ All done! Worktree is ready at: $worktree_path"
    info "To change directory: cd $worktree_path"
    info "To open in editor: git gtr editor $branch_name"
    info "To open with AI tool: git gtr ai $branch_name"
}

# Run main function with all arguments
main "$@"
