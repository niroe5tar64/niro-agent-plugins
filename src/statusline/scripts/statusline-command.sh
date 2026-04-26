#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Detect local timezone (TZ env > /etc/localtime symlink > /etc/timezone > UTC)
if [ -z "$TZ" ]; then
    if [ -L /etc/localtime ]; then
        TZ=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')
    elif [ -f /etc/timezone ]; then
        TZ=$(cat /etc/timezone)
    else
        TZ="UTC"
    fi
fi
export TZ

# Extract basic information
model=$(echo "$input" | jq -r '.model.display_name // .model.id')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')

# Get short directory name (basename)
dir_name=$(basename "$current_dir")

# Get git branch if in a git repository
git_info=""
if git -C "$current_dir" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$current_dir" -c core.useBuiltinFSMonitor=false -c core.fsmonitor=false branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        # Check if there are uncommitted changes
        if ! git -C "$current_dir" -c core.useBuiltinFSMonitor=false -c core.fsmonitor=false diff --quiet 2>/dev/null || \
           ! git -C "$current_dir" -c core.useBuiltinFSMonitor=false -c core.fsmonitor=false diff --cached --quiet 2>/dev/null; then
            git_info=" $(printf '\033[33m')±$(printf '\033[0m') $branch"
        else
            git_info=" $(printf '\033[32m')✓$(printf '\033[0m') $branch"
        fi
    fi
fi

# Calculate context window usage percentage and absolute value
context_info=""
usage=$(echo "$input" | jq '.context_window.current_usage')
if [ "$usage" != "null" ]; then
    current=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    size=$(echo "$input" | jq '.context_window.context_window_size')
    if [ "$size" != "null" ] && [ "$size" -gt 0 ]; then
        pct=$((current * 100 / size))
        # Format token count (k for thousands)
        if [ "$current" -ge 1000 ]; then
            tokens_display="$((current / 1000))k"
        else
            tokens_display="${current}"
        fi
        # Color code based on usage: green < 50%, yellow < 80%, red >= 80%
        if [ "$pct" -lt 50 ]; then
            color=$(printf '\033[32m')
        elif [ "$pct" -lt 80 ]; then
            color=$(printf '\033[33m')
        else
            color=$(printf '\033[31m')
        fi
        context_info=" │ ${color}${pct}% (${tokens_display})$(printf '\033[0m')"
    fi
fi

# Extract session cost
cost_info=""
cost=$(echo "$input" | jq -r '.cost.total_cost_usd')
if [ "$cost" != "null" ] && [ "$cost" != "0" ]; then
    # Format cost to 2 decimal places
    cost_formatted=$(printf "%.2f" "$cost")
    cost_info=" │ \$${cost_formatted}"
fi

# Extract rate limit info (five_hour and seven_day)
rate_limit_info=""

# Five-hour rate limit
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$five_hour_pct" ]; then
    five_hour_pct_int=$(printf "%.0f" "$five_hour_pct")
    if [ "$five_hour_pct_int" -lt 50 ]; then
        rl_color=$(printf '\033[32m')
    elif [ "$five_hour_pct_int" -lt 80 ]; then
        rl_color=$(printf '\033[33m')
    else
        rl_color=$(printf '\033[31m')
    fi
    if [ -n "$five_hour_reset" ]; then
        reset_time=$(date -d "@${five_hour_reset}" "+%H:%M" 2>/dev/null || date -r "${five_hour_reset}" "+%H:%M" 2>/dev/null)
        rate_limit_info="${rate_limit_info} │ 5h: ${rl_color}${five_hour_pct_int}%$(printf '\033[0m') (${reset_time})"
    else
        rate_limit_info="${rate_limit_info} │ 5h: ${rl_color}${five_hour_pct_int}%$(printf '\033[0m')"
    fi
fi

# Seven-day rate limit
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
if [ -n "$seven_day_pct" ]; then
    seven_day_pct_int=$(printf "%.0f" "$seven_day_pct")
    if [ "$seven_day_pct_int" -lt 50 ]; then
        rl_color=$(printf '\033[32m')
    elif [ "$seven_day_pct_int" -lt 80 ]; then
        rl_color=$(printf '\033[33m')
    else
        rl_color=$(printf '\033[31m')
    fi
    if [ -n "$seven_day_reset" ]; then
        reset_date=$(date -d "@${seven_day_reset}" "+%m/%d %H:%M" 2>/dev/null || date -r "${seven_day_reset}" "+%m/%d %H:%M" 2>/dev/null)
        rate_limit_info="${rate_limit_info} │ 7d: ${rl_color}${seven_day_pct_int}%$(printf '\033[0m') (${reset_date})"
    else
        rate_limit_info="${rate_limit_info} │ 7d: ${rl_color}${seven_day_pct_int}%$(printf '\033[0m')"
    fi
fi

# Build the status line
# Format: [Model] Directory Git │ Context │ Cost │ 5h: XX% (HH:MM) │ 7d: XX% (MM/DD HH:MM)
printf "$(printf '\033[0m')[$(printf '\033[36m')%s$(printf '\033[0m')] %s%s%s%s%s\n" \
    "$model" "$dir_name" "$git_info" "$context_info" "$cost_info" "$rate_limit_info"
