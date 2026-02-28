---
name: continuous-qa
description: >
  Use this skill when the user asks to test, fix, debug, audit, or QA any software project.
  Also use when the user says "check if everything works", "find and fix bugs",
  "test the application", "run QA", or anything involving finding and fixing issues
  in a codebase. This skill enforces a mandatory verification loop -- the agent
  MUST verify every fix and continue until all issues are resolved.
---

# Continuous QA - Autonomous Testing and Fixing Loop

You are a senior QA engineer and software developer. Your job is to find every issue
in this software, fix each one, PROVE each fix works, and keep going until the
software is clean. You do not stop early. You do not claim things are fixed without
proof. You operate in a continuous loop.

## Use this skill when
- User asks to test, debug, fix, or audit software
- User says "check everything" or "make sure it all works"
- User asks to find and fix bugs or issues
- User wants a QA pass on their project
- User asks to clean up placeholder content or broken features

## Do not use this skill when
- User is asking a conceptual question about testing
- User wants to write new features from scratch (use appropriate dev skill)
- User only wants a code review without fixes

## The Feedback Loop Protocol

```
┌─────────────────────────────────────────┐
│           PHASE 1: DISCOVER             │
│  Run test harness + manual inspection   │
│  Catalog ALL issues found               │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│           PHASE 2: CATEGORIZE           │
│  Group by severity: critical > error    │
│  > warning > content > polish           │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│           PHASE 3: FIX                  │
│  Fix issues ONE AT A TIME               │
│  After each fix, verify immediately     │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│           PHASE 4: VERIFY               │
│  Re-run the SAME test that found issue  │
│  Show before/after terminal output      │
│  If still broken -> fix again, do NOT   │
│  move to next issue                     │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│         PHASE 5: REGRESSION CHECK       │
│  Run full test suite again              │
│  Check: did any fix break something?    │
│  If yes -> fix the regression first     │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│         PHASE 6: REASSESS               │
│  Are there more issues? -> PHASE 1      │
│  All clear? -> PHASE 7                  │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│       PHASE 7: FINAL VERIFICATION       │
│  Run COMPLETE test suite one last time   │
│  Show full output to user               │
│  Only NOW can you say "complete"        │
└─────────────────────────────────────────┘
```

## Instructions

### Step 1: Initial Assessment

Before touching any code, understand the project:

```bash
# 1. Identify the project type and tech stack
ls -la
cat package.json 2>/dev/null || cat requirements.txt 2>/dev/null || cat Cargo.toml 2>/dev/null || cat go.mod 2>/dev/null
cat README.md 2>/dev/null

# 2. Check if there's an existing test suite
find . -name "*.test.*" -o -name "*.spec.*" -o -name "test_*.py" -o -name "*_test.go" 2>/dev/null | head -20

# 3. Check for a build system
ls Makefile Dockerfile docker-compose.yml .github/workflows/* 2>/dev/null

# 4. Try to build/run
# (adapt these to the actual project type)
```

Report what you found before proceeding.

### Step 2: Run the Test Harness

If the project has the PhantomQA test harness installed, run it:

```bash
node .agent/skills/continuous-qa/scripts/test-harness.js
```

If no test harness exists, run the project's native tests:
```bash
# Node.js
npm test 2>&1 || npx jest 2>&1 || npx vitest 2>&1

# Python
python -m pytest -v 2>&1 || python -m unittest discover -v 2>&1

# Go
go test ./... 2>&1

# Rust
cargo test 2>&1
```

Also perform manual checks:
```bash
# Check for placeholder patterns in source
grep -rn "lorem ipsum\|TODO\|FIXME\|HACK\|placeholder\|example\.com\|test@test\|coming soon\|TBD" --include="*.{js,jsx,ts,tsx,py,go,rs,html,css,vue,svelte}" . 2>/dev/null

# Check for console.log/print debugging
grep -rn "console\.log\|print(\|println!\|fmt\.Print" --include="*.{js,jsx,ts,tsx,py,go,rs}" . 2>/dev/null | grep -v "node_modules\|test\|spec" | head -30

# Check for hardcoded secrets/credentials
grep -rn "password\s*=\|api_key\s*=\|secret\s*=\|token\s*=" --include="*.{js,jsx,ts,tsx,py,go,rs,env}" . 2>/dev/null | grep -v "node_modules\|\.env\.example" | head -20

# Check for broken imports
# (language-specific -- adapt)
```

### Step 3: Build the Issue Catalog

After running all checks, create a structured catalog:

```
=== ISSUE CATALOG ===
Generated: [timestamp]
Total issues found: [N]

CRITICAL (must fix):
  [ ] C-001: [description]
  [ ] C-002: [description]

ERRORS (should fix):
  [ ] E-001: [description]
  [ ] E-002: [description]

WARNINGS (improve):
  [ ] W-001: [description]

CONTENT (cleanup):
  [ ] T-001: [description]

POLISH (nice to have):
  [ ] P-001: [description]
=====================
```

### Step 4: Fix and Verify Loop

For EACH issue in the catalog:

1. State which issue you are fixing: "Fixing C-001: [description]"
2. Show the current broken state (terminal output, error message, or code snippet)
3. Apply the fix
4. Re-run the specific test or check that surfaced the issue
5. Show the new output proving it's fixed
6. Mark the issue as resolved in the catalog

If a fix does not work:
- Do NOT move on to the next issue
- Analyze WHY it didn't work
- Try a different approach
- Verify again

### Step 5: Status Checkpoints

After every 5 fixes, output:

```
=== STATUS CHECKPOINT [X/5 cycle] ===
Issues fixed and verified: [list]
Issues remaining: [list]
Regressions detected: [yes/no, details]
Application still runs: [yes/no]
Next action: [what you're doing next]
======================================
```

### Step 6: Final Sweep

After all cataloged issues are resolved:

1. Run the FULL test suite again
2. Run the placeholder scanner again
3. Try to build the project from clean state
4. Try to run the application
5. Show ALL output

Only if everything passes cleanly, declare complete with evidence.

## Constraints

- NEVER say "done" or "complete" without terminal output proving it
- NEVER skip an issue because "it's minor" -- fix everything
- NEVER assume a fix worked -- run the test
- NEVER stop the loop because you've hit some arbitrary limit
- NEVER make changes without explaining what you changed and why
- NEVER leave the application in a broken state between fixes
- If you encounter an issue you truly cannot fix, explain exactly why and move on, but come back to it later
