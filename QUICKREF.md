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

## Phantom Depth: Full GUI Control

### Launch and Test Everything
```
Launch this application and take full control. Open every screen, click every
button, fill every form, toggle every switch, test every dropdown, try every
keyboard shortcut, and navigate every link. Take a screenshot before and after
every interaction as proof. Build a complete feature inventory and mark each
element as PASS or FAIL. Fix every failure, re-test to verify, and keep going
until every single element passes.
```

### Exhaustive Combination Testing
```
Launch this application and run exhaustive combination testing. For every input
field, test: empty, valid data, maximum length (10,000+ characters), special
characters, Unicode/emoji, XSS payloads, SQL injection strings, and whitespace.
For every button, test: single click, double click, rapid clicks, keyboard
activation, and clicking while loading. For every dropdown, select every option.
For every toggle, switch on/off/on and verify persistence. Build a test matrix
and loop until 100% passes. Take a screenshot for every test. Do not stop.
```

### Post-Redesign Feature Verification
```
This application just went through a UI redesign. Launch it and build a complete
inventory of every feature, button, link, form, modal, dropdown, toggle, nav
path, and keyboard shortcut. Cross-reference against the codebase to find
anything missing, broken, or visually wrong. Test at every viewport (320px,
768px, 1920px, 3440px). Take screenshots at each breakpoint. Fix every gap.
Keep going until every feature is confirmed working.
```

### Performance Optimization (Frame Rate)
```
Launch this application and profile its rendering performance. Measure frame
rate, long tasks, layout shift, memory usage, and network transfer. Identify
every bottleneck. Fix each one, then re-measure and show before/after numbers.
Take screenshots to prove zero visual quality loss. If any optimization breaks
quality or features, revert and try a different approach. Keep optimizing until
frame rate is maximized.
```

### Full Autonomous Improvement
```
Take full autonomous control of this application. Launch it, interact with it,
and continuously improve it. Loop: (1) Find something wrong, slow, or missing.
(2) Fix it. (3) Re-launch and verify with a screenshot. (4) Check nothing else
broke. (5) Commit. (6) Find the next thing. Fix crashes first, then bugs, then
performance, then UX, then accessibility, then polish. Do not ask for permission.
Do not stop.
```

### Stress Test the UI
```
Launch this application and try to break it. Click during loading. Submit forms
with 10,000-character inputs. Toggle rapidly. Navigate back/forward during async
ops. Open modals twice. Refresh mid-submission. Scroll during renders. Resize
during animations. For every crash or error, fix the root cause, verify the fix,
take before/after screenshots, and move on. Keep going until the app handles
every abuse case gracefully.
```

---

## Advanced: Autonomous Improvement Mode

### Exhaustive Combination Testing
```
Map out every feature, input, configuration option, and user flow in this
project. Build a test matrix that covers every combination and variation --
valid inputs, invalid inputs, edge cases, boundary values, empty states,
max-length inputs, special characters, concurrent operations, and every
permutation of settings. Execute the full matrix in a loop. When a combination
fails, fix it, re-run the full matrix to check for regressions, and keep
looping until every single combination passes. Do not stop until the matrix
is 100% green. Show me the matrix and results at every checkpoint.
```

### Post-Redesign Feature Verification
```
This project just went through a UI redesign. Crawl the entire codebase and
build a complete inventory of every feature, button, link, form, modal,
dropdown, toggle, navigation path, keyboard shortcut, and interactive element
that existed before the redesign. Cross-reference this inventory against the
current UI. Identify anything that is missing, broken, unreachable, visually
broken, or behaves differently than before. Fix every discrepancy. After each
fix, re-run the full inventory check to make sure nothing else broke. Keep
going until every feature from the original is confirmed working in the new
design. Show me the full feature inventory and status of each item.
```

### Autonomous Software Improvement (Full Control)
```
Take full autonomous control of this project. Your goal is to make this
software as good as it can possibly be. Follow this loop continuously:

1. Audit -- Scan for bugs, performance bottlenecks, security vulnerabilities,
   accessibility issues, code smells, missing error handling, dead code.
2. Prioritize -- Rank by impact. Critical bugs first, then performance, then
   security, then code quality, then polish.
3. Fix -- Fix the highest-priority issue. Minimal and focused.
4. Verify -- Prove the fix works. Run tests, build, start the app. Show output.
5. Regression check -- Re-run full test suite.
6. Discover -- Look for new opportunities. Faster? Smaller? Clearer? More reusable?
7. Repeat -- Go back to step 1 with the updated codebase.

Do not stop until you have exhausted every possible improvement. Do not ask
for permission -- just fix, verify, and move on.
```

### Performance Optimization Loop
```
Analyze the entire rendering pipeline, animation system, and frame-by-frame
performance of this application. Profile every function that runs per frame
or per render cycle. Identify every bottleneck -- unnecessary re-renders,
expensive DOM operations, unoptimized loops, synchronous blocking calls,
layout thrashing, excessive memory allocation, redundant calculations, and
unthrottled event handlers. Fix each bottleneck one at a time. After each
fix, measure before and after performance (frame rate, render time, memory
usage) and show me the numbers. Do not sacrifice visual quality, feature
completeness, or correctness for speed. Keep optimizing in a loop until
frame rate is maximized and render time is minimized.
```

### Feature Discovery and Enhancement Loop
```
Analyze this project from a user's perspective. Use the application as a real
user would. For every screen, workflow, and interaction, ask: What is confusing?
What takes too many clicks? What error state is unhandled? What edge case will
crash this? What accessibility issue exists? What feature is obviously missing?
Build a ranked list of improvements by user impact. Implement them one by one.
After each improvement, verify it works, check for regressions, and re-analyze
to find the next opportunity. Keep looping.
```

### Stress Testing and Stability Loop
```
Push this application to its limits. Test with: maximum-length inputs in every
field, thousands of rapid-fire API calls, simultaneous operations on the same
data, network disconnection mid-operation, corrupted input data, missing
environment variables, expired tokens, concurrent user sessions, and browser
back/forward during async operations. For each failure, fix the root cause,
verify under the same stress condition, then move on. Keep looping until the
application handles every abuse case gracefully.
```

### Complete Test Suite Generation
```
Analyze every function, endpoint, component, and user flow. Generate a
comprehensive test suite: unit tests with edge cases, integration tests for
every API endpoint, component tests for every UI element, end-to-end tests
for every user workflow, error path tests, and boundary tests. Run the full
suite. Fix any code that fails (fix the code, not the tests). Re-run after
each fix. Keep looping until 100% green.
```

### Security Hardening Loop
```
Perform a comprehensive security audit. Check for: SQL injection, XSS, CSRF,
insecure direct object references, broken authentication, sensitive data
exposure, missing rate limiting, insecure deserialization, known vulnerable
dependencies, hardcoded secrets, permissive CORS, missing input sanitization,
insecure file uploads, path traversal, and every OWASP Top 10 item. Fix each
vulnerability, re-test to confirm it is closed, and keep looping until every
security check passes clean.
```

---

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
