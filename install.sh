#!/bin/bash

# PhantomQA Quick Installer
# Installs skills globally for any supported AI coding platform

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "  ╔══════════════════════════════════════════════════╗"
echo "  ║          PhantomQA Quick Installer               ║"
echo "  ╚══════════════════════════════════════════════════╝"
echo ""

# Parse args
INSTALL_MODE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --global|--antigravity) INSTALL_MODE="antigravity"; shift ;;
    --openclaw) INSTALL_MODE="openclaw"; shift ;;
    --claude) INSTALL_MODE="claude"; shift ;;
    --cursor) INSTALL_MODE="cursor"; shift ;;
    --windsurf) INSTALL_MODE="windsurf"; shift ;;
    --all) INSTALL_MODE="all"; shift ;;
    --help)
      echo "  Usage: ./install.sh [OPTIONS]"
      echo ""
      echo "  Options:"
      echo "    --antigravity     Install to Google Antigravity (~/.gemini/antigravity/skills/)"
      echo "    --openclaw        Install to OpenClaw (~/.openclaw/workspace/skills/)"
      echo "    --claude          Install to Claude Code (~/.claude/skills/)"
      echo "    --cursor          Install to Cursor (~/.cursor/skills/)"
      echo "    --windsurf        Install to Windsurf (~/.codeium/windsurf/skills/)"
      echo "    --all             Install to all detected platforms"
      echo "    (no args)         Install to Antigravity (default)"
      echo ""
      exit 0
      ;;
    *) shift ;;
  esac
done

# Default to antigravity if no flag specified
INSTALL_MODE="${INSTALL_MODE:-antigravity}"

# ── Antigravity Install ─────────────────────────────────────────
install_antigravity() {
  local skills_dir="$HOME/.gemini/antigravity/skills"
  local rules_dir="$HOME/.gemini/antigravity"

  echo "  Installing to Antigravity ($skills_dir) ..."

  mkdir -p "$skills_dir/continuous-qa/scripts"
  mkdir -p "$skills_dir/software-tester/scripts"

  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/SKILL.md" "$skills_dir/continuous-qa/SKILL.md"
  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/scripts/test-harness.js" "$skills_dir/continuous-qa/scripts/test-harness.js"
  cp "$SCRIPT_DIR/.agent/skills/software-tester/SKILL.md" "$skills_dir/software-tester/SKILL.md"

  echo "  [OK] Antigravity skills installed"

  # Install global rules
  local rules_file="$rules_dir/GEMINI.md"
  if [ -f "$rules_file" ]; then
    echo ""
    echo "  GEMINI.md already exists at $rules_file"
    echo "  Would you like to:"
    echo "    1) Append PhantomQA rules (Recommended)"
    echo "    2) Replace with PhantomQA rules"
    echo "    3) Skip (don't modify rules)"
    read -p "  Choice [1/2/3]: " choice
    case $choice in
      1|"") echo "" >> "$rules_file"; cat "$SCRIPT_DIR/GEMINI.md" >> "$rules_file"; echo "  [OK] Rules appended" ;;
      2) cp "$SCRIPT_DIR/GEMINI.md" "$rules_file"; echo "  [OK] Rules replaced" ;;
      3) echo "  [SKIP] Rules unchanged" ;;
    esac
  else
    mkdir -p "$rules_dir"
    cp "$SCRIPT_DIR/GEMINI.md" "$rules_file"
    echo "  [OK] Rules installed"
  fi
}

# ── OpenClaw Install ────────────────────────────────────────────
install_openclaw() {
  local skills_dir=""
  if [ -d "$HOME/.openclaw/workspace/skills" ]; then
    skills_dir="$HOME/.openclaw/workspace/skills"
  elif [ -d "$HOME/.openclaw/skills" ]; then
    skills_dir="$HOME/.openclaw/skills"
  elif [ -d "$HOME/.openclaw" ]; then
    skills_dir="$HOME/.openclaw/workspace/skills"
  else
    echo "  [ERROR] OpenClaw not found (~/.openclaw/ does not exist)"
    echo "  Install OpenClaw first: npm install -g openclaw@latest"
    return 1
  fi

  echo "  Installing to OpenClaw ($skills_dir) ..."

  mkdir -p "$skills_dir/phantom-qa/scripts"
  mkdir -p "$skills_dir/phantom-qa-tester"

  cp "$SCRIPT_DIR/.openclaw/skills/phantom-qa/skill.md" "$skills_dir/phantom-qa/skill.md"
  cp "$SCRIPT_DIR/.openclaw/skills/phantom-qa/scripts/test-harness.js" "$skills_dir/phantom-qa/scripts/test-harness.js"
  cp "$SCRIPT_DIR/.openclaw/skills/phantom-qa-tester/skill.md" "$skills_dir/phantom-qa-tester/skill.md"

  echo "  [OK] OpenClaw skills installed"
}

# ── Claude Code Install ─────────────────────────────────────────
install_claude() {
  local skills_dir="$HOME/.claude/skills"

  echo "  Installing to Claude Code ($skills_dir) ..."

  mkdir -p "$skills_dir/continuous-qa/scripts"
  mkdir -p "$skills_dir/software-tester/scripts"

  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/SKILL.md" "$skills_dir/continuous-qa/SKILL.md"
  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/scripts/test-harness.js" "$skills_dir/continuous-qa/scripts/test-harness.js"
  cp "$SCRIPT_DIR/.agent/skills/software-tester/SKILL.md" "$skills_dir/software-tester/SKILL.md"

  echo "  [OK] Claude Code skills installed"

  # Install global rules
  local rules_file="$HOME/.claude/CLAUDE.md"
  if [ -f "$rules_file" ]; then
    echo ""
    echo "  CLAUDE.md already exists at $rules_file"
    echo "  Would you like to:"
    echo "    1) Append PhantomQA rules (Recommended)"
    echo "    2) Replace with PhantomQA rules"
    echo "    3) Skip (don't modify rules)"
    read -p "  Choice [1/2/3]: " choice
    case $choice in
      1|"") echo "" >> "$rules_file"; cat "$SCRIPT_DIR/GEMINI.md" >> "$rules_file"; echo "  [OK] Rules appended" ;;
      2) cp "$SCRIPT_DIR/GEMINI.md" "$rules_file"; echo "  [OK] Rules replaced" ;;
      3) echo "  [SKIP] Rules unchanged" ;;
    esac
  else
    mkdir -p "$HOME/.claude"
    cp "$SCRIPT_DIR/GEMINI.md" "$rules_file"
    echo "  [OK] Rules installed"
  fi
}

# ── Cursor Install ──────────────────────────────────────────────
install_cursor() {
  local skills_dir="$HOME/.cursor/skills"

  echo "  Installing to Cursor ($skills_dir) ..."

  mkdir -p "$skills_dir/continuous-qa/scripts"
  mkdir -p "$skills_dir/software-tester/scripts"

  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/SKILL.md" "$skills_dir/continuous-qa/SKILL.md"
  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/scripts/test-harness.js" "$skills_dir/continuous-qa/scripts/test-harness.js"
  cp "$SCRIPT_DIR/.agent/skills/software-tester/SKILL.md" "$skills_dir/software-tester/SKILL.md"

  echo "  [OK] Cursor skills installed"
}

# ── Windsurf Install ────────────────────────────────────────────
install_windsurf() {
  local skills_dir="$HOME/.codeium/windsurf/skills"

  echo "  Installing to Windsurf ($skills_dir) ..."

  mkdir -p "$skills_dir/continuous-qa/scripts"
  mkdir -p "$skills_dir/software-tester/scripts"

  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/SKILL.md" "$skills_dir/continuous-qa/SKILL.md"
  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/scripts/test-harness.js" "$skills_dir/continuous-qa/scripts/test-harness.js"
  cp "$SCRIPT_DIR/.agent/skills/software-tester/SKILL.md" "$skills_dir/software-tester/SKILL.md"

  echo "  [OK] Windsurf skills installed"

  # Install global rules
  local rules_file="$HOME/.codeium/windsurf/memories/global_rules.md"
  if [ -f "$rules_file" ]; then
    echo ""
    echo "  global_rules.md already exists at $rules_file"
    echo "  Would you like to:"
    echo "    1) Append PhantomQA rules (Recommended)"
    echo "    2) Replace with PhantomQA rules"
    echo "    3) Skip (don't modify rules)"
    read -p "  Choice [1/2/3]: " choice
    case $choice in
      1|"") echo "" >> "$rules_file"; cat "$SCRIPT_DIR/GEMINI.md" >> "$rules_file"; echo "  [OK] Rules appended" ;;
      2) cp "$SCRIPT_DIR/GEMINI.md" "$rules_file"; echo "  [OK] Rules replaced" ;;
      3) echo "  [SKIP] Rules unchanged" ;;
    esac
  else
    mkdir -p "$HOME/.codeium/windsurf/memories"
    cp "$SCRIPT_DIR/GEMINI.md" "$rules_file"
    echo "  [OK] Rules installed"
  fi
}

# ── Run Install ─────────────────────────────────────────────────
case $INSTALL_MODE in
  antigravity)
    install_antigravity
    ;;
  openclaw)
    install_openclaw
    ;;
  claude)
    install_claude
    ;;
  cursor)
    install_cursor
    ;;
  windsurf)
    install_windsurf
    ;;
  all)
    [ -d "$HOME/.gemini" ]    && install_antigravity && echo ""
    [ -d "$HOME/.openclaw" ]  && install_openclaw && echo ""
    (command -v claude &>/dev/null || [ -d "$HOME/.claude" ])    && install_claude && echo ""
    (command -v cursor &>/dev/null || [ -d "$HOME/.cursor" ])    && install_cursor && echo ""
    (command -v windsurf &>/dev/null || [ -d "$HOME/.codeium" ]) && install_windsurf && echo ""
    ;;
esac

echo ""
echo "  ════════════════════════════════════════════════════"
echo "  Installation complete!"
echo ""
echo "  Next steps:"
echo "    1. Open your project in your AI coding agent"
echo "    2. Say: 'Run a full QA pass on this project'"
echo "    3. The agent will find, fix, and verify everything"
echo "  ════════════════════════════════════════════════════"
echo ""
