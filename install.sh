#!/bin/bash

# PhantomQA Installer for Google Antigravity and OpenClaw
# Installs skills globally and/or into the current workspace

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_SKILLS_DIR="$HOME/.gemini/antigravity/skills"
GLOBAL_RULES_DIR="$HOME/.gemini/antigravity"

echo ""
echo "  ╔══════════════════════════════════════════════════╗"
echo "  ║          PhantomQA Quick Installer               ║"
echo "  ╚══════════════════════════════════════════════════╝"
echo ""

# Parse args
INSTALL_MODE="both"
WORKSPACE_DIR=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --global) INSTALL_MODE="global"; shift ;;
    --openclaw) INSTALL_MODE="openclaw"; shift ;;
    --workspace) INSTALL_MODE="workspace"; shift; WORKSPACE_DIR="${1:-.}"; shift ;;
    --help)
      echo "  Usage: ./install.sh [OPTIONS]"
      echo ""
      echo "  Options:"
      echo "    --global          Install Antigravity skills globally only"
      echo "    --openclaw        Install OpenClaw skills globally only"
      echo "    --workspace PATH  Install into a specific workspace"
      echo "    (no args)         Install globally + prompt for workspace"
      echo ""
      exit 0
      ;;
    *) WORKSPACE_DIR="$1"; shift ;;
  esac
done

# ── Global Install ───────────────────────────────────────────────
install_global() {
  echo "  Installing globally to $GLOBAL_SKILLS_DIR ..."

  mkdir -p "$GLOBAL_SKILLS_DIR/continuous-qa/scripts"
  mkdir -p "$GLOBAL_SKILLS_DIR/software-tester/scripts"

  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/SKILL.md" "$GLOBAL_SKILLS_DIR/continuous-qa/SKILL.md"
  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/scripts/test-harness.js" "$GLOBAL_SKILLS_DIR/continuous-qa/scripts/test-harness.js"
  cp "$SCRIPT_DIR/.agent/skills/software-tester/SKILL.md" "$GLOBAL_SKILLS_DIR/software-tester/SKILL.md"

  echo "  [OK] Global skills installed"

  # Install global rules (append, don't overwrite)
  GLOBAL_RULES_FILE="$GLOBAL_RULES_DIR/GEMINI.md"
  if [ -f "$GLOBAL_RULES_FILE" ]; then
    echo ""
    echo "  Global GEMINI.md already exists at $GLOBAL_RULES_FILE"
    echo "  Would you like to:"
    echo "    1) Append PhantomQA rules"
    echo "    2) Replace with PhantomQA rules"
    echo "    3) Skip (don't modify global rules)"
    read -p "  Choice [1/2/3]: " choice
    case $choice in
      1) echo "" >> "$GLOBAL_RULES_FILE"; cat "$SCRIPT_DIR/GEMINI.md" >> "$GLOBAL_RULES_FILE"; echo "  [OK] Rules appended" ;;
      2) cp "$SCRIPT_DIR/GEMINI.md" "$GLOBAL_RULES_FILE"; echo "  [OK] Rules replaced" ;;
      3) echo "  [SKIP] Global rules unchanged" ;;
    esac
  else
    mkdir -p "$GLOBAL_RULES_DIR"
    cp "$SCRIPT_DIR/GEMINI.md" "$GLOBAL_RULES_FILE"
    echo "  [OK] Global rules installed"
  fi
}

# ── OpenClaw Install ─────────────────────────────────────────────
install_openclaw() {
  # Determine OpenClaw skills directory
  local OPENCLAW_SKILLS_DIR=""
  if [ -d "$HOME/.openclaw/workspace/skills" ]; then
    OPENCLAW_SKILLS_DIR="$HOME/.openclaw/workspace/skills"
  elif [ -d "$HOME/.openclaw/skills" ]; then
    OPENCLAW_SKILLS_DIR="$HOME/.openclaw/skills"
  elif [ -d "$HOME/.openclaw" ]; then
    OPENCLAW_SKILLS_DIR="$HOME/.openclaw/workspace/skills"
  else
    echo "  [ERROR] OpenClaw not found (~/.openclaw/ does not exist)"
    echo "  Install OpenClaw first: npm install -g openclaw@latest"
    return 1
  fi

  echo "  Installing OpenClaw skills to $OPENCLAW_SKILLS_DIR ..."

  mkdir -p "$OPENCLAW_SKILLS_DIR/phantom-qa/scripts"
  mkdir -p "$OPENCLAW_SKILLS_DIR/phantom-qa-tester"

  cp "$SCRIPT_DIR/.openclaw/skills/phantom-qa/skill.md" "$OPENCLAW_SKILLS_DIR/phantom-qa/skill.md"
  cp "$SCRIPT_DIR/.openclaw/skills/phantom-qa/scripts/test-harness.js" "$OPENCLAW_SKILLS_DIR/phantom-qa/scripts/test-harness.js"
  cp "$SCRIPT_DIR/.openclaw/skills/phantom-qa-tester/skill.md" "$OPENCLAW_SKILLS_DIR/phantom-qa-tester/skill.md"

  echo "  [OK] OpenClaw skills installed"
}

# ── Workspace Install ────────────────────────────────────────────
install_workspace() {
  local ws="$1"
  echo ""
  echo "  Installing to workspace: $ws"

  mkdir -p "$ws/.agent/skills/continuous-qa/scripts"
  mkdir -p "$ws/.agent/skills/software-tester/scripts"

  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/SKILL.md" "$ws/.agent/skills/continuous-qa/SKILL.md"
  cp "$SCRIPT_DIR/.agent/skills/continuous-qa/scripts/test-harness.js" "$ws/.agent/skills/continuous-qa/scripts/test-harness.js"
  cp "$SCRIPT_DIR/.agent/skills/software-tester/SKILL.md" "$ws/.agent/skills/software-tester/SKILL.md"

  echo "  [OK] Workspace skills installed"

  # Copy GEMINI.md to workspace root
  if [ -f "$ws/GEMINI.md" ]; then
    echo "  Workspace GEMINI.md already exists."
    read -p "  Append PhantomQA rules? [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      echo "" >> "$ws/GEMINI.md"
      cat "$SCRIPT_DIR/GEMINI.md" >> "$ws/GEMINI.md"
      echo "  [OK] Rules appended to workspace"
    fi
  else
    cp "$SCRIPT_DIR/GEMINI.md" "$ws/GEMINI.md"
    echo "  [OK] Workspace rules installed"
  fi
}

# ── Run Install ──────────────────────────────────────────────────
case $INSTALL_MODE in
  global)
    install_global
    ;;
  openclaw)
    install_openclaw
    ;;
  workspace)
    install_workspace "${WORKSPACE_DIR:-.}"
    ;;
  both)
    install_global
    echo ""
    read -p "  Also install to a workspace? [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      read -p "  Workspace path (or . for current dir): " ws_path
      install_workspace "${ws_path:-.}"
    fi
    ;;
esac

echo ""
echo "  ════════════════════════════════════════════════════"
echo "  Installation complete!"
echo ""
echo "  Next steps:"
echo "    1. Open your project in Antigravity"
echo "    2. In the agent chat, say:"
echo "       'Run a full QA pass on this project. Find and fix every issue.'"
echo "    3. The agent will use the continuous-qa skill automatically"
echo "    4. It will loop until everything is clean"
echo ""
echo "  To run the test harness manually:"
echo "    node .agent/skills/continuous-qa/scripts/test-harness.js"
echo "  ════════════════════════════════════════════════════"
echo ""
