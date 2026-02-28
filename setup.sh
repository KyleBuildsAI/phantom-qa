#!/usr/bin/env bash

# PhantomQA Setup Wizard
# Beautiful interactive installer for all supported platforms
# Usage: ./setup.sh or curl -sSL https://raw.githubusercontent.com/KyleBuildsAI/phantom-qa/main/setup.sh | bash

set -e

VERSION="1.0.0"

# ── Color & Formatting ──────────────────────────────────────────
setup_colors() {
  if [ -t 1 ] && [ "${TERM:-}" != "dumb" ]; then
    BOLD='\033[1m'
    DIM='\033[2m'
    RESET='\033[0m'
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[0;33m'
    CYAN='\033[0;36m'
    WHITE='\033[1;37m'
    CHECK="${GREEN}✓${RESET}"
    CROSS="${RED}✗${RESET}"
    DASH="${DIM}-${RESET}"
    ARROW="${CYAN}>${RESET}"
  else
    BOLD='' DIM='' RESET='' GREEN='' RED='' YELLOW='' CYAN='' WHITE=''
    CHECK="[OK]" CROSS="[!!]" DASH="[-]" ARROW=">"
  fi
}

# ── Helper Functions ─────────────────────────────────────────────
print_banner() {
  echo ""
  echo -e "${CYAN}    ╔═══════════════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}    ║                                               ║${RESET}"
  echo -e "${CYAN}    ║${WHITE}        P H A N T O M    Q A                ${CYAN}║${RESET}"
  echo -e "${CYAN}    ║                                               ║${RESET}"
  echo -e "${CYAN}    ║${RESET}   Autonomous QA for AI Coding Agents        ${CYAN}║${RESET}"
  echo -e "${CYAN}    ║${DIM}   v${VERSION}                                       ${CYAN}${RESET}${CYAN}║${RESET}"
  echo -e "${CYAN}    ║                                               ║${RESET}"
  echo -e "${CYAN}    ╚═══════════════════════════════════════════════╝${RESET}"
  echo ""
}

print_step() {
  local step="$1" total="$2" msg="$3"
  echo -e "  ${CYAN}[${step}/${total}]${RESET}  ${BOLD}${msg}${RESET}"
  echo ""
}

print_ok()      { echo -e "    ${CHECK}  $1"; }
print_fail()    { echo -e "    ${CROSS}  $1"; }
print_warn()    { echo -e "    ${YELLOW}!${RESET}  $1"; }
print_skip()    { echo -e "    ${DASH}  $1"; }
print_info()    { echo -e "    ${ARROW}  $1"; }
print_item()    { echo -e "      ├── $1"; }
print_last()    { echo -e "      └── $1"; }

# ── Dependency Check ─────────────────────────────────────────────
check_dependencies() {
  print_step 1 5 "Checking dependencies"

  if command -v node &>/dev/null; then
    local node_ver
    node_ver=$(node --version 2>/dev/null)
    print_ok "node ${DIM}${node_ver}${RESET}"
    HAS_NODE=true
  else
    print_warn "node not found ${DIM}(test harness won't run, skills still install)${RESET}"
    HAS_NODE=false
  fi

  if command -v git &>/dev/null; then
    local git_ver
    git_ver=$(git --version 2>/dev/null | awk '{print $3}')
    print_ok "git ${DIM}${git_ver}${RESET}"
  else
    print_skip "git not found ${DIM}(optional)${RESET}"
  fi
  echo ""
}

# ── Platform Detection ───────────────────────────────────────────
DETECTED_ANTIGRAVITY=false
DETECTED_OPENCLAW=false
DETECTED_CLAUDE=false
DETECTED_CURSOR=false
DETECTED_WINDSURF=false

detect_platforms() {
  print_step 2 5 "Detecting installed platforms"

  # Google Antigravity
  if [ -d "$HOME/.gemini" ]; then
    print_ok "Google Antigravity    ${DIM}(detected)${RESET}"
    DETECTED_ANTIGRAVITY=true
  else
    print_skip "Google Antigravity    ${DIM}(not found)${RESET}"
  fi

  # OpenClaw
  if [ -d "$HOME/.openclaw" ]; then
    print_ok "OpenClaw              ${DIM}(detected)${RESET}"
    DETECTED_OPENCLAW=true
  else
    print_skip "OpenClaw              ${DIM}(not found)${RESET}"
  fi

  # Claude Code
  if command -v claude &>/dev/null || [ -d "$HOME/.claude" ]; then
    print_ok "Claude Code           ${DIM}(detected)${RESET}"
    DETECTED_CLAUDE=true
  else
    print_skip "Claude Code           ${DIM}(not found)${RESET}"
  fi

  # Cursor
  if command -v cursor &>/dev/null || [ -d "$HOME/.cursor" ]; then
    print_ok "Cursor                ${DIM}(detected)${RESET}"
    DETECTED_CURSOR=true
  else
    print_skip "Cursor                ${DIM}(not found)${RESET}"
  fi

  # Windsurf
  if command -v windsurf &>/dev/null || [ -d "$HOME/.windsurf" ] || [ -d "$HOME/.codeium" ]; then
    print_ok "Windsurf              ${DIM}(detected)${RESET}"
    DETECTED_WINDSURF=true
  else
    print_skip "Windsurf              ${DIM}(not found)${RESET}"
  fi

  echo ""
}

# ── Interactive Menu ─────────────────────────────────────────────
SEL_ANTIGRAVITY=false
SEL_OPENCLAW=false
SEL_CLAUDE=false
SEL_CURSOR=false
SEL_WINDSURF=false
SEL_WORKSPACE=""

show_menu() {
  # Pre-select detected platforms
  SEL_ANTIGRAVITY=$DETECTED_ANTIGRAVITY
  SEL_OPENCLAW=$DETECTED_OPENCLAW

  # Project-level platforms need --workspace, so don't pre-select
  SEL_CLAUDE=false
  SEL_CURSOR=false
  SEL_WINDSURF=false

  print_step 3 5 "Choose where to install"

  echo -e "    Detected platforms are pre-selected."
  echo -e "    Enter numbers to toggle, then press ${BOLD}Enter${RESET} to continue."
  echo ""

  while true; do
    local mark_a="[ ]" mark_o="[ ]" mark_c="[ ]" mark_u="[ ]" mark_w="[ ]"
    $SEL_ANTIGRAVITY && mark_a="${GREEN}[x]${RESET}"
    $SEL_OPENCLAW    && mark_o="${GREEN}[x]${RESET}"
    $SEL_CLAUDE      && mark_c="${GREEN}[x]${RESET}"
    $SEL_CURSOR      && mark_u="${GREEN}[x]${RESET}"
    $SEL_WINDSURF    && mark_w="${GREEN}[x]${RESET}"

    echo -e "    ${mark_a} 1. Google Antigravity  ${DIM}(global: ~/.gemini/antigravity/skills/)${RESET}"
    echo -e "    ${mark_o} 2. OpenClaw            ${DIM}(global: ~/.openclaw/workspace/skills/)${RESET}"
    echo -e "    ${mark_c} 3. Claude Code         ${DIM}(project-level install)${RESET}"
    echo -e "    ${mark_u} 4. Cursor              ${DIM}(project-level install)${RESET}"
    echo -e "    ${mark_w} 5. Windsurf            ${DIM}(project-level install)${RESET}"
    echo ""

    read -p "    Toggle [1-5], Enter to continue, q to quit: " choice

    case "$choice" in
      1) $SEL_ANTIGRAVITY && SEL_ANTIGRAVITY=false || SEL_ANTIGRAVITY=true ;;
      2) $SEL_OPENCLAW && SEL_OPENCLAW=false || SEL_OPENCLAW=true ;;
      3) $SEL_CLAUDE && SEL_CLAUDE=false || SEL_CLAUDE=true ;;
      4) $SEL_CURSOR && SEL_CURSOR=false || SEL_CURSOR=true ;;
      5) $SEL_WINDSURF && SEL_WINDSURF=false || SEL_WINDSURF=true ;;
      q|Q) echo ""; echo "  Cancelled."; echo ""; exit 0 ;;
      "") break ;;
      *) ;;
    esac

    # Move cursor up to redraw menu
    printf '\033[8A'
  done

  # If any project-level platform selected, ask for workspace path
  if $SEL_CLAUDE || $SEL_CURSOR || $SEL_WINDSURF; then
    echo ""
    read -p "    Workspace path for project-level install: " SEL_WORKSPACE
    SEL_WORKSPACE="${SEL_WORKSPACE:-.}"
  fi
  echo ""
}

# ── Installation Functions ───────────────────────────────────────
INSTALLED_COUNT=0

do_install_antigravity() {
  local skills_dir="$HOME/.gemini/antigravity/skills"
  local rules_dir="$HOME/.gemini/antigravity"

  echo -e "    ${BOLD}Installing to Antigravity...${RESET}"

  mkdir -p "$skills_dir/continuous-qa/scripts"
  mkdir -p "$skills_dir/software-tester/scripts"

  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/SKILL.md" "$skills_dir/continuous-qa/SKILL.md"
  print_item "Copying continuous-qa skill...        ${CHECK}"

  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/scripts/test-harness.js" "$skills_dir/continuous-qa/scripts/test-harness.js"
  print_item "Copying test harness...               ${CHECK}"

  cp "$SCRIPT_DIR/.agent/skills/software-tester/SKILL.md" "$skills_dir/software-tester/SKILL.md"
  print_item "Copying software-tester skill...      ${CHECK}"

  # Install rules
  local rules_file="$rules_dir/GEMINI.md"
  if [ -f "$rules_file" ] && [ -s "$rules_file" ]; then
    if [ -t 0 ]; then
      echo ""
      echo -e "      ${YELLOW}!${RESET} GEMINI.md already exists at ${DIM}$rules_file${RESET}"
      echo "        1) Append  2) Replace  3) Skip"
      read -p "        Choice [1/2/3]: " rc
      case $rc in
        1) echo "" >> "$rules_file"; cat "$SCRIPT_DIR/GEMINI.md" >> "$rules_file"; print_last "Rules appended                        ${CHECK}" ;;
        2) cp "$SCRIPT_DIR/GEMINI.md" "$rules_file"; print_last "Rules replaced                        ${CHECK}" ;;
        *) print_last "Rules skipped                         ${DASH}" ;;
      esac
    else
      cp "$SCRIPT_DIR/GEMINI.md" "$rules_file"
      print_last "Rules installed                       ${CHECK}"
    fi
  else
    mkdir -p "$rules_dir"
    cp "$SCRIPT_DIR/GEMINI.md" "$rules_file"
    print_last "Rules installed                       ${CHECK}"
  fi

  INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
  echo ""
}

do_install_openclaw() {
  local skills_dir=""
  if [ -d "$HOME/.openclaw/workspace/skills" ]; then
    skills_dir="$HOME/.openclaw/workspace/skills"
  elif [ -d "$HOME/.openclaw/skills" ]; then
    skills_dir="$HOME/.openclaw/skills"
  elif [ -d "$HOME/.openclaw" ]; then
    skills_dir="$HOME/.openclaw/workspace/skills"
  fi

  echo -e "    ${BOLD}Installing to OpenClaw...${RESET}"

  mkdir -p "$skills_dir/phantom-qa/scripts"
  mkdir -p "$skills_dir/phantom-qa-tester"

  cp "$SCRIPT_DIR/.openclaw/skills/phantom-qa/skill.md" "$skills_dir/phantom-qa/skill.md"
  print_item "Copying phantom-qa skill...           ${CHECK}"

  cp "$SCRIPT_DIR/.openclaw/skills/phantom-qa/scripts/test-harness.js" "$skills_dir/phantom-qa/scripts/test-harness.js"
  print_item "Copying test harness...               ${CHECK}"

  cp "$SCRIPT_DIR/.openclaw/skills/phantom-qa-tester/skill.md" "$skills_dir/phantom-qa-tester/skill.md"
  print_last "Copying phantom-qa-tester skill...    ${CHECK}"

  INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
  echo ""
}

do_install_project() {
  local ws="$1" rules_name="$2" platform_name="$3"

  echo -e "    ${BOLD}Installing to ${platform_name}...${RESET} ${DIM}(${ws})${RESET}"

  mkdir -p "$ws/.agent/skills/continuous-qa/scripts"
  mkdir -p "$ws/.agent/skills/software-tester/scripts"

  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/SKILL.md" "$ws/.agent/skills/continuous-qa/SKILL.md"
  print_item "Copying continuous-qa skill...        ${CHECK}"

  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/scripts/test-harness.js" "$ws/.agent/skills/continuous-qa/scripts/test-harness.js"
  print_item "Copying test harness...               ${CHECK}"

  cp "$SCRIPT_DIR/.agent/skills/software-tester/SKILL.md" "$ws/.agent/skills/software-tester/SKILL.md"
  print_item "Copying software-tester skill...      ${CHECK}"

  # Copy rules with platform-specific filename
  if [ -f "$ws/$rules_name" ]; then
    if [ -t 0 ]; then
      echo ""
      echo -e "      ${YELLOW}!${RESET} ${rules_name} already exists"
      echo "        1) Append  2) Replace  3) Skip"
      read -p "        Choice [1/2/3]: " rc
      case $rc in
        1) echo "" >> "$ws/$rules_name"; cat "$SCRIPT_DIR/GEMINI.md" >> "$ws/$rules_name"; print_last "Rules appended                        ${CHECK}" ;;
        2) cp "$SCRIPT_DIR/GEMINI.md" "$ws/$rules_name"; print_last "Rules replaced                        ${CHECK}" ;;
        *) print_last "Rules skipped                         ${DASH}" ;;
      esac
    else
      cp "$SCRIPT_DIR/GEMINI.md" "$ws/$rules_name"
      print_last "Rules installed                       ${CHECK}"
    fi
  else
    cp "$SCRIPT_DIR/GEMINI.md" "$ws/$rules_name"
    print_last "Rules installed (${rules_name})             ${CHECK}"
  fi

  INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
  echo ""
}

run_installations() {
  print_step 4 5 "Installing"

  $SEL_ANTIGRAVITY && do_install_antigravity
  $SEL_OPENCLAW    && do_install_openclaw

  if $SEL_CLAUDE; then
    do_install_project "$SEL_WORKSPACE" "CLAUDE.md" "Claude Code"
  fi
  if $SEL_CURSOR; then
    do_install_project "$SEL_WORKSPACE" ".cursorrules" "Cursor"
  fi
  if $SEL_WINDSURF; then
    do_install_project "$SEL_WORKSPACE" ".windsurfrules" "Windsurf"
  fi

  if [ "$INSTALLED_COUNT" -eq 0 ]; then
    echo -e "    ${YELLOW}No platforms selected. Nothing installed.${RESET}"
    echo ""
  fi
}

# ── Completion Summary ───────────────────────────────────────────
print_summary() {
  print_step 5 5 "Setup complete!"

  local stat_a stat_o stat_c stat_u stat_w
  $SEL_ANTIGRAVITY && stat_a="${CHECK}  Antigravity    2 skills + rules" || stat_a="${DASH}  Antigravity    skipped"
  $SEL_OPENCLAW    && stat_o="${CHECK}  OpenClaw       2 skills + harness" || stat_o="${DASH}  OpenClaw       skipped"
  $SEL_CLAUDE      && stat_c="${CHECK}  Claude Code    2 skills + rules" || stat_c="${DASH}  Claude Code    skipped"
  $SEL_CURSOR      && stat_u="${CHECK}  Cursor         2 skills + rules" || stat_u="${DASH}  Cursor         skipped"
  $SEL_WINDSURF    && stat_w="${CHECK}  Windsurf       2 skills + rules" || stat_w="${DASH}  Windsurf       skipped"

  echo -e "    ${CYAN}╔═══════════════════════════════════════════════╗${RESET}"
  echo -e "    ${CYAN}║${RESET}           ${BOLD}Installation Summary${RESET}               ${CYAN}║${RESET}"
  echo -e "    ${CYAN}╚═══════════════════════════════════════════════╝${RESET}"
  echo ""
  echo -e "    ${stat_a}"
  echo -e "    ${stat_o}"
  echo -e "    ${stat_c}"
  echo -e "    ${stat_u}"
  echo -e "    ${stat_w}"
  echo ""
  echo -e "    ${BOLD}Next steps:${RESET}"
  echo -e "    ${DIM}────────────────────────────────────────────${RESET}"
  echo "    1. Open your project in your AI coding agent"
  echo "    2. Say: \"Run a full QA pass on this project\""
  echo "    3. The agent will find, fix, and verify everything"
  echo ""
  echo -e "    ${BOLD}Run test harness manually:${RESET}"
  if $SEL_ANTIGRAVITY; then
    echo -e "      ${DIM}node ~/.gemini/antigravity/skills/continuous-qa/scripts/test-harness.js${RESET}"
  fi
  if $SEL_OPENCLAW; then
    echo -e "      ${DIM}node ~/.openclaw/workspace/skills/phantom-qa/scripts/test-harness.js${RESET}"
  fi
  echo ""
  echo -e "    ${DIM}Docs: https://github.com/KyleBuildsAI/phantom-qa${RESET}"
  echo ""
}

# ── Source Resolution ────────────────────────────────────────────
# When run via curl|bash, we need to clone the repo first
resolve_source() {
  # Check if we're running from the repo (local files exist)
  if [ -f "${BASH_SOURCE[0]:-}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -d "$SCRIPT_DIR/.agent/skills" ] && [ -d "$SCRIPT_DIR/.openclaw/skills" ]; then
      return 0
    fi
  fi

  # Running from pipe or files missing -- clone to temp
  echo -e "  ${DIM}Downloading PhantomQA...${RESET}"
  TEMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'phantomqa')
  SCRIPT_DIR="$TEMP_DIR/phantom-qa"
  git clone --depth 1 --quiet https://github.com/KyleBuildsAI/phantom-qa.git "$SCRIPT_DIR" 2>/dev/null
  CLEANUP_TEMP=true
  echo -e "  ${CHECK} Downloaded"
  echo ""
}

cleanup() {
  if [ "${CLEANUP_TEMP:-false}" = true ] && [ -n "${TEMP_DIR:-}" ]; then
    rm -rf "$TEMP_DIR"
  fi
}
trap cleanup EXIT

# ── Non-Interactive Mode (CLI flags) ─────────────────────────────
parse_flags() {
  INTERACTIVE=true
  FLAG_ALL=false

  while [[ $# -gt 0 ]]; do
    case $1 in
      --all) FLAG_ALL=true; INTERACTIVE=false; shift ;;
      --antigravity) SEL_ANTIGRAVITY=true; INTERACTIVE=false; shift ;;
      --openclaw) SEL_OPENCLAW=true; INTERACTIVE=false; shift ;;
      --claude) SEL_CLAUDE=true; INTERACTIVE=false; shift ;;
      --cursor) SEL_CURSOR=true; INTERACTIVE=false; shift ;;
      --windsurf) SEL_WINDSURF=true; INTERACTIVE=false; shift ;;
      --workspace) shift; SEL_WORKSPACE="${1:-.}"; shift ;;
      --help)
        echo ""
        echo "  PhantomQA Setup Wizard v${VERSION}"
        echo ""
        echo "  Usage: ./setup.sh [OPTIONS]"
        echo ""
        echo "  Interactive (default):"
        echo "    ./setup.sh              Launch the setup wizard"
        echo ""
        echo "  Non-interactive:"
        echo "    --all                   Install to all detected platforms"
        echo "    --antigravity           Install to Google Antigravity"
        echo "    --openclaw              Install to OpenClaw"
        echo "    --claude                Install for Claude Code"
        echo "    --cursor                Install for Cursor"
        echo "    --windsurf              Install for Windsurf"
        echo "    --workspace PATH        Project path for Claude/Cursor/Windsurf"
        echo ""
        echo "  One-liner install:"
        echo "    curl -sSL https://raw.githubusercontent.com/KyleBuildsAI/phantom-qa/main/setup.sh | bash"
        echo ""
        exit 0
        ;;
      *) shift ;;
    esac
  done

  # --all selects everything detected
  if $FLAG_ALL; then
    SEL_ANTIGRAVITY=$DETECTED_ANTIGRAVITY
    SEL_OPENCLAW=$DETECTED_OPENCLAW
    SEL_CLAUDE=$DETECTED_CLAUDE
    SEL_CURSOR=$DETECTED_CURSOR
    SEL_WINDSURF=$DETECTED_WINDSURF
  fi

  # If piped (no TTY on stdin), use non-interactive mode
  if ! [ -t 0 ]; then
    INTERACTIVE=false
    # Default: install to all detected platforms
    if ! $SEL_ANTIGRAVITY && ! $SEL_OPENCLAW && ! $SEL_CLAUDE && ! $SEL_CURSOR && ! $SEL_WINDSURF; then
      SEL_ANTIGRAVITY=$DETECTED_ANTIGRAVITY
      SEL_OPENCLAW=$DETECTED_OPENCLAW
    fi
  fi
}

# ── Main ─────────────────────────────────────────────────────────
main() {
  setup_colors
  print_banner
  resolve_source
  check_dependencies
  detect_platforms
  parse_flags "$@"

  if $INTERACTIVE; then
    show_menu
  else
    print_step 3 5 "Selected platforms"
    $SEL_ANTIGRAVITY && print_ok "Google Antigravity"
    $SEL_OPENCLAW    && print_ok "OpenClaw"
    $SEL_CLAUDE      && print_ok "Claude Code"
    $SEL_CURSOR      && print_ok "Cursor"
    $SEL_WINDSURF    && print_ok "Windsurf"
    echo ""
  fi

  run_installations
  print_summary
}

main "$@"
