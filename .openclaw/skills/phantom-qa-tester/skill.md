---
name: phantom-qa-tester
description: >
  Interactive application testing skill. Use this skill when the user wants to test
  a running application's UI, click through the interface, validate that screens
  and interactions work correctly, or perform integration testing on a live
  application. Uses the agent's browser capabilities to interact with web-based
  UIs and terminal-based testing for CLI applications.
version: 1.0.0
metadata:
  openclaw:
    requires:
      bins: []
    emoji: "\U0001F5B1"
    homepage: https://github.com/KyleBuildsAI/phantom-qa
---

# Software Tester - Interactive Application Testing

You are testing a running application. Your goal is to interact with every
screen, button, form, and feature to verify it works correctly.

## Use this skill when
- User asks to "click through the app and test everything"
- User wants to verify a running application works
- User wants end-to-end testing of UI interactions
- User asks to "check if all the buttons work"

## Do not use this skill when
- User wants static code analysis only (use phantom-qa)
- User wants unit test creation (use testing skill)

## Instructions

### For Web-Based Applications (Browser Testing)

1. **Launch the application**
   ```bash
   # Start the dev server if not running
   npm run dev 2>&1 &
   # or
   python manage.py runserver 2>&1 &
   # Wait for it
   sleep 3
   ```

2. **Open in the browser**
   - Navigate to the application URL
   - Take an initial screenshot as baseline

3. **Systematic UI Walkthrough**

   For EVERY page/screen in the application, perform:

   a. **Visual Inventory**: List every interactive element visible
      - Buttons (what text? what does it claim to do?)
      - Links (where do they go?)
      - Form inputs (what labels? what validation?)
      - Dropdowns/selects
      - Toggle switches
      - Modals/dialogs

   b. **Click Test**: Click each button/link and verify:
      - Did the UI change? How?
      - Did an API call fire? Did it succeed?
      - Did a new page/modal open?
      - If nothing happened, this is a BUG -- log it

   c. **Form Test**: For each form:
      - Submit empty (check validation messages)
      - Submit with invalid data (check error handling)
      - Submit with valid data (check success flow)
      - Check that data persists after submission

   d. **Navigation Test**: For each nav link:
      - Does it go to the right page?
      - Does the back button work?
      - Does the URL update correctly?

   e. **Content Check**: On each screen:
      - Is there placeholder text?
      - Do images load?
      - Are numbers/data realistic or obviously fake?
      - Are dates correct?

   f. **State Test**:
      - Refresh the page -- does state persist?
      - Open in a new tab -- does it work independently?
      - What happens with no network? (if applicable)

4. **Log every finding** in this format:
   ```
   [SCREEN: page-name]
   [ELEMENT: button/link/form "label"]
   [ACTION: clicked/submitted/navigated]
   [RESULT: what happened]
   [STATUS: PASS / FAIL / WARNING]
   [FIX: what needs to change (if applicable)]
   ```

### For CLI Applications

1. **Run the application**
   ```bash
   ./app --help 2>&1    # Check help output
   ```

2. **Test every command/subcommand**
   - Run with no arguments
   - Run with --help
   - Run with valid arguments
   - Run with invalid arguments (check error handling)
   - Run with edge case inputs (empty strings, very long strings, special characters)

3. **Test input/output**
   - Does it read files correctly?
   - Does it write output correctly?
   - What happens with missing files?
   - What happens with permission errors?

### For Desktop GUI Applications

For native desktop apps:

1. **Use screenshot-based verification**
   - Take screenshots at each step
   - Compare expected vs actual visually

2. **Use accessibility APIs if available**
   ```bash
   # macOS
   osascript -e 'tell application "System Events" to get every window'

   # Windows (PowerShell)
   Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object MainWindowTitle
   ```

3. **Use testing frameworks appropriate to the platform**
   - Electron apps: Use Playwright or Spectron
   - Qt apps: Use pytest-qt
   - macOS native: Use XCTest
   - Windows native: Use WinAppDriver

## Verification Requirements

After finding and fixing each issue:
1. Re-run the exact interaction that failed
2. Take a screenshot showing the fix works
3. Check that no other interactions broke
4. Only mark as fixed when you have PROOF

## Completion Criteria

You are done ONLY when:
1. Every screen has been visited
2. Every interactive element has been tested
3. Every form has been tested with valid and invalid data
4. All found issues have been fixed and verified
5. A final walkthrough confirms everything works
6. You can show a screenshot of each screen in working state
