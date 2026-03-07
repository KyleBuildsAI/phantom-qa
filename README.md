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

```bash
ls ~/.claude/skills/continuous-qa/SKILL.md
```

Also check the rules file:

```bash
cat ~/.claude/CLAUDE.md
```

You should see the same "Continuous Verification Loop" rules.

**OpenClaw:**

```bash
ls ~/.openclaw/workspace/skills/phantom-qa/skill.md
```

If it prints the path, you're good.

**Cursor:**

```bash
ls ~/.cursor/skills/continuous-qa/SKILL.md
```

**Windsurf:**

```bash
ls ~/.codeium/windsurf/skills/continuous-qa/SKILL.md
```

Also check the rules file:

```bash
cat ~/.codeium/windsurf/memories/global_rules.md
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

When you installed PhantomQA for Antigravity, the setup wizard copied three skills into `~/.gemini/antigravity/skills/`:
- `continuous-qa` -- the core find-fix-verify loop
- `software-tester` -- interactive UI testing (clicking buttons, filling forms)
- `phantom-depth` -- advanced GUI automation with full mouse/keyboard control, screenshots, performance profiling, and autonomous improvement

It also installed a rules file at `~/.gemini/antigravity/GEMINI.md` that forces the agent to follow the verification loop no matter what.

Antigravity automatically reads skills from `~/.gemini/antigravity/skills/` and loads them when your request matches their description. You don't need to manually activate anything -- just describe what you want and the right skill loads automatically.

---

## How to Use It With Claude Code

**Step 1: Make sure PhantomQA is installed for Claude Code**

If you haven't already, run the setup wizard (see Install above). When the wizard shows the platform list, make sure **Claude Code** is selected (it should be auto-detected if you have Claude Code installed). Press Enter and let it finish.

The setup wizard copies the skills to `~/.claude/skills/` and creates a rules file at `~/.claude/CLAUDE.md`. These are global -- they work in every project automatically.

**Step 2: Open any project in Claude Code**

Open a terminal in any project folder and launch Claude Code:

```bash
cd /path/to/your/project
claude
```

Claude Code automatically reads skills from `~/.claude/skills/` and rules from `~/.claude/CLAUDE.md`. The verification loop is active in every project, no per-project setup needed.

**Step 3: Tell Claude to run PhantomQA**

In the Claude Code prompt, paste:

> Run a full QA pass on this project. Find every issue -- placeholder content, broken buttons, console errors, missing validation, dead links, everything. Fix each issue, verify each fix works by re-running the test, and keep going until the test harness comes back clean. Show me terminal output at every step.

Claude will follow the same find-fix-verify loop as Antigravity. It reads the rules from `~/.claude/CLAUDE.md` and uses the skills from `~/.claude/skills/`.

---

## How to Use It With OpenClaw

**Step 1: Install PhantomQA for OpenClaw**

```bash
cd phantom-qa
bash setup.sh
```

Select **OpenClaw** when the wizard asks. It copies three native skills into `~/.openclaw/workspace/skills/`:
- `phantom-qa` -- the core QA loop
- `phantom-qa-tester` -- interactive app testing
- `phantom-depth` -- advanced GUI automation with full mouse/keyboard control

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
./install.sh                    # Antigravity (default)
./install.sh --antigravity      # Antigravity only
./install.sh --openclaw         # OpenClaw only
./install.sh --claude           # Claude Code only
./install.sh --cursor           # Cursor only
./install.sh --windsurf         # Windsurf only
./install.sh --all              # All detected platforms
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
mkdir -p ~/.gemini/antigravity/skills/phantom-depth

# Copy the skills
cp .agent/skills/continuous-qa/SKILL.md ~/.gemini/antigravity/skills/continuous-qa/SKILL.md
cp .agent/skills/continuous-qa/scripts/test-harness.js ~/.gemini/antigravity/skills/continuous-qa/scripts/test-harness.js
cp .agent/skills/software-tester/SKILL.md ~/.gemini/antigravity/skills/software-tester/SKILL.md
cp .agent/skills/phantom-depth/SKILL.md ~/.gemini/antigravity/skills/phantom-depth/SKILL.md

# Copy the rules
cp GEMINI.md ~/.gemini/antigravity/GEMINI.md
```

**For OpenClaw (global -- works in every agent):**

```bash
mkdir -p ~/.openclaw/workspace/skills/phantom-qa/scripts
mkdir -p ~/.openclaw/workspace/skills/phantom-qa-tester
mkdir -p ~/.openclaw/workspace/skills/phantom-depth
cp .openclaw/skills/phantom-qa/skill.md ~/.openclaw/workspace/skills/phantom-qa/skill.md
cp .openclaw/skills/phantom-qa/scripts/test-harness.js ~/.openclaw/workspace/skills/phantom-qa/scripts/test-harness.js
cp .openclaw/skills/phantom-qa-tester/skill.md ~/.openclaw/workspace/skills/phantom-qa-tester/skill.md
cp .openclaw/skills/phantom-depth/skill.md ~/.openclaw/workspace/skills/phantom-depth/skill.md
```

**For Claude Code (global -- works in every project):**

```bash
mkdir -p ~/.claude/skills/continuous-qa/scripts
mkdir -p ~/.claude/skills/software-tester
mkdir -p ~/.claude/skills/phantom-depth
cp /path/to/phantom-qa/.agent/skills/continuous-qa/SKILL.md ~/.claude/skills/continuous-qa/SKILL.md
cp /path/to/phantom-qa/.agent/skills/continuous-qa/scripts/test-harness.js ~/.claude/skills/continuous-qa/scripts/test-harness.js
cp /path/to/phantom-qa/.agent/skills/software-tester/SKILL.md ~/.claude/skills/software-tester/SKILL.md
cp /path/to/phantom-qa/.agent/skills/phantom-depth/SKILL.md ~/.claude/skills/phantom-depth/SKILL.md
cp /path/to/phantom-qa/GEMINI.md ~/.claude/CLAUDE.md
```

**For Cursor (global -- works in every project):**

```bash
mkdir -p ~/.cursor/skills/continuous-qa/scripts
mkdir -p ~/.cursor/skills/software-tester
mkdir -p ~/.cursor/skills/phantom-depth
cp /path/to/phantom-qa/.agent/skills/continuous-qa/SKILL.md ~/.cursor/skills/continuous-qa/SKILL.md
cp /path/to/phantom-qa/.agent/skills/continuous-qa/scripts/test-harness.js ~/.cursor/skills/continuous-qa/scripts/test-harness.js
cp /path/to/phantom-qa/.agent/skills/software-tester/SKILL.md ~/.cursor/skills/software-tester/SKILL.md
cp /path/to/phantom-qa/.agent/skills/phantom-depth/SKILL.md ~/.cursor/skills/phantom-depth/SKILL.md
```

**For Windsurf (global -- works in every project):**

```bash
mkdir -p ~/.codeium/windsurf/skills/continuous-qa/scripts
mkdir -p ~/.codeium/windsurf/skills/software-tester
mkdir -p ~/.codeium/windsurf/skills/phantom-depth
cp /path/to/phantom-qa/.agent/skills/continuous-qa/SKILL.md ~/.codeium/windsurf/skills/continuous-qa/SKILL.md
cp /path/to/phantom-qa/.agent/skills/continuous-qa/scripts/test-harness.js ~/.codeium/windsurf/skills/continuous-qa/scripts/test-harness.js
cp /path/to/phantom-qa/.agent/skills/software-tester/SKILL.md ~/.codeium/windsurf/skills/software-tester/SKILL.md
cp /path/to/phantom-qa/.agent/skills/phantom-depth/SKILL.md ~/.codeium/windsurf/skills/phantom-depth/SKILL.md
cp /path/to/phantom-qa/GEMINI.md ~/.codeium/windsurf/memories/global_rules.md
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

---

## Phantom Depth Prompts: Full GUI Control

These prompts activate the `phantom-depth` skill, which gives your AI agent full mouse and keyboard control over the running application. The agent launches the app, clicks through everything, takes screenshots, and works autonomously.

### Launch and Test Everything (Full Visual Walkthrough)

> Launch this application and take full control. Open every screen, click every button, fill every form, toggle every switch, test every dropdown, try every keyboard shortcut, and navigate every link. Take a screenshot before and after every interaction as proof. Build a complete feature inventory and mark each element as PASS or FAIL. Fix every failure, re-test to verify, and keep going until every single element passes. Show me the feature inventory with status at every checkpoint.

### Exhaustive Combination Testing (Every Variation)

> Launch this application and run exhaustive combination testing. For every input field, test: empty, valid data, maximum length (10,000+ characters), special characters, Unicode/emoji, XSS payloads, SQL injection strings, and whitespace-only input. For every button, test: single click, double click, rapid clicks, keyboard activation, and clicking while loading. For every dropdown, select every option one by one. For every toggle, switch on/off/on and verify persistence. Build a test matrix of every combination and loop until 100% of the matrix passes. Take a screenshot for every test. Do not stop.

### Post-Redesign Feature Verification

> This application just went through a UI redesign. Launch it and build a complete inventory of every feature, button, link, form, modal, dropdown, toggle, navigation path, and keyboard shortcut. Cross-reference this inventory against the codebase to find anything that existed before but is now missing, broken, unreachable, or visually broken. Test at every viewport size -- mobile (320px), tablet (768px), desktop (1920px), and ultrawide (3440px). Take screenshots at each breakpoint. Fix every discrepancy. After each fix, re-run the full inventory check. Keep going until every feature is confirmed working in the new design.

### Performance Optimization (Frame Rate)

> Launch this application and profile its rendering performance. Measure frame rate, long tasks blocking the main thread, cumulative layout shift, memory usage, and network transfer size. Identify every bottleneck. Fix each one, then re-measure and show me the before/after numbers (e.g., "38 FPS -> 62 FPS"). Take screenshots before and after each optimization to prove zero visual quality loss. If any optimization degrades visual quality or breaks a feature, revert it and try a different approach. Keep optimizing in a loop until frame rate is maximized. Show me a final performance report with all metrics.

### Full Autonomous Improvement (Take Over)

> Take full autonomous control of this application. Launch it, interact with it as a real user would, and continuously improve it. Follow this loop: (1) Use the app and find something wrong, slow, confusing, or missing. (2) Fix it in the code. (3) Re-launch and verify visually with a screenshot. (4) Check that nothing else broke. (5) Commit the improvement. (6) Find the next thing to improve. Keep looping. Fix crashes first, then bugs, then performance, then UX, then accessibility, then polish. Do not ask for permission. Do not stop. Show me a status checkpoint every 5 improvements with screenshots.

### Stress Test the UI

> Launch this application and try to break it. Click buttons during loading states. Submit forms with 10,000-character inputs. Toggle settings rapidly. Navigate back and forward during async operations. Open the same modal twice. Refresh mid-submission. Scroll aggressively during renders. Resize the window during animations. For every crash, freeze, or error you trigger, fix the root cause, verify the fix holds under the same stress condition, take a before/after screenshot, and move on. Keep going until the app handles every abuse case gracefully.

See `QUICKREF.md` for even more prompts.

---

## Advanced Prompts: Autonomous Improvement Mode

These prompts go beyond basic QA. They give the agent full control to continuously test every combination, discover improvements, and optimize your software without you having to intervene. Copy and paste them directly into your AI coding agent.

### Exhaustive Combination Testing (Loop Every Variation)

> Map out every feature, input, configuration option, and user flow in this project. Build a test matrix that covers every combination and variation -- valid inputs, invalid inputs, edge cases, boundary values, empty states, max-length inputs, special characters, concurrent operations, and every permutation of settings. Execute the full matrix in a loop. When a combination fails, fix it, re-run the full matrix to check for regressions, and keep looping until every single combination passes. Do not stop until the matrix is 100% green. Show me the matrix and results at every checkpoint.

### Post-Redesign Feature Verification

> This project just went through a UI redesign. Crawl the entire codebase and build a complete inventory of every feature, button, link, form, modal, dropdown, toggle, navigation path, keyboard shortcut, and interactive element that existed before the redesign. Cross-reference this inventory against the current UI. Identify anything that is missing, broken, unreachable, visually broken, or behaves differently than before. Fix every discrepancy. After each fix, re-run the full inventory check to make sure nothing else broke. Keep going until every feature from the original is confirmed working in the new design. Show me the full feature inventory and status of each item.

### Autonomous Software Improvement (Full Control)

> Take full autonomous control of this project. Your goal is to make this software as good as it can possibly be. Follow this loop continuously without stopping:
>
> 1. **Audit** -- Scan the entire codebase for bugs, performance bottlenecks, security vulnerabilities, accessibility issues, code smells, missing error handling, inconsistent patterns, dead code, and anything that could be improved.
> 2. **Prioritize** -- Rank every issue by impact. Critical bugs first, then performance, then security, then code quality, then polish.
> 3. **Fix** -- Fix the highest-priority issue. Make the change minimal and focused.
> 4. **Verify** -- Prove the fix works. Run tests, build the project, start the application. Show terminal output.
> 5. **Regression check** -- Re-run the full test suite to make sure nothing else broke.
> 6. **Discover** -- After fixing, look for new opportunities. Can this function be faster? Can this API response be smaller? Can this error message be clearer? Can this component be more reusable?
> 7. **Repeat** -- Go back to step 1 with the updated codebase.
>
> Output a status checkpoint every 5 improvements. Do not stop until you have exhausted every possible improvement. Do not ask for permission -- just fix, verify, and move on.

### Performance Optimization Loop (Frame Rate / Speed)

> Analyze the entire rendering pipeline, animation system, and frame-by-frame performance of this application. Profile every function that runs per frame or per render cycle. Identify every bottleneck -- unnecessary re-renders, expensive DOM operations, unoptimized loops, synchronous blocking calls, layout thrashing, excessive memory allocation, redundant calculations, and unthrottled event handlers. Fix each bottleneck one at a time. After each fix, measure the before and after performance (frame rate, render time, memory usage) and show me the numbers. Do not sacrifice visual quality, feature completeness, or correctness for speed. Keep optimizing in a loop until frame rate is maximized and render time is minimized. Show me a performance summary at every checkpoint with concrete metrics.

### Feature Discovery and Enhancement Loop

> Analyze this project from a user's perspective. Use the application as a real user would. For every screen, workflow, and interaction, ask: What is confusing? What takes too many clicks? What error state is unhandled? What edge case will crash this? What accessibility issue exists? What feature is obviously missing that users would expect? Build a list of every improvement opportunity, ranked by user impact. Then start implementing them one by one. After each improvement, verify it works, check for regressions, and re-analyze to find the next opportunity. Keep looping. Output a checkpoint every 5 improvements showing what was added, what was fixed, and what is next.

### Stress Testing and Stability Loop

> Push this application to its limits. Test with: maximum-length inputs in every field, thousands of rapid-fire API calls, simultaneous operations on the same data, network disconnection mid-operation, corrupted input data, missing environment variables, full disk simulation, expired tokens, concurrent user sessions, and browser back/forward during async operations. For each failure you find, fix the root cause (not just the symptom), verify the fix holds under the same stress condition, then move on to the next stress test. Keep looping until the application handles every abuse case gracefully without crashing, losing data, or showing raw errors to the user.

### Complete Test Suite Generation

> Analyze every function, endpoint, component, and user flow in this project. Generate a comprehensive test suite that covers: unit tests for every function with edge cases, integration tests for every API endpoint, component tests for every UI element, end-to-end tests for every user workflow, error path tests for every failure mode, and boundary tests for every input validation. Run the full suite. Fix any code that fails the tests (fix the code, not the tests -- the tests represent correct behavior). Re-run after each fix. Keep looping until the entire suite passes with 100% of tests green. Show me coverage metrics and test results at every checkpoint.

### Security Hardening Loop

> Perform a comprehensive security audit of this project. Check for: SQL injection, XSS vulnerabilities, CSRF weaknesses, insecure direct object references, broken authentication flows, sensitive data exposure, missing rate limiting, insecure deserialization, known vulnerable dependencies, hardcoded secrets, permissive CORS, missing input sanitization, insecure file uploads, path traversal risks, and every item on the OWASP Top 10. Fix each vulnerability. After each fix, re-test to confirm the vulnerability is closed and no new ones were introduced. Keep looping until every security check passes clean.

See `QUICKREF.md` for even more prompts.

---

## Troubleshooting

### Windows: "Failed to attach disk" or WSL error when running bash setup.sh

On Windows, typing `bash setup.sh` can launch WSL (Windows Subsystem for Linux) instead of Git Bash. If you see an error like:

```
Failed to attach disk ... ext4.vhdx ... ERROR_PATH_NOT_FOUND
```

Use Git Bash directly instead. In PowerShell or CMD, run:

```
& "C:\Program Files\Git\bin\bash.exe" setup.sh
```

Or right-click the `phantom-qa` folder in File Explorer, select **Open Git Bash here**, and type `./setup.sh`.

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

All platforms install globally -- check that the skill files exist:

- **Antigravity:** `~/.gemini/antigravity/skills/continuous-qa/SKILL.md`
- **Claude Code:** `~/.claude/skills/continuous-qa/SKILL.md`
- **OpenClaw:** `~/.openclaw/workspace/skills/phantom-qa/skill.md`
- **Cursor:** `~/.cursor/skills/continuous-qa/SKILL.md`
- **Windsurf:** `~/.codeium/windsurf/skills/continuous-qa/SKILL.md`

If the file doesn't exist for your platform, run the setup wizard again and make sure that platform is selected.

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

**phantom-depth** -- Advanced autonomous GUI control. Launches the application, takes over mouse and keyboard, captures screenshots as proof, tests every combination/variation of every element, profiles frame rate and rendering performance, verifies UI redesigns, and runs a fully autonomous improvement loop with complete control

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
      phantom-depth/
        SKILL.md                     # Advanced GUI control, visual testing, perf optimization
  .openclaw/                         # OpenClaw skills
    skills/
      phantom-qa/
        skill.md                     # Core QA loop (OpenClaw format)
        scripts/
          test-harness.js            # Universal test runner (same as above)
      phantom-qa-tester/
        skill.md                     # Interactive testing (OpenClaw format)
      phantom-depth/
        skill.md                     # Advanced GUI control (OpenClaw format)
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
