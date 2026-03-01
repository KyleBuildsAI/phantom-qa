# PhantomQA

**Make your AI coding agent actually finish the job.**

You know the problem: you ask an AI agent to test and fix your project. It makes a few changes, says "done," and stops. But it never checked if the fixes actually worked. It never re-ran the tests. It never looked for more issues. You end up babysitting it, saying "keep going" and "did you actually verify that?" over and over.

PhantomQA fixes this. It's a drop-in add-on that forces your AI agent into a loop: find issues, fix them, prove the fixes work, check for new issues, and keep going until everything is clean. The agent literally cannot say "done" without showing you proof.

---

## How It Works (The Short Version)

Once installed, PhantomQA teaches your AI agent to follow this cycle:

```
FIND ISSUES --> FIX THEM --> PROVE IT WORKS --> CHECK AGAIN --> (repeat or done)
```

1. **Find** -- The agent scans your entire project for problems (broken code, placeholder text, failing tests, security issues, and more)
2. **Fix** -- It fixes each issue one at a time
3. **Prove** -- After each fix, it re-runs the test to prove the fix actually worked
4. **Check again** -- It looks for new problems that may have appeared
5. **Repeat** -- If anything is still broken, it goes back to step 1
6. **Done** -- Only when everything passes does it stop, and it shows you the proof

No more "I believe the changes should work." It has to prove it.

---

## What Does PhantomQA Actually Check?

The built-in scanner automatically detects what kind of project you have (JavaScript, Python, Go, Rust, or Java) and looks for:

| Category | Examples |
|----------|---------|
| **Placeholder content** | "Lorem ipsum", TODO comments, fake emails like test@test.com, "Coming soon" text, dummy names |
| **Code quality** | Debug statements left in the code, empty error handling, hardcoded passwords or API keys |
| **Build errors** | Code that won't compile or start |
| **Failing tests** | Any existing tests that don't pass |
| **Missing dependencies** | Packages that need to be installed, security vulnerabilities in packages |
| **Project structure** | Missing README, missing .gitignore, exposed secret files |
| **Runtime errors** | Code that crashes when you try to run it |
| **Style issues** | Linting errors, TypeScript type errors |

It finds all of these automatically. You don't need to configure anything.

---

## What Platforms Does It Work With?

PhantomQA works with all major AI coding platforms:

| Platform | Supported |
|----------|-----------|
| **Google Antigravity** | Yes (full support, including browser testing) |
| **OpenClaw** | Yes (native skills included) |
| **Claude Code** | Yes |
| **Cursor** | Yes |
| **Windsurf** | Yes |

The setup wizard handles the differences between platforms automatically. You just pick which ones you use.

---

## What AI Models Work Best?

Tested with these models (Feb 2026):

- **Claude Opus 4.6** -- Best overall. Handles long, complex testing sessions.
- **Gemini 3.1 Pro** -- Excellent. Works great with Antigravity's built-in browser testing.
- **Claude Sonnet 4.6** -- Good for faster runs on simpler projects.

PhantomQA works the same way regardless of which model you're using.

---

## Install

### Quick Setup (recommended -- no experience needed)

**Step 1: Open a terminal**

Not sure how? Here's how on each operating system:

| OS | How to open a terminal |
|----|----------------------|
| **Windows** | Press `Win + R`, type `cmd`, press Enter. Or search "Terminal" in the Start menu. |
| **Mac** | Press `Cmd + Space`, type `Terminal`, press Enter. |
| **Linux** | Press `Ctrl + Alt + T`. |

**Step 2: Download PhantomQA**

Copy and paste this entire line into your terminal and press Enter:

```bash
git clone https://github.com/KyleBuildsAI/phantom-qa.git
```

This downloads PhantomQA to a folder called `phantom-qa` inside whatever directory your terminal is currently in (usually your home folder).

**Step 3: Go into the folder and run the setup wizard**

Copy and paste these lines one at a time:

```bash
cd phantom-qa
```
```bash
bash setup.sh
```

That's it. The setup wizard will walk you through the rest:
1. It detects which AI platforms you have installed
2. It lets you choose where to install
3. It copies everything to the right places automatically
4. It shows you what to do next when it's done

> **Don't have git installed?** You can also download PhantomQA as a ZIP file. Click the green **Code** button at the top of this page, then **Download ZIP**. Unzip it, open a terminal inside the folder, and run `bash setup.sh`.

---

### Alternative: One-Line Install

If you're comfortable with the terminal, this single command downloads and runs the setup wizard automatically:

```bash
curl -sSL https://raw.githubusercontent.com/KyleBuildsAI/phantom-qa/main/setup.sh | bash
```

---

<details>
<summary><strong>Advanced Install (for scripting and CI/CD)</strong></summary>

The `install.sh` script supports direct flags for automation:

```bash
./install.sh                               # Antigravity global + prompt for workspace
./install.sh --global                      # Antigravity global only
./install.sh --openclaw                    # OpenClaw global only
./install.sh --workspace /path/to/project  # Workspace install only
```

</details>

<details>
<summary><strong>Manual Install (copy files yourself)</strong></summary>

If you prefer to copy files manually instead of using the setup wizard:

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

</details>

---

## How to Use It

After installing, open your project in your AI coding agent and tell it what to do. Here are ready-to-use prompts you can copy and paste directly into the chat.

### Run a Full QA Pass

> Run a full QA pass on this project. Find every issue -- placeholder content, broken buttons, console errors, missing validation, dead links, everything. Fix each issue, verify each fix works by re-running the test, and keep going until the test harness comes back clean. Show me terminal output at every step.

### If the Agent Stops Too Early

Sometimes the agent will stop before it's actually finished. Paste this:

> You stopped without running the verification loop. Run the test harness again and show me the output. If there are remaining issues, continue fixing them.

### If the Agent Says "Done" But Didn't Show Proof

> You said the changes were made but didn't verify them. Run the application right now and show me the terminal output proving it works.

### Force a Final Check

> Run the complete test harness one final time. Show me the full output. If there are zero failures and zero critical warnings, we're done. If not, keep fixing.

### Focus on Just Placeholder Content

> Focus on all placeholder content in the project. Scan every file for lorem ipsum, TODO markers, test emails, example.com references, and any dummy data. Replace each one with real content appropriate for the context.

### Test the UI (Click Through Everything)

> Start the application and test every screen. Click every button, submit every form with both valid and invalid data, navigate every link. Fix everything that fails. Take screenshots as proof.

See `QUICKREF.md` for more prompts.

---

## What You'll See While It's Working

The agent will show you progress checkpoints every 5 fixes, so you know it's still working and how much is left:

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

You don't need to do anything when you see these. They're just status updates so you can follow along.

---

## OpenClaw Integration

If you use OpenClaw, PhantomQA includes two native skills that install automatically:

- **phantom-qa** -- The core testing and fixing loop
- **phantom-qa-tester** -- Interactive app testing (clicks through your UI)

The setup wizard handles OpenClaw installation. You can also install manually:

```bash
./install.sh --openclaw
```

<details>
<summary><strong>JSON integration for advanced users</strong></summary>

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

</details>

---

## Under the Hood

<details>
<summary><strong>How PhantomQA works technically</strong></summary>

PhantomQA has three layers that work together:

### Layer 1: Rules (GEMINI.md)

A rules file that overrides the agent's default behavior. Key enforcements:

- Must show terminal output proving each fix works
- Must re-run tests after every change to catch regressions
- Must output status checkpoints every 5 fixes
- Cannot say "done" without a final clean test run
- Cannot stop at an arbitrary number of fixes
- Must fix critical issues first, polish last

### Layer 2: Skills

Two skills the agent loads automatically based on what you ask it to do:

**continuous-qa** -- The core QA methodology (7-phase loop: Discover, Categorize, Fix, Verify, Regression Check, Reassess, Final Verification)

**software-tester** -- For testing running applications via browser interaction (clicks every button, submits every form, navigates every link)

### Layer 3: Test Harness (test-harness.js)

A universal testing script that auto-detects your project type and runs 8 categories of checks. Outputs a structured issue catalog the agent can parse and work through systematically.

</details>

<details>
<summary><strong>Running the test harness manually</strong></summary>

You can run the scanner yourself without an AI agent:

```bash
# Run in the current project folder
node .agent/skills/continuous-qa/scripts/test-harness.js

# Run against a different project
node .agent/skills/continuous-qa/scripts/test-harness.js --project-root /path/to/project

# View the full report
cat .phantom-qa-report.json
```

Exit codes: `0` = all clear, `1` = errors found, `2` = critical issues found.

</details>

<details>
<summary><strong>Customization</strong></summary>

### Add Custom Placeholder Patterns

Edit `test-harness.js` and add patterns in the `checkPlaceholders()` function:

```javascript
{ pattern: '"your-company-specific-string"', label: "Internal placeholder" },
```

### Adjust Severity Rules

Edit `GEMINI.md` to change what counts as critical vs warning for your project.

### Add Project-Specific Skills

Create new skills in `.agent/skills/your-skill-name/SKILL.md` following the same format. The agent auto-detects them by matching the description against what you ask it to do.

</details>

<details>
<summary><strong>File structure</strong></summary>

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

</details>

---

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
