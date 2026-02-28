# PhantomQA

**Autonomous software testing and fixing loop for AI coding agents.**

PhantomQA forces AI agents to actually verify their work, keep going until everything is clean, and never claim "done" without proof. Built for Google Antigravity, compatible with Claude Code, Cursor, and any agent-first IDE.

---

## The Problem

Every AI coding agent has the same failure mode. You ask it to test and fix your software. It makes 5-7 changes, says "the changes have been applied," and stops. It never:

- Verified the fixes actually worked
- Re-ran the tests to confirm
- Checked if its fixes broke something else
- Looked for more issues beyond the first handful
- Showed you terminal output proving anything

You end up babysitting the agent, repeatedly saying "keep going" and "did you actually check that?" That defeats the entire purpose of autonomous agents.

## The Solution

PhantomQA is a skill + rules package that wraps any AI agent in a mandatory feedback loop:

```
DISCOVER --> FIX --> VERIFY --> REASSESS --> (loop or complete)
    ^                                            |
    └────────────── new issues found ────────────┘
```

The agent cannot exit this loop without concrete terminal output proving every fix works and the full test suite passes clean. No more "I believe the changes should work." Prove it.

## How It Works

PhantomQA has three layers that work together:

### Layer 1: Rules (GEMINI.md)

A rules file that overrides the agent's default behavior. It sits at your project root or in your global Antigravity config. Key enforcements:

- **Must show terminal output** proving each fix works (not just "changes applied")
- **Must re-run tests after every change** to catch regressions
- **Must output status checkpoints every 5 fixes** so you can track progress
- **Cannot say "done"** without a final clean test run with full output shown
- **Cannot stop at an arbitrary number** -- if there are 50 issues, it fixes 50 issues
- **Must check for regressions** after each batch of fixes
- **Priority ordering** -- critical issues first, polish last

### Layer 2: Skills (.agent/skills/)

Two Antigravity Skills that the agent loads automatically based on intent:

**continuous-qa** -- The core QA methodology. Defines a 7-phase loop:
1. Discover (run test harness, inspect code)
2. Categorize (group by severity)
3. Fix (one at a time, explain each change)
4. Verify (re-run the exact test that found the issue)
5. Regression Check (full suite again)
6. Reassess (new issues? back to phase 1)
7. Final Verification (one last clean run with proof)

**software-tester** -- For testing running applications. Instructs the agent to use Antigravity's browser subagent to click every button, submit every form, navigate every link, and verify the UI works. Covers valid input, invalid input, empty submissions, state persistence, and screenshot-based proof.

### Layer 3: Test Harness (test-harness.js)

A universal testing script the agent runs to discover issues. Auto-detects your project type (JavaScript, Python, Go, Rust, Java) and runs 8 categories of checks:

| Check | What It Finds |
|-------|--------------|
| Placeholders | Lorem ipsum, TODO, FIXME, test@test, example.com, "coming soon", dummy names, suspiciously round prices, TBD/TBA markers (25+ patterns) |
| Code Quality | console.log debug statements, empty catch blocks, hardcoded secrets/passwords/API keys |
| Build | Compilation errors, build failures |
| Tests | Failing unit/integration tests |
| Dependencies | Missing node_modules, npm audit vulnerabilities, missing Python packages |
| Structure | Missing README, missing .gitignore, exposed .env files, empty directories |
| Runtime | Syntax errors in entry points, import failures |
| Linting | TypeScript errors, ESLint violations, Ruff/flake8 issues |

Outputs a structured issue catalog the agent can parse:
```
=== ISSUE CATALOG ===
CRITICAL (2):
  [ ] C-001: Hardcoded API key in config.js [config.js:14]
       Fix: Move to environment variable
  [ ] C-002: Build error: Cannot find module './utils'
       Fix: Fix the import path

ERRORS (3):
  [ ] E-001: 2 test(s) failing
  ...
```

The agent fixes issues from the catalog, then re-runs the harness. If new issues appear, the loop continues.

## Supported Platforms

| Platform | How to Use | Rules File |
|----------|-----------|------------|
| **Google Antigravity** | Drop into `.agent/skills/` + project root | `GEMINI.md` |
| **OpenClaw** | Install to `~/.openclaw/workspace/skills/` | `GEMINI.md` or project rules |
| **Claude Code** | Drop into project, rename rules file | Rename to `CLAUDE.md` |
| **Cursor** | Drop into project, rename rules file | Rename to `.cursorrules` |
| **Windsurf** | Drop into project, rename rules file | Rename to `.windsurfrules` |

The skills and test harness work identically across all platforms. Only the rules filename changes.

## Supported Models

Tested with the following models (Feb 2026):

- **Claude Opus 4.6** -- Best overall. Strongest reasoning for complex fix chains and long loops.
- **Gemini 3.1 Pro** -- Excellent. Antigravity's native model with browser subagent integration.
- **Claude Sonnet 4.6** -- Good for faster iterations on simpler projects.

The rules enforce the same behavior regardless of which model is active.

## Install

### One-Command Setup (recommended)

```bash
curl -sSL https://raw.githubusercontent.com/KyleBuildsAI/phantom-qa/main/setup.sh | bash
```

Or clone first:

```bash
git clone https://github.com/KyleBuildsAI/phantom-qa.git
cd phantom-qa
chmod +x setup.sh
./setup.sh
```

The setup wizard will:
1. Detect which AI platforms you have installed (Antigravity, OpenClaw, Claude Code, Cursor, Windsurf)
2. Let you choose where to install
3. Copy skills and rules to the right locations
4. Show a completion summary with next steps

### Advanced Install (install.sh)

For scripting or CI/CD, use the direct installer:

```bash
./install.sh                               # Antigravity global + prompt for workspace
./install.sh --global                      # Antigravity global only
./install.sh --openclaw                    # OpenClaw global only
./install.sh --workspace /path/to/project  # Workspace install only
```

### Manual Install

Copy the files directly to your project:

```bash
# For Antigravity
cp -r .agent/ /path/to/your/project/.agent/
cp GEMINI.md /path/to/your/project/GEMINI.md

# For OpenClaw
cp -r .openclaw/skills/phantom-qa/ ~/.openclaw/workspace/skills/phantom-qa/
cp -r .openclaw/skills/phantom-qa-tester/ ~/.openclaw/workspace/skills/phantom-qa-tester/

# For Claude Code
cp -r .agent/ /path/to/your/project/.agent/
cp GEMINI.md /path/to/your/project/CLAUDE.md

# For Cursor
cp -r .agent/ /path/to/your/project/.agent/
cp GEMINI.md /path/to/your/project/.cursorrules

# For Windsurf
cp -r .agent/ /path/to/your/project/.agent/
cp GEMINI.md /path/to/your/project/.windsurfrules
```

## Usage

### Start a QA Pass

Open your project in Antigravity and say:

> Run a full QA pass on this project. Find every issue -- placeholder content, broken buttons, console errors, missing validation, dead links, everything. Fix each issue, verify each fix works by re-running the test, and keep going until the test harness comes back clean. Show me terminal output at every step.

### If the Agent Stops Early

> You stopped without running the verification loop. Run the test harness again and show me the output. If there are remaining issues, continue fixing them.

### If the Agent Claims "Done" Without Proof

> You said the changes were made but didn't verify them. Run the application right now and show me the terminal output proving it works.

### Force a Final Signoff

> Run the complete test harness one final time. Show me the full output. If there are zero failures and zero critical warnings, we're done. If not, keep fixing.

### Focus on a Specific Category

> Focus on all placeholder content in the project. Scan every file for lorem ipsum, TODO markers, test emails, example.com references, and any dummy data. Replace each one with real content appropriate for the context.

### Interactive UI Testing

> Start the application and test every screen. Click every button, submit every form with both valid and invalid data, navigate every link. Fix everything that fails. Take screenshots as proof.

See `QUICKREF.md` for the full list of copy-paste prompts.

## Status Checkpoints

The agent outputs these every 5 fixes so you can track progress without micromanaging:

```
=== STATUS CHECKPOINT ===
Fixes applied: 12
Fixes verified: 12
Remaining issues: 8
Regressions found: 0
Application still runs: yes
Next action: Fixing W-005 (dead link in footer)
=========================
```

## Test Harness CLI

Run the test harness manually outside of Antigravity:

```bash
# Run in current directory
node .agent/skills/continuous-qa/scripts/test-harness.js

# Run against a different project
node .agent/skills/continuous-qa/scripts/test-harness.js --project-root /path/to/project

# View the JSON report
cat .phantom-qa-report.json | jq .
```

Exit codes:
- `0` -- All clear
- `1` -- Errors found
- `2` -- Critical issues found

## OpenClaw Integration

PhantomQA ships with native OpenClaw skills. After installation, two skills are available:

**phantom-qa** -- The core autonomous testing and fixing loop. Discovers issues using the test harness, fixes them one at a time, verifies each fix, checks for regressions, and loops until clean.

**phantom-qa-tester** -- Interactive application testing. Systematically walks through every screen, button, form, and link in a running application.

### Install for OpenClaw

```bash
# Via setup wizard (recommended)
./setup.sh

# Via install.sh
./install.sh --openclaw

# Manual
cp -r .openclaw/skills/phantom-qa/ ~/.openclaw/workspace/skills/phantom-qa/
cp -r .openclaw/skills/phantom-qa-tester/ ~/.openclaw/workspace/skills/phantom-qa-tester/
```

### JSON Integration

The test harness outputs structured JSON that OpenClaw agents can consume programmatically:

```json
{
    "name": "phantom_qa_scan",
    "description": "Run autonomous QA scan on a codebase",
    "command": "node ~/.openclaw/workspace/skills/phantom-qa/scripts/test-harness.js",
    "output_format": "json",
    "output_file": ".phantom-qa-report.json"
}
```

An OpenClaw agent can run the harness, parse the JSON report, fix issues programmatically, re-run the harness, and loop until clean -- fully autonomous.

## Customization

### Add Custom Placeholder Patterns

Edit `test-harness.js` and add patterns in the `checkPlaceholders()` function:

```javascript
{ pattern: '"your-company-specific-string"', label: "Internal placeholder" },
```

### Adjust Severity Rules

Edit `GEMINI.md` to change what counts as critical vs warning for your project.

### Add Project-Specific Skills

Create new skills in `.agent/skills/your-skill-name/SKILL.md` following the same format. Antigravity auto-detects them by matching the description against user intent.

## File Structure

```
phantom-qa/
  GEMINI.md                          # Rules enforcing the verification loop
  QUICKREF.md                        # Copy-paste prompts for common situations
  README.md                          # This file
  LICENSE                            # MIT license
  setup.sh                           # Interactive setup wizard (recommended)
  install.sh                         # Quick/advanced installer
  .agent/                            # Antigravity skills
    skills/
      continuous-qa/
        SKILL.md                     # Core QA loop methodology (7 phases)
        scripts/
          test-harness.js            # Universal test runner (any project type)
      software-tester/
        SKILL.md                     # Interactive UI/application testing
  .openclaw/                         # OpenClaw skills
    skills/
      phantom-qa/
        skill.md                     # Core QA loop (OpenClaw format)
        scripts/
          test-harness.js            # Universal test runner (same as above)
      phantom-qa-tester/
        skill.md                     # Interactive testing (OpenClaw format)
```

## Contributing

PRs welcome. Areas that need work:

- More placeholder patterns for specific frameworks (Rails, Django, Spring)
- Native desktop app testing strategies (Electron, Qt, SwiftUI)
- CI/CD pipeline integration examples (GitHub Actions, GitLab CI)
- Additional language support in the test harness (Ruby, PHP, C#)
- MCP server integration for external tool access during testing
- OpenClaw skill development and ClawHub registry publishing

## License

MIT
