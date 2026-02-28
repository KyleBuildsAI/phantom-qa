# Project Rules

## CRITICAL: Continuous Verification Loop

You are operating under a **mandatory verification protocol**. You NEVER declare work "complete" or "done" without concrete proof. Follow these rules without exception:

### The Loop (MANDATORY for every task)

Every task follows this cycle. You do NOT exit until the cycle is clean:

```
DISCOVER -> FIX -> VERIFY -> REASSESS -> (loop or complete)
```

1. **DISCOVER**: Run the test harness, read logs, inspect the application. Catalog ALL issues found, not just the first few.
2. **FIX**: Apply fixes one category at a time. After EACH fix, explain what you changed and WHY.
3. **VERIFY**: After fixing, you MUST re-run the exact same test/check that surfaced the issue. If the output has not changed, YOUR FIX DID NOT WORK. Do not move on.
4. **REASSESS**: After verifying fixes, run the FULL test suite again. New issues may have surfaced. If there are new issues, return to step 1.

### Verification Rules

- **NEVER say "the changes have been made" without showing terminal output proving it.**
- **NEVER say "this should fix the issue" -- run the code and PROVE it fixed the issue.**
- **NEVER stop after a fixed number of fixes.** If there are 50 issues, you fix 50 issues.
- **ALWAYS run the application after changes to confirm it still launches and functions.**
- **ALWAYS check for regressions** -- did your fix break something else?
- **ALWAYS show before/after evidence** for each fix (error output before, clean output after).

### Completion Criteria

You may ONLY declare a task complete when ALL of the following are true:
1. The test harness returns 0 failures and 0 critical warnings
2. The application runs without console errors
3. All interactive elements respond to user action
4. No placeholder content remains (lorem ipsum, TODO, test@test, example.com, etc.)
5. You have run the full verification suite ONE FINAL TIME and shown the output

If you cannot meet all criteria, list exactly what remains and ask if I want you to continue.

### Self-Assessment Checkpoints

After every 5 fixes, stop and ask yourself:
- "Have I actually verified each fix works?"
- "Did I re-run the tests to confirm?"
- "Are there categories of issues I haven't checked yet?"
- "Has anything I fixed introduced a new problem?"

Output a brief status report every 5 fixes:
```
=== STATUS CHECKPOINT ===
Fixes applied: X
Fixes verified: X
Remaining issues: X
Regressions found: X
Next action: [what you're doing next]
=========================
```

## Code Quality Standards

- Never leave commented-out code unless there is a clear reason with a comment explaining why
- Never use placeholder values in production code
- All functions must have error handling
- All UI elements must have accessible labels
- All API endpoints must handle error responses
- Console.log statements used for debugging must be removed before declaring complete

## Testing Priority Order

When fixing a software project, address issues in this order:
1. **Critical**: Application crashes, build failures, security vulnerabilities
2. **Errors**: Console errors, failed API calls, broken functionality
3. **Warnings**: Missing accessibility, deprecated APIs, performance issues
4. **Content**: Placeholder text, broken images, dead links
5. **Polish**: Styling inconsistencies, UX improvements, edge cases

## Communication Style

- Be direct. State what the issue is and what you're doing about it.
- Show terminal output, not just descriptions.
- When something fails, say it failed and show the error.
- Never use vague language like "this should work" or "changes have been applied."
- Use concrete language: "The button click handler now calls submitForm(). Here is the test output confirming it works: [output]"
- Never use em dashes in any writing.

## Model Compatibility

These rules apply regardless of which model is powering the agent -- Gemini 3.1 Pro, Claude Opus 4.6, Claude Sonnet 4.5, or any other model available in Antigravity. The verification loop is mandatory for all models.
