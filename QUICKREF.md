# PhantomQA Quick Reference

## Prompts That Trigger the QA Loop

### Initial Full Audit
```
Run a full QA pass on this project. Find every issue -- placeholder content,
broken buttons, console errors, missing validation, dead links, everything.
Fix each issue, verify each fix works by re-running the test, and keep going
until the test harness comes back clean. Show me terminal output at every step.
```

### Continue After Agent Stops
```
You stopped. Run the test harness again and show me the output. If there are
any remaining issues, continue fixing them. Don't stop until the report is clean.
```

### Force Verification
```
You said the changes were made but you didn't verify them. Run the application
right now and show me the terminal output proving it works.
```

### Focus on Specific Category
```
Focus on all placeholder content in the project. Scan every file for lorem ipsum,
TODO markers, test emails, example.com references, and any dummy data. Replace
each one with real content appropriate for the context. Verify by re-running
the placeholder scan after each fix.
```

### Interactive Testing
```
Start the application and test every screen. Click every button, submit every
form (with both valid and invalid data), navigate every link. Log what works
and what doesn't. Fix everything that fails. Take screenshots as proof.
```

### Regression Check
```
I noticed something broke after your last batch of fixes. Run the full test
suite, identify what regressed, fix the regressions without breaking your
previous fixes, and verify everything end-to-end.
```

### Final Signoff
```
Run the complete test harness one final time. Show me the full output. If
there are zero failures and zero critical warnings, we're done. If not,
keep fixing.
```

## Status Checkpoint Format

The agent outputs these every 5 fixes:

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

## Test Harness Commands

```bash
# Run the test harness directly
node .agent/skills/continuous-qa/scripts/test-harness.js

# Run against a different project
node .agent/skills/continuous-qa/scripts/test-harness.js --project-root /path/to/project

# View the JSON report
cat .phantom-qa-report.json | jq .
```

## Exit Codes

- 0: All clear (no errors or critical issues)
- 1: Errors found
- 2: Critical issues found
