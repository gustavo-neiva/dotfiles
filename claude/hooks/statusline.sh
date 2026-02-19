#!/bin/bash
# StatusLine script inspired by robbyrussell theme
# Shows: arrow indicator | current directory | git branch | model info | context usage

input=$(cat)

# Extract info from JSON input
model=$(echo "$input" | jq -r '.model.display_name')
style=$(echo "$input" | jq -r '.output_style.name')
project=$(basename "$(echo "$input" | jq -r '.workspace.project_dir // "no-project"')" 2>/dev/null)
[ -z "$project" ] && project="no-project"
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // "."')
cwd=$(basename "$current_dir")

# Read context window percentages
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Git branch info (skip locks for performance)
git_branch=""
if [ -d "$current_dir/.git" ] 2>/dev/null; then
    branch=$(git -C "$current_dir" --no-optional-locks branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        # Check if repo is dirty (skip locks)
        dirty=$(git -C "$current_dir" --no-optional-locks status --porcelain 2>/dev/null)
        if [ -n "$dirty" ]; then
            git_branch="\033[33m${branch}\033[0m*"  # Yellow with * for dirty
        else
            git_branch="\033[36m${branch}\033[0m"     # Cyan for clean
        fi
    fi
fi

# Arrow indicator (green for success, dim for neutral)
arrow="\033[32m➜\033[0m"

# Directory name (cyan like robbyrussell)
dir_display="\033[36m${cwd}\033[0m"

# Build the status line
printf "\033[2m${arrow} ${dir_display}"  # Arrow + directory

# Add git branch if available
if [ -n "$git_branch" ]; then
    printf " \033[2mgit:(%b)\033[0m" "$git_branch"
fi

# Add model/style/project info
printf " | %s | %s | %s" "$model" "$style" "$project"

# Show context usage when >=40% used (<=60% remaining)
if [ -n "$used_pct" ] && [ "$used_pct" -ge 40 ] 2>/dev/null; then
    used_int=$(printf "%.0f" "$used_pct")
    if [ "$used_int" -ge 80 ]; then
        ctx_color="\033[31m"   # Red - critical
    elif [ "$used_int" -ge 60 ]; then
        ctx_color="\033[33m"   # Yellow - caution
    else
        ctx_color="\033[2m"    # Dim - warning started
    fi
    printf " | %b%d%% used\033[0m" "$ctx_color" "$used_int"
fi

printf "\033[0m"