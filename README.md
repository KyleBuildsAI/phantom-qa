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

- **Claude Opus 4.6** -- Best overall. Handles long, complex testing sessions without stopping early.
- **Claude Sonnet 4.6** -- Good for faster runs on simpler projects.
- **Gemini 3.1 Pro** -- Excellent. Works great with Antigravity's built-in browser testing.

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

Then run the setup wizard. **Use the command for your operating system:**

| OS | Command |
|----|---------|
| **Mac / Linux** | `bash setup.sh` |
| **Windows (PowerShell or CMD)** | `& "C:\Program Files\Git\bin\bash.exe" setup.sh` |
| **Windows (Git Bash)** | `./setup.sh` |

> **Windows note:** If you just type `bash setup.sh` on Windows, it may try to use WSL instead of Git Bash and give an error. The command above uses Git Bash directly, which is what you want.

That's it. The setup wizard will walk you through the rest:
1. It detects which AI platforms you have installed
2. It lets you choose where to install
3. It copies everything to the right places automatically
4. It shows you what to do next when it's done

> **Don't have git installed?** You can also download PhantomQA as a ZIP file. Click the green **Code** button at the top of this page, then **Download ZIP**. Unzip it, open a terminal inside the folder, and run the setup command for your OS from the table above.

---

### Verify It's Installed

After running the setup wizard, here's how to confirm PhantomQA is actually installed for each platform.

**Google Antigravity:**

Open a terminal and run:

```bash
ls ~/.gemini/antigravity/skills/continuous-qa/SKILL.md
```

If it prints the file path back to you, it's installed. If it says "No such file or directory," the install didn't work -- run `bash setup.sh` again and make sure you select Antigravity.

You can also check the rules file:

```bash
cat ~/.gemini/antigravity/GEMINI.md
```

You should see text that starts with "# Project Rules" and mentions "Continuous Verification Loop."

**Claude Code:**

Go to the project folder where you installed PhantomQA and run:

```bash
ls .agent/skills/continuous-qa/SKILL.md
```

Also check the rules file:

```bash
cat CLAUDE.md
```

You should see the same "Continuous Verification Loop" rules.

**OpenClaw:**

```bash
ls ~/.openclaw/workspace/skills/phantom-qa/skill.md
```

If it prints the path, you're good.

**Cursor / Windsurf:**

Go to the project folder and check:

```bash
ls .agent/skills/continuous-qa/SKILL.md
```

And check for the rules file (`.cursorrules` for Cursor, `.windsurfrules` for Windsurf):

```bash
ls .cursorrules    # Cursor
ls .windsurfrules  # Windsurf
```

---

## How to Use It With Google Antigravity

This is a step-by-step walkthrough. Follow it exactly.

**Step 1: Make sure PhantomQA is installed for Antigravity**

If you haven't already, open a terminal and run:

```bash
cd phantom-qa
bash setup.sh
```

When the wizard asks which platforms to install for, make sure **Google Antigravity** is selected (it should be auto-detected if you have Antigravity installed). Press Enter to continue, then let it finish.

**Step 2: Open your project in Antigravity**

1. Open Google Antigravity
2. Click **File > Open Folder** (or drag your project folder into the window)
3. Navigate to the project you want to test and open it

**Step 3: Tell the agent to run PhantomQA**

In the Agent Manager chat panel, paste this prompt:

> Run a full QA pass on this project. Find every issue -- placeholder content, broken buttons, console errors, missing validation, dead links, everything. Fix each issue, verify each fix works by re-running the test, and keep going until the test harness comes back clean. Show me terminal output at every step.

Press Enter. The agent will:
- Automatically load the `continuous-qa` skill (it matches your request)
- Run the test harness to scan your entire project
- Start fixing issues one by one
- Re-run the test after each fix to prove it worked
- Keep going until everything is clean

**Step 4: Sit back and watch**

You'll see status checkpoints every 5 fixes:

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

You don't need to do anything. Just let it run.

**Step 5: If the agent stops early**

Sometimes the agent stops before it's truly done. Paste this:

> You stopped without running the verification loop. Run the test harness again and show me the output. If there are remaining issues, continue fixing them.

**How Antigravity finds PhantomQA's skills:**

When you installed PhantomQA for Antigravity, the setup wizard copied two skills into `~/.gemini/antigravity/skills/`:
- `continuous-qa` -- the core find-fix-verify loop
- `software-tester` -- interactive UI testing (clicking buttons, filling forms)

It also installed a rules file at `~/.gemini/antigravity/GEMINI.md` that forces the agent to follow the verification loop no matter what.

Antigravity automatically reads skills from `~/.gemini/antigravity/skills/` and loads them when your request matches their description. You don't need to manually activate anything -- just describe what you want and the right skill loads automatically.

---

## How to Use It With Claude Code

**Step 1: Install PhantomQA into your project**

Open a terminal, navigate to your project folder, and run the setup wizard:

```bash
cd /path/to/your/project
```

Then clone PhantomQA (if you haven't already) and run setup:

```bash
git clone https://github.com/KyleBuildsAI/phantom-qa.git /tmp/phantom-qa
cd /tmp/phantom-qa
bash setup.sh
```

When the wizard asks which platforms to install for, select **Claude Code**. It will ask for your workspace path -- type the full path to your project folder (for example: `/home/yourname/my-project`).

This copies the skills into your project's `.agent/skills/` directory and creates a `CLAUDE.md` rules file in your project root.

**Step 2: Start Claude Code in your project**

Open a terminal in your project folder and launch Claude Code:

```bash
cd /path/to/your/project
claude
```

Claude Code automatically reads `CLAUDE.md` from your project root. The verification loop rules are now active.

**Step 3: Tell Claude to run PhantomQA**

In the Claude Code prompt, paste:

> Run a full QA pass on this project. Find every issue -- placeholder content, broken buttons, console errors, missing validation, dead links, everything. Fix each issue, verify each fix works by re-running the test, and keep going until the test harness comes back clean. Show me terminal output at every step.

Claude will follow the same find-fix-verify loop. It reads the rules from `CLAUDE.md` and uses the skills from `.agent/skills/`.

---

## How to Use It With OpenClaw

**Step 1: Install PhantomQA for OpenClaw**

```bash
cd phantom-qa
bash setup.sh
```

Select **OpenClaw** when the wizard asks. It copies two native skills into `~/.openclaw/workspace/skills/`:
- `phantom-qa` -- the core QA loop
- `phantom-qa-tester` -- interactive app testing

**Step 2: Use the skills in OpenClaw**

The skills are available globally to all OpenClaw agents. Any agent can invoke them by matching against the skill description. To trigger a QA pass, tell your agent:

> Run a full QA pass on this project. Find every issue, fix each one, verify each fix works, and keep going until the test harness comes back clean.

**Step 3: Run the test harness directly (optional)**

You can also run the scanner standalone from any project folder:

```bash
node ~/.openclaw/workspace/skills/phantom-qa/scripts/test-harness.js --project-root /path/to/project
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

## Alternative Install Methods

### One-Line Install

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

**For Antigravity (global -- works in every project):**

```bash
# Create the skill directories
mkdir -p ~/.gemini/antigravity/skills/continuous-qa/scripts
mkdir -p ~/.gemini/antigravity/skills/software-tester

# Copy the skills
cp .agent/skills/continuous-qa/SKILL.md ~/.gemini/antigravity/skills/continuous-qa/SKILL.md
cp .agent/skills/continuous-qa/scripts/test-harness.js ~/.gemini/antigravity/skills/continuous-qa/scripts/test-harness.js
cp .agent/skills/software-tester/SKILL.md ~/.gemini/antigravity/skills/software-tester/SKILL.md

# Copy the rules
cp GEMINI.md ~/.gemini/antigravity/GEMINI.md
```

**For OpenClaw (global -- works in every agent):**

```bash
mkdir -p ~/.openclaw/workspace/skills/phantom-qa/scripts
mkdir -p ~/.openclaw/workspace/skills/phantom-qa-tester
cp .openclaw/skills/phantom-qa/skill.md ~/.openclaw/workspace/skills/phantom-qa/skill.md
cp .openclaw/skills/phantom-qa/scripts/test-harness.js ~/.openclaw/workspace/skills/phantom-qa/scripts/test-harness.js
cp .openclaw/skills/phantom-qa-tester/skill.md ~/.openclaw/workspace/skills/phantom-qa-tester/skill.md
```

**For Claude Code (per-project):**

```bash
# Run this inside your project folder
mkdir -p .agent/skills/continuous-qa/scripts
mkdir -p .agent/skills/software-tester
cp /path/to/phantom-qa/.agent/skills/continuous-qa/SKILL.md .agent/skills/continuous-qa/SKILL.md
cp /path/to/phantom-qa/.agent/skills/continuous-qa/scripts/test-harness.js .agent/skills/continuous-qa/scripts/test-harness.js
cp /path/to/phantom-qa/.agent/skills/software-tester/SKILL.md .agent/skills/software-tester/SKILL.md
cp /path/to/phantom-qa/GEMINI.md CLAUDE.md
```

**For Cursor (per-project):**

```bash
# Same as Claude Code, but the rules file is named .cursorrules
mkdir -p .agent/skills/continuous-qa/scripts
mkdir -p .agent/skills/software-tester
cp /path/to/phantom-qa/.agent/skills/continuous-qa/SKILL.md .agent/skills/continuous-qa/SKILL.md
cp /path/to/phantom-qa/.agent/skills/continuous-qa/scripts/test-harness.js .agent/skills/continuous-qa/scripts/test-harness.js
cp /path/to/phantom-qa/.agent/skills/software-tester/SKILL.md .agent/skills/software-tester/SKILL.md
cp /path/to/phantom-qa/GEMINI.md .cursorrules
```

**For Windsurf (per-project):**

```bash
# Same as Claude Code, but the rules file is named .windsurfrules
mkdir -p .agent/skills/continuous-qa/scripts
mkdir -p .agent/skills/software-tester
cp /path/to/phantom-qa/.agent/skills/continuous-qa/SKILL.md .agent/skills/continuous-qa/SKILL.md
cp /path/to/phantom-qa/.agent/skills/continuous-qa/scripts/test-harness.js .agent/skills/continuous-qa/scripts/test-harness.js
cp /path/to/phantom-qa/.agent/skills/software-tester/SKILL.md .agent/skills/software-tester/SKILL.md
cp /path/to/phantom-qa/GEMINI.md .windsurfrules
```

</details>

---

## More Prompts You Can Use

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

See `QUICKREF.md` for even more prompts.

---

## Troubleshooting

### "Command not found" when running bash setup.sh

Make sure you're inside the `phantom-qa` folder first:

```bash
cd phantom-qa
bash setup.sh
```

If you downloaded the ZIP file, the folder might be named `phantom-qa-main` instead:

```bash
cd phantom-qa-main
bash setup.sh
```

### The agent isn't using PhantomQA's skills

- **Antigravity:** Check that the files exist at `~/.gemini/antigravity/skills/continuous-qa/SKILL.md`. If not, run the setup wizard again.
- **Claude Code:** Check that `CLAUDE.md` and `.agent/skills/` exist in your project root. PhantomQA must be installed per-project for Claude Code.
- **OpenClaw:** Check that `~/.openclaw/workspace/skills/phantom-qa/skill.md` exists.

### The test harness says "node: command not found"

The test harness requires Node.js. Install it from [nodejs.org](https://nodejs.org/) (download the LTS version). The skills themselves still work without Node.js -- the agent just won't be able to run the automated scanner. It will still follow the verification loop using other methods.

### The agent keeps stopping after a few fixes

Paste this into the chat:

> You stopped without running the verification loop. Run the test harness again and show me the output. If there are remaining issues, continue fixing them. Don't stop until the report is clean.

This is normal. Some models need a nudge to keep going through long sessions. Claude Opus 4.6 handles this best.

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
  .agent/                            # Antigravity / Claude Code / Cursor / Windsurf skills
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
