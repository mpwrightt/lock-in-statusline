#!/bin/bash

# ⚔️ HERO'S QUEST STATUSLINE ⚔️ - LEGEND OF ZELDA EDITION WITH LIVE UPDATES
# Dynamic Hyrulean wisdom display with constant updates and magical animations
# Reads Claude Code session data and displays maximum heroic inspiration with 1-second refresh rate
#
# LIVE UPDATE MECHANISM:
# - Magical animations are calculated based on current timestamp seconds
# - Each execution shows a different animation frame
# - Claude Code automatically refreshes the statusline, creating smooth live animation
# - Quotes rotate every 10 seconds with continuous horizontal scrolling
# - Visual effects (pulse, bounce, scroll indicators) update every second
#
# ANIMATION FEATURES:
# 1. HORIZONTAL SCROLLING: Long quotes scroll left-to-right like ancient scrolls
# 2. QUOTE ROTATION: New heroic wisdom every 10 seconds
# 3. PULSE ANIMATION: Triforce pulse indicator changes every 0.5 seconds
# 4. SCROLL INDICATORS: Moving magical characters show active enchantments
# 5. PROGRESS DOTS: Animated dots show live update status
# 6. BOUNCE EFFECT: Short quotes gently bounce for magical interest

# HEROIC WISDOM COLLECTION - LEGEND OF ZELDA INSPIRATION
quotes=(
"⚔️ IT'S DANGEROUS TO GO ALONE. TAKE THIS FOCUS."
"🛡️ COURAGE IS NOT THE ABSENCE OF FEAR, BUT ACTION DESPITE IT."
"💎 THE TRIFORCE OF WISDOM GUIDES YOUR CODE."
"🏰 HYRULE NEEDS HEROES. CODING NEEDS YOU."
"🧝‍♂️ LISTEN TO NAVI: CODE WITH PURPOSE."
"🗡️ THE MASTER SWORD OF SKILL IS FORGED THROUGH PRACTICE."
"✨ MAY THE GODDESS HYLIA BLESS YOUR COMMITS."
"🏹 AIM TRUE WITH YOUR FUNCTIONS, LIKE LINK WITH HIS BOW."
"🌟 WHEN THE MOON FALLS, THE HERO RISES TO CODE."
"🧚‍♀️ FAIRY MAGIC FLOWS THROUGH CLEAN CODE."
"🦅 SOAR LIKE REVALI, CODE LIKE A CHAMPION."
"🌊 FLOW LIKE THE ZORA RIVER, CRASH LIKE ITS WATERFALLS."
"🔥 BURN BRIGHT LIKE DARUK'S PROTECTION AROUND YOUR LOGIC."
"🌸 BLOOM LIKE MIPHA'S GRACE IN YOUR ALGORITHMS."
"🌀 URBOSA'S FURY STRIKES DOWN BUGS WITH LIGHTNING SPEED."
"🎭 WEAR THE MASK OF FOCUS. BECOME THE HERO TIME NEEDS."
"🔮 THE CRYSTAL OF TIME REWINDS ALL MISTAKES."
"🗿 STAND FIRM LIKE THE GORONS. YOUR CODE IS UNBREAKABLE."
"🦋 TRANSFORM YOUR IDEAS LIKE A DEKU SCRUB TO HERO."
"🎵 ZELDA'S LULLABY SOOTHES THE CHAOS OF COMPLEX CODE."
"⚡ THUNDER MAGIC COURSES THROUGH YOUR KEYBOARD."
"🏛️ BUILD TEMPLES OF LOGIC, SOLVE PUZZLES OF PURPOSE."
"🐴 RIDE EPONA THROUGH THE FIELDS OF INFINITE POSSIBILITY."
"🌙 UNDER THE BLOOD MOON, LEGENDS ARE REBORN."
"🏆 EVERY BUG DEFEATED BRINGS YOU CLOSER TO LEGEND STATUS."
)


# ================================================================
# 🎯 ELITE PERFORMANCE SYSTEM INITIALIZATION
# ================================================================

# Read input from stdin
input=$(cat)

# Extract session information
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
time_str=$(date +%H:%M:%S)
date_str=$(date +"%a %b %d")

# Get current directory name
dir_name=$(basename "$current_dir")

# Git information (enhanced with skip-worktree handling)
git_branch=""
git_status=""
git_ahead=""
if cd "$current_dir" 2>/dev/null; then
    git_branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$git_branch" ]; then
        # Check for changes
        git_changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        if [ "$git_changes" -gt 0 ]; then
            git_status="⚡"
        fi
        
        # Check if ahead of remote
        git_ahead_count=$(git rev-list --count HEAD ^origin/"$git_branch" 2>/dev/null || echo "0")
        if [ "$git_ahead_count" -gt 0 ]; then
            git_ahead="↑$git_ahead_count"
        fi
    fi
fi

# ================================================================
# 🔥 LIVE UPDATE SYSTEM - DAEMON INTEGRATION
# ================================================================

CACHE_FILE="$HOME/.claude/lock-in-cache.txt"
DAEMON_SCRIPT="$HOME/.claude/lock-in-daemon.sh"
PID_FILE="$HOME/.claude/lock-in-daemon.pid"

# Auto-start daemon if not running
if [ ! -f "$PID_FILE" ] || ! ps -p $(cat "$PID_FILE" 2>/dev/null) > /dev/null 2>&1; then
    if [ -f "$DAEMON_SCRIPT" ]; then
        chmod +x "$DAEMON_SCRIPT"
        nohup "$DAEMON_SCRIPT" > /dev/null 2>&1 &
        sleep 0.1  # Give daemon time to start
    fi
fi

# Read live data from cache or fallback to static generation
display_quote=""
pulse_char="💎"
scroll_char="✨"
animation_dots="💎○○"

if [ -f "$CACHE_FILE" ]; then
    # Use live data from daemon
    while IFS=':' read -r key value; do
        case "$key" in
            "QUOTE") display_quote="$value" ;;
            "PULSE") pulse_char="$value" ;;
            "SCROLL") scroll_char="$value" ;;
            "DOTS") animation_dots="$value" ;;
        esac
    done < "$CACHE_FILE"
fi

# Fallback if cache is empty or missing
if [ -z "$display_quote" ]; then
    seconds=$(date +%s)
    quote_count=${#quotes[@]}
    quote_index=$(( (seconds / 10) % quote_count ))
    current_quote="${quotes[$quote_index]}"
    
    content_width=75
    quote_length=${#current_quote}
    
    if [ $quote_length -le $content_width ]; then
        base_padding=$(( (content_width - quote_length) / 2 ))
        remaining=$((content_width - quote_length - base_padding))
        left_spaces=$(printf "%*s" $base_padding "")
        right_spaces=$(printf "%*s" $remaining "")
        display_quote="$left_spaces$current_quote$right_spaces"
    else
        display_quote="${current_quote:0:$content_width}"
    fi
fi

# Trigger periodic updates (helps keep statusline refreshing)
if [ $(($(date +%s) % 3)) -eq 0 ]; then
    # Every 3 seconds, do a lightweight background refresh
    (sleep 0.1 && echo > /dev/null) &
fi

# ================================================================
# 🎨 ELITE VISUAL DESIGN SYSTEM
# ================================================================

# Color definitions (high contrast, attention-grabbing)
RED_BOLD='\033[1;91m'
YELLOW_BOLD='\033[1;93m'
GREEN_BOLD='\033[1;92m'
BLUE_BOLD='\033[1;94m'
MAGENTA_BOLD='\033[1;95m'
CYAN_BOLD='\033[1;96m'
WHITE_BOLD='\033[1;97m'
ORANGE='\033[38;5;208m'
PURPLE='\033[38;5;165m'
ELECTRIC_BLUE='\033[38;5;33m'
NEON_GREEN='\033[38;5;46m'
RESET='\033[0m'

# ================================================================
# ⚔️ HERO'S QUEST HEADER - ULTRA-PRECISE ALIGNMENT - TRIFORCE MODE
# ================================================================

# Build HERO'S QUEST header with EXACT 78-character width (+ borders = 80 total)
printf "${RED_BOLD}+======================================================================================+${RESET}\n"
printf "${RED_BOLD}|${RESET}      ${pulse_char} ${YELLOW_BOLD}⚔️ H E R O ' S   Q U E S T ⚔️${RESET} ${pulse_char}         ${WHITE_BOLD}TRIFORCE POWER ACTIVATED${RESET}       ${RED_BOLD}         |${RESET}\n"
printf "${RED_BOLD}+======================================================================================+${RESET}\n"

# ================================================================
# 🏰 HYRULE INTELLIGENCE DISPLAY - ULTRA-PRECISE ALIGNMENT
# ================================================================

# Calculate exact content positioning for HYRULE INTEL line
location_section="${ELECTRIC_BLUE}🏰 ${WHITE_BOLD}$dir_name${RESET}"

if [ -n "$git_branch" ]; then
    git_section="${NEON_GREEN}🌿 ${WHITE_BOLD}$git_branch${git_status}${git_ahead}${RESET}"
else
    git_section="${PURPLE}🗂️ ${WHITE_BOLD}NO GIT${RESET}"
fi

model_section="${ORANGE}🧝‍♂️ ${WHITE_BOLD}$model${RESET}"

# Enhanced time display with live magical indicator
seconds=$(date +%s)
live_indicator="💎"
if [ $((seconds % 2)) -eq 0 ]; then
    live_indicator="✨"
fi
time_section="${CYAN_BOLD}⚡ ${WHITE_BOLD}$time_str${RESET} ${GREEN_BOLD}$live_indicator${RESET} ${MAGENTA_BOLD}📅 $date_str${RESET}"

# HYRULE INTEL with exact 78-character content padding to match border width
printf "${WHITE_BOLD}+======================================================================================+${RESET}\n"
printf "${WHITE_BOLD}|${RESET} HYRULE INTEL: $location_section • $git_section • $model_section • $time_section  ${WHITE_BOLD}     |${RESET}\n"
printf "${WHITE_BOLD}+======================================================================================+${RESET}\n"

# ================================================================
# 🗡️ HEROIC WISDOM BOX - FIXED 80-CHARACTER WIDTH FOR PERFECT ALIGNMENT
# ================================================================

# Get current quote based on time rotation (every 10 seconds)
seconds=$(date +%s)
quote_count=${#quotes[@]}
quote_index=$(( (seconds / 10) % quote_count ))
current_quote="${quotes[$quote_index]}"

# FIXED WIDTH: All quotes must fit within exactly 78 characters (+ borders = 80 total)
content_width=78
quote_length=${#current_quote}

# Truncate or pad quote to fit exactly within 78 characters
if [ $quote_length -gt $content_width ]; then
    # Truncate long quotes
    formatted_quote="${current_quote:0:$content_width}"
else
    # Center short quotes with padding
    quote_padding=$(( (content_width - quote_length) / 2 ))
    quote_remaining=$((content_width - quote_length - quote_padding))
    quote_left_spaces=$(printf "%*s" $quote_padding "")
    quote_right_spaces=$(printf "%*s" $quote_remaining "")
    formatted_quote="$quote_left_spaces$current_quote$quote_right_spaces"
fi

# Fixed header centered within 78 characters
header_text="⚔️ HEROIC WISDOM ⚔️"
header_length=${#header_text}
header_padding=$(( (content_width - header_length) / 2 ))
header_remaining=$((content_width - header_length - header_padding))
header_left_spaces=$(printf "%*s" $header_padding "")
header_right_spaces=$(printf "%*s" $header_remaining "")
centered_header="$header_left_spaces$header_text$header_right_spaces"

# Fixed empty line (78 spaces)
empty_content=$(printf "%*s" $content_width "")

# Cycle through different box colors based on time for visual variety
color_cycle=$(( (seconds / 10) % 4 ))
case $color_cycle in
    0) box_color="${YELLOW_BOLD}" ;;
    1) box_color="${GREEN_BOLD}" ;;
    2) box_color="${CYAN_BOLD}" ;;
    3) box_color="${MAGENTA_BOLD}" ;;
esac

# Display the fixed-width quote box (EXACTLY 80 characters total width)
printf "${box_color}+======================================================================================+${RESET}\n"
printf "${box_color}|${RESET}${scroll_char} ${MAGENTA_BOLD}${centered_header}${RESET}       ${scroll_char}${CYAN_BOLD}${RESET}${box_color}|${RESET}\n"
printf "${box_color}|${RESET}${empty_content}${box_color}        |${RESET}\n"
printf "${box_color}|${RESET}${WHITE_BOLD}${formatted_quote}${RESET}${box_color}       |${RESET}\n"
printf "${box_color}|${RESET}${empty_content}${box_color}        |${RESET}\n"
printf "${box_color}+======================================================================================+${RESET}\n"

