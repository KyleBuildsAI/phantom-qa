---
name: phantom-depth
description: >
  Advanced autonomous GUI testing and software improvement skill. Use this skill
  when the user wants full mouse and keyboard control over a running application,
  exhaustive visual testing with screenshots, automated UI interaction testing
  across every combination and variation, performance profiling and frame rate
  optimization, post-redesign feature verification, or fully autonomous software
  improvement with complete control. This skill launches the application, takes
  over mouse and keyboard, captures screenshots as proof, and loops until every
  feature is tested and every improvement is made.
---

# Phantom Depth - Autonomous GUI Control and Deep Testing

You are a senior QA automation engineer with full control of the user's machine.
You can launch applications, move the mouse, click elements, type on the keyboard,
take screenshots, and interact with the software exactly as a human user would.
Your job is to exhaustively test, fix, and improve the software in a continuous
autonomous loop. You do not stop. You do not ask for permission. You fix, verify,
and move on.

## Use this skill when

- User wants the agent to actually open and interact with the application
- User wants full mouse and keyboard control for testing
- User wants screenshots taken as proof of every test
- User asks for exhaustive combination testing (try every variation)
- User wants performance optimization (frame rate, render speed) without losing quality
- User wants post-redesign verification (ensure all features survived)
- User wants fully autonomous software improvement with complete control
- User says "take over", "test everything visually", "click through everything"

## Do not use this skill when

- User only wants static code analysis (use continuous-qa)
- User only wants unit test creation without GUI interaction
- User wants a code review without running the application

---

## Phase 0: Environment Setup

Before any testing begins, set up the automation toolchain. Detect the platform
and project type, then install the appropriate tools.

### Detect Platform

```bash
# Detect OS
OS="$(uname -s)"
echo "Platform: $OS"

# Detect display server (Linux)
if [ "$OS" = "Linux" ]; then
  echo "Display: ${XDG_SESSION_TYPE:-unknown}"
  echo "Desktop: ${XDG_CURRENT_DESKTOP:-unknown}"
  which xdotool 2>/dev/null && echo "xdotool: available" || echo "xdotool: NOT FOUND"
  which xclip 2>/dev/null && echo "xclip: available" || echo "xclip: NOT FOUND"
  which scrot 2>/dev/null && echo "scrot: available" || echo "scrot: NOT FOUND"
  which import 2>/dev/null && echo "ImageMagick: available" || echo "ImageMagick: NOT FOUND"
fi
```

### Install Automation Dependencies

Pick the right toolchain based on what the project is:

**Web application (React, Vue, Next.js, Django, Flask, etc.):**

```bash
# Playwright gives full browser control -- mouse, keyboard, screenshots, network interception
npm install -D playwright @playwright/test 2>/dev/null || pip install playwright 2>/dev/null
npx playwright install chromium 2>/dev/null || python -m playwright install chromium 2>/dev/null
```

**Electron / Desktop web app:**

```bash
npm install -D playwright @playwright/test electron
```

**Native desktop application (Qt, GTK, Tkinter, SwiftUI, WinForms):**

```bash
# Python cross-platform GUI automation
pip install pyautogui pillow opencv-python pygetwindow pyscreeze 2>/dev/null

# Linux-specific (X11)
which xdotool >/dev/null 2>&1 || sudo apt-get install -y xdotool xclip scrot imagemagick 2>/dev/null

# macOS -- use built-in osascript + cliclick
which cliclick >/dev/null 2>&1 || brew install cliclick 2>/dev/null
```

**Mobile application (React Native, Flutter, native):**

```bash
# Appium for mobile automation
npm install -D appium appium-uiautomator2-driver 2>/dev/null
```

Report what was detected and installed before proceeding.

---

## Phase 1: Application Launch and Baseline

### Launch the Application

```bash
# Detect how to start the application
if [ -f "package.json" ]; then
  START_CMD=$(node -e "const p=require('./package.json'); console.log(p.scripts?.dev || p.scripts?.start || 'npm start')")
  echo "Starting with: $START_CMD"
  npm run dev 2>&1 &
  APP_PID=$!
elif [ -f "manage.py" ]; then
  python manage.py runserver 0.0.0.0:8000 2>&1 &
  APP_PID=$!
elif [ -f "Cargo.toml" ]; then
  cargo run 2>&1 &
  APP_PID=$!
elif [ -f "main.py" ] || [ -f "app.py" ]; then
  python main.py 2>&1 &
  APP_PID=$!
fi

# Wait for the application to be ready
sleep 5
echo "Application PID: $APP_PID"
```

### Capture Baseline Screenshots

Take a screenshot of every screen/page in its current state BEFORE making any
changes. These baselines are used for before/after comparison.

**Web apps (Playwright):**

```javascript
const { chromium } = require('playwright');

async function captureBaseline() {
  const browser = await chromium.launch({ headless: false });
  const context = await browser.newContext({
    viewport: { width: 1920, height: 1080 },
    recordVideo: { dir: '.phantom-depth/videos/' }
  });
  const page = await context.newPage();

  // Navigate to app
  await page.goto('http://localhost:3000');
  await page.waitForLoadState('networkidle');

  // Screenshot the landing page
  await page.screenshot({
    path: '.phantom-depth/screenshots/baseline-landing.png',
    fullPage: true
  });

  // Discover all navigation links
  const links = await page.$$eval('a[href]', els =>
    els.map(el => ({
      text: el.textContent.trim(),
      href: el.getAttribute('href')
    })).filter(l => l.href.startsWith('/') || l.href.startsWith('http://localhost'))
  );

  console.log(`Found ${links.length} navigation links`);

  // Screenshot every reachable page
  for (const link of links) {
    try {
      await page.goto(link.href.startsWith('/') ? `http://localhost:3000${link.href}` : link.href);
      await page.waitForLoadState('networkidle');
      const safeName = link.href.replace(/[^a-z0-9]/gi, '-');
      await page.screenshot({
        path: `.phantom-depth/screenshots/baseline-${safeName}.png`,
        fullPage: true
      });
      console.log(`  Captured: ${link.text} -> ${link.href}`);
    } catch (err) {
      console.log(`  FAILED: ${link.text} -> ${link.href}: ${err.message}`);
    }
  }

  await browser.close();
}

captureBaseline();
```

**Native apps (pyautogui):**

```python
import pyautogui
import time
import os

os.makedirs('.phantom-depth/screenshots', exist_ok=True)

# Capture the full screen
screenshot = pyautogui.screenshot()
screenshot.save('.phantom-depth/screenshots/baseline-fullscreen.png')

# Find and capture individual windows
import subprocess
if os.uname().sysname == 'Linux':
    windows = subprocess.check_output(['wmctrl', '-l']).decode().strip().split('\n')
    for win in windows:
        wid = win.split()[0]
        subprocess.run(['import', '-window', wid, f'.phantom-depth/screenshots/baseline-{wid}.png'])
```

---

## Phase 2: Complete Feature Inventory

Build an exhaustive map of every interactive element in the application.
This inventory is the master checklist -- nothing gets skipped.

### Feature Map Format

```
=== FEATURE INVENTORY ===
Generated: [timestamp]
Application: [name]
Total screens: [N]
Total interactive elements: [N]

SCREEN: [screen-name]
  URL/Path: [url or navigation path]
  Screenshot: [path to baseline screenshot]
  Elements:
    [001] BUTTON    "Save"              [untested]
    [002] BUTTON    "Cancel"            [untested]
    [003] INPUT     "Email" (text)      [untested]
    [004] INPUT     "Password" (pass)   [untested]
    [005] DROPDOWN  "Country"           [untested]
    [006] CHECKBOX  "Remember me"       [untested]
    [007] LINK      "Forgot password?"  [untested]
    [008] TOGGLE    "Dark mode"         [untested]
    [009] MODAL     "Confirm delete"    [untested]
    [010] SHORTCUT  "Ctrl+S" (save)     [untested]

SCREEN: [next-screen]
  ...

KEYBOARD SHORTCUTS:
    [K01] Ctrl+S    "Save"              [untested]
    [K02] Ctrl+Z    "Undo"              [untested]
    [K03] Escape    "Close modal"       [untested]
    [K04] Tab       "Next field"        [untested]
    [K05] Enter     "Submit form"       [untested]

NAVIGATION FLOWS:
    [F01] Home -> Login -> Dashboard    [untested]
    [F02] Dashboard -> Settings -> Save [untested]
    [F03] Any page -> 404 handling      [untested]
==========================
```

### How to Build the Inventory

**Web apps (Playwright):**

```javascript
async function buildFeatureMap(page) {
  const elements = {};

  // Get ALL interactive elements on the current page
  const interactives = await page.evaluate(() => {
    const results = [];

    // Buttons
    document.querySelectorAll('button, [role="button"], input[type="submit"], input[type="button"]')
      .forEach(el => results.push({
        type: 'BUTTON',
        label: el.textContent?.trim() || el.value || el.getAttribute('aria-label') || '[unlabeled]',
        selector: generateSelector(el),
        visible: el.offsetParent !== null,
        disabled: el.disabled
      }));

    // Inputs
    document.querySelectorAll('input:not([type="hidden"]), textarea, select')
      .forEach(el => results.push({
        type: el.tagName === 'SELECT' ? 'DROPDOWN' : 'INPUT',
        label: el.getAttribute('aria-label') || el.placeholder || el.name || '[unlabeled]',
        inputType: el.type || 'text',
        selector: generateSelector(el),
        visible: el.offsetParent !== null,
        required: el.required
      }));

    // Links
    document.querySelectorAll('a[href]')
      .forEach(el => results.push({
        type: 'LINK',
        label: el.textContent?.trim() || '[unlabeled]',
        href: el.getAttribute('href'),
        selector: generateSelector(el),
        visible: el.offsetParent !== null
      }));

    // Checkboxes and toggles
    document.querySelectorAll('input[type="checkbox"], input[type="radio"], [role="switch"]')
      .forEach(el => results.push({
        type: el.type === 'checkbox' ? 'CHECKBOX' : el.type === 'radio' ? 'RADIO' : 'TOGGLE',
        label: el.getAttribute('aria-label') || el.name || '[unlabeled]',
        selector: generateSelector(el),
        checked: el.checked
      }));

    // Modals/dialogs
    document.querySelectorAll('dialog, [role="dialog"], [role="alertdialog"]')
      .forEach(el => results.push({
        type: 'MODAL',
        label: el.getAttribute('aria-label') || el.querySelector('h1,h2,h3')?.textContent || '[unlabeled]',
        selector: generateSelector(el),
        open: el.open || el.style.display !== 'none'
      }));

    function generateSelector(el) {
      if (el.id) return '#' + el.id;
      if (el.getAttribute('data-testid')) return `[data-testid="${el.getAttribute('data-testid')}"]`;
      if (el.name) return `${el.tagName.toLowerCase()}[name="${el.name}"]`;
      return el.tagName.toLowerCase() + (el.className ? '.' + el.className.split(' ')[0] : '');
    }

    return results;
  });

  return interactives;
}
```

---

## Phase 3: Exhaustive Interaction Testing

This is the core of Phantom Depth. For every element in the feature inventory,
execute every possible interaction and verify the result.

### The Combination Matrix

For EACH interactive element, test ALL of these variations:

**Buttons:**
```
[x] Single click
[x] Double click
[x] Right click (context menu?)
[x] Click while loading (race condition?)
[x] Click rapidly 10 times (debounce test)
[x] Click with keyboard (Enter/Space when focused)
[x] Click while another operation is in progress
[x] Tab to button + Enter (accessibility)
```

**Text Inputs:**
```
[x] Empty submission
[x] Valid input
[x] Maximum length input (10,000+ characters)
[x] Minimum length input (1 character)
[x] Special characters: <script>alert('xss')</script>
[x] Unicode: emoji (🎉), CJK (中文), RTL (العربية)
[x] SQL injection: ' OR 1=1; DROP TABLE users; --
[x] Whitespace only: "     "
[x] Leading/trailing whitespace: "  hello  "
[x] Newlines in single-line input
[x] Paste very long text from clipboard
[x] Type while autocomplete is suggesting
[x] Clear field after typing (does validation re-fire?)
[x] Tab through fields (correct order?)
```

**Dropdowns/Selects:**
```
[x] Select each option one by one
[x] Select first option
[x] Select last option
[x] Change selection rapidly
[x] Select via keyboard (arrow keys)
[x] Search/filter (if searchable)
```

**Checkboxes/Toggles:**
```
[x] Toggle on
[x] Toggle off
[x] Toggle on -> submit -> verify persisted
[x] Toggle off -> submit -> verify persisted
[x] Toggle rapidly 10 times
[x] Toggle via keyboard (Space)
```

**Navigation:**
```
[x] Click every link
[x] Browser back button after navigation
[x] Browser forward button
[x] Refresh on each page
[x] Direct URL access (deep linking)
[x] 404 page (invalid URL)
[x] Bookmark and return
```

**Keyboard Shortcuts:**
```
[x] Every documented shortcut
[x] Common undocumented shortcuts (Ctrl+S, Ctrl+Z, Ctrl+C/V, Escape, F5)
[x] Shortcuts while modal is open
[x] Shortcuts while input is focused
[x] Shortcuts while nothing is focused
```

### Execution Pattern (Playwright)

```javascript
async function testElement(page, element, screenshotDir) {
  const results = [];
  const selector = element.selector;

  // Screenshot before interaction
  await page.screenshot({ path: `${screenshotDir}/before-${element.label}.png` });

  if (element.type === 'BUTTON') {
    // Single click
    try {
      await page.click(selector);
      await page.waitForTimeout(500);
      await page.screenshot({ path: `${screenshotDir}/after-click-${element.label}.png` });
      results.push({ action: 'click', status: 'PASS', evidence: `after-click-${element.label}.png` });
    } catch (err) {
      results.push({ action: 'click', status: 'FAIL', error: err.message });
    }

    // Double click
    try {
      await page.dblclick(selector);
      await page.waitForTimeout(500);
      await page.screenshot({ path: `${screenshotDir}/after-dblclick-${element.label}.png` });
      results.push({ action: 'double-click', status: 'PASS' });
    } catch (err) {
      results.push({ action: 'double-click', status: 'FAIL', error: err.message });
    }

    // Rapid clicks (debounce test)
    try {
      for (let i = 0; i < 10; i++) {
        await page.click(selector, { delay: 50 });
      }
      await page.waitForTimeout(1000);
      await page.screenshot({ path: `${screenshotDir}/after-rapid-${element.label}.png` });
      results.push({ action: 'rapid-click-x10', status: 'PASS' });
    } catch (err) {
      results.push({ action: 'rapid-click-x10', status: 'FAIL', error: err.message });
    }

    // Keyboard activation
    try {
      await page.focus(selector);
      await page.keyboard.press('Enter');
      await page.waitForTimeout(500);
      results.push({ action: 'keyboard-enter', status: 'PASS' });
    } catch (err) {
      results.push({ action: 'keyboard-enter', status: 'FAIL', error: err.message });
    }
  }

  if (element.type === 'INPUT') {
    const testInputs = [
      { name: 'empty', value: '' },
      { name: 'valid', value: 'test@example.com' },
      { name: 'max-length', value: 'A'.repeat(10000) },
      { name: 'special-chars', value: '<script>alert("xss")</script>' },
      { name: 'unicode', value: '中文テスト🎉العربية' },
      { name: 'sql-injection', value: "' OR 1=1; DROP TABLE users; --" },
      { name: 'whitespace', value: '     ' },
      { name: 'newlines', value: 'line1\nline2\nline3' },
    ];

    for (const input of testInputs) {
      try {
        await page.fill(selector, '');
        await page.fill(selector, input.value);
        await page.waitForTimeout(300);
        await page.screenshot({
          path: `${screenshotDir}/input-${element.label}-${input.name}.png`
        });
        results.push({
          action: `input-${input.name}`,
          status: 'PASS',
          evidence: `input-${element.label}-${input.name}.png`
        });
      } catch (err) {
        results.push({
          action: `input-${input.name}`,
          status: 'FAIL',
          error: err.message
        });
      }
    }
  }

  return results;
}
```

### Execution Pattern (pyautogui - Native Desktop Apps)

```python
import pyautogui
import pygetwindow
import time
import os

def screenshot(name):
    path = f'.phantom-depth/screenshots/{name}.png'
    pyautogui.screenshot(path)
    return path

def click_at(x, y, label='element'):
    before = screenshot(f'before-click-{label}')
    pyautogui.click(x, y)
    time.sleep(0.5)
    after = screenshot(f'after-click-{label}')
    return before, after

def type_text(text, label='input'):
    pyautogui.hotkey('ctrl', 'a')  # Select all existing text
    pyautogui.typewrite(text, interval=0.02) if text.isascii() else pyautogui.write(text)
    time.sleep(0.3)
    screenshot(f'typed-{label}')

def test_keyboard_shortcut(keys, label='shortcut'):
    before = screenshot(f'before-{label}')
    pyautogui.hotkey(*keys)
    time.sleep(0.5)
    after = screenshot(f'after-{label}')
    return before, after

def drag_element(start_x, start_y, end_x, end_y, label='drag'):
    before = screenshot(f'before-{label}')
    pyautogui.moveTo(start_x, start_y)
    pyautogui.drag(end_x - start_x, end_y - start_y, duration=0.5)
    time.sleep(0.5)
    after = screenshot(f'after-{label}')
    return before, after

def scroll_test(x, y, amount, label='scroll'):
    pyautogui.moveTo(x, y)
    before = screenshot(f'before-{label}')
    pyautogui.scroll(amount)
    time.sleep(0.3)
    after = screenshot(f'after-{label}')
    return before, after

# Window management
def find_app_window(title_substring):
    windows = pygetwindow.getWindowsWithTitle(title_substring)
    if windows:
        win = windows[0]
        win.activate()
        win.maximize()
        time.sleep(0.5)
        return win
    return None

# Locate elements on screen by image matching
def find_element(image_path, confidence=0.8):
    try:
        location = pyautogui.locateOnScreen(image_path, confidence=confidence)
        if location:
            center = pyautogui.center(location)
            return center
    except Exception:
        pass
    return None
```

---

## Phase 4: Performance Profiling and Optimization

### Frame Rate and Render Performance

This phase measures rendering performance and optimizes it without sacrificing
visual quality or features.

**Web apps (browser performance API):**

```javascript
async function profilePerformance(page) {
  // Measure frame rate
  const fps = await page.evaluate(() => {
    return new Promise(resolve => {
      let frames = 0;
      let startTime = performance.now();

      function countFrame() {
        frames++;
        if (performance.now() - startTime < 5000) {
          requestAnimationFrame(countFrame);
        } else {
          resolve(Math.round(frames / 5));
        }
      }
      requestAnimationFrame(countFrame);
    });
  });

  console.log(`Frame rate: ${fps} FPS`);

  // Measure long tasks
  const longTasks = await page.evaluate(() => {
    return new Promise(resolve => {
      const tasks = [];
      const observer = new PerformanceObserver(list => {
        for (const entry of list.getEntries()) {
          tasks.push({
            name: entry.name,
            duration: Math.round(entry.duration),
            startTime: Math.round(entry.startTime)
          });
        }
      });
      observer.observe({ entryTypes: ['longtask'] });

      // Trigger interactions that might cause long tasks
      window.scrollTo(0, document.body.scrollHeight);
      window.scrollTo(0, 0);

      setTimeout(() => {
        observer.disconnect();
        resolve(tasks);
      }, 5000);
    });
  });

  // Measure layout shifts
  const layoutShifts = await page.evaluate(() => {
    return new Promise(resolve => {
      let totalShift = 0;
      const observer = new PerformanceObserver(list => {
        for (const entry of list.getEntries()) {
          if (!entry.hadRecentInput) {
            totalShift += entry.value;
          }
        }
      });
      observer.observe({ entryTypes: ['layout-shift'] });

      setTimeout(() => {
        observer.disconnect();
        resolve(totalShift);
      }, 5000);
    });
  });

  // Memory usage
  const memory = await page.evaluate(() => {
    if (performance.memory) {
      return {
        usedJSHeapSize: Math.round(performance.memory.usedJSHeapSize / 1024 / 1024),
        totalJSHeapSize: Math.round(performance.memory.totalJSHeapSize / 1024 / 1024)
      };
    }
    return null;
  });

  // Network requests count and size
  const networkStats = await page.evaluate(() => {
    const entries = performance.getEntriesByType('resource');
    return {
      totalRequests: entries.length,
      totalSize: Math.round(entries.reduce((sum, e) => sum + (e.transferSize || 0), 0) / 1024),
      slowestRequest: entries.sort((a, b) => b.duration - a.duration)[0]?.name || 'none',
      slowestDuration: Math.round(entries.sort((a, b) => b.duration - a.duration)[0]?.duration || 0)
    };
  });

  return {
    fps,
    longTasks,
    cumulativeLayoutShift: layoutShifts,
    memory,
    network: networkStats
  };
}
```

### Performance Report Format

```
=== PERFORMANCE PROFILE ===
Timestamp: [timestamp]

FRAME RATE:
  Current: [X] FPS
  Target:  60 FPS
  Status:  [PASS if >= 55 / WARN if 30-54 / FAIL if < 30]

LONG TASKS (>50ms):
  [task-1]: [duration]ms at [startTime]ms
  [task-2]: [duration]ms at [startTime]ms

LAYOUT SHIFTS:
  Cumulative Layout Shift: [score]
  Status: [PASS if < 0.1 / WARN if 0.1-0.25 / FAIL if > 0.25]

MEMORY:
  JS Heap: [X] MB / [Y] MB
  Status: [PASS / WARN if growing / FAIL if leak detected]

NETWORK:
  Total requests: [N]
  Total transfer: [X] KB
  Slowest: [url] ([X]ms)

BOTTLENECKS IDENTIFIED:
  [B-001]: [description] -> [proposed fix]
  [B-002]: [description] -> [proposed fix]
============================
```

### Optimization Loop

For each bottleneck identified:

1. Record the current metric (e.g., "38 FPS")
2. Apply the fix
3. Re-measure the exact same metric
4. Show before/after: "38 FPS -> 62 FPS"
5. Take a screenshot proving visual quality is unchanged
6. Run the full feature inventory check to prove nothing broke
7. If quality degraded or features broke, REVERT the change and try a different approach

**Critical constraint: NEVER sacrifice quality for speed.**

Compare before/after screenshots pixel-by-pixel if needed:

```javascript
const { PNG } = require('pngjs');
const pixelmatch = require('pixelmatch');

function compareScreenshots(beforePath, afterPath) {
  const before = PNG.sync.read(fs.readFileSync(beforePath));
  const after = PNG.sync.read(fs.readFileSync(afterPath));
  const diff = new PNG({ width: before.width, height: before.height });

  const mismatchedPixels = pixelmatch(
    before.data, after.data, diff.data,
    before.width, before.height,
    { threshold: 0.1 }
  );

  const totalPixels = before.width * before.height;
  const mismatchPercent = (mismatchedPixels / totalPixels) * 100;

  return {
    mismatchedPixels,
    mismatchPercent: mismatchPercent.toFixed(2),
    acceptable: mismatchPercent < 1.0  // Less than 1% pixel difference
  };
}
```

---

## Phase 5: Post-Redesign Feature Verification

After a UI redesign, every feature from the original design must still exist
and work. This phase cross-references the feature inventory against the actual UI.

### Verification Checklist

```
=== REDESIGN VERIFICATION ===

FEATURE PRESENCE:
  [x] Every button from original exists in redesign
  [x] Every form field from original exists in redesign
  [x] Every navigation link from original exists in redesign
  [x] Every dropdown/select from original exists in redesign
  [x] Every toggle/checkbox from original exists in redesign
  [x] Every keyboard shortcut still works
  [x] Every modal/dialog still triggers

FEATURE BEHAVIOR:
  [x] Every button does the same thing it did before
  [x] Every form submits to the same endpoint
  [x] Every link goes to the same destination
  [x] Every validation rule still applies
  [x] Every error message still appears
  [x] Data persistence works the same way

VISUAL QUALITY:
  [x] No elements overlapping
  [x] No text truncation
  [x] No broken images
  [x] No invisible/hidden elements that should be visible
  [x] Responsive at all breakpoints (mobile, tablet, desktop)
  [x] Dark mode (if applicable) works on all screens
  [x] Animations complete smoothly

ACCESSIBILITY:
  [x] Tab order is logical
  [x] All form inputs have labels
  [x] All images have alt text
  [x] Color contrast passes WCAG AA
  [x] Screen reader can navigate all content

MISSING FEATURES:
  [ ] [feature-name] -- was in original, missing in redesign
  [ ] [feature-name] -- was in original, broken in redesign
==============================
```

### Responsive Testing

Test at these viewport sizes:

```javascript
const viewports = [
  { name: 'mobile-small',   width: 320,  height: 568  },  // iPhone SE
  { name: 'mobile-medium',  width: 375,  height: 812  },  // iPhone X
  { name: 'mobile-large',   width: 428,  height: 926  },  // iPhone 14 Pro Max
  { name: 'tablet-portrait', width: 768, height: 1024 },  // iPad
  { name: 'tablet-landscape', width: 1024, height: 768 }, // iPad landscape
  { name: 'desktop-small',  width: 1280, height: 720  },  // HD
  { name: 'desktop-medium', width: 1920, height: 1080 },  // Full HD
  { name: 'desktop-large',  width: 2560, height: 1440 },  // QHD
  { name: 'ultrawide',      width: 3440, height: 1440 },  // Ultrawide
];

for (const vp of viewports) {
  await page.setViewportSize({ width: vp.width, height: vp.height });
  await page.waitForTimeout(500);
  await page.screenshot({
    path: `.phantom-depth/screenshots/responsive-${vp.name}.png`,
    fullPage: true
  });
  console.log(`Captured ${vp.name} (${vp.width}x${vp.height})`);
}
```

---

## Phase 6: Autonomous Improvement Loop

This is full autonomous control. The agent continuously discovers and implements
improvements without asking for permission.

### The Improvement Cycle

```
┌─────────────────────────────────────────────┐
│         STEP 1: DEEP ANALYSIS               │
│  - Profile performance                      │
│  - Analyze UX patterns                      │
│  - Review error handling                     │
│  - Check accessibility                      │
│  - Evaluate code architecture               │
│  - Scan for security issues                 │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│         STEP 2: RANK OPPORTUNITIES          │
│  Priority: crash > wrong > slow > ugly >    │
│  inconvenient > suboptimal                  │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│         STEP 3: IMPLEMENT FIX               │
│  - Make the smallest possible change        │
│  - One improvement at a time                │
│  - Never bundle unrelated changes           │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│         STEP 4: VISUAL VERIFICATION         │
│  - Take screenshot after change             │
│  - Compare with baseline screenshot         │
│  - Verify no visual regression              │
│  - Verify the improvement is visible        │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│         STEP 5: FUNCTIONAL VERIFICATION     │
│  - Click every button on affected screen    │
│  - Submit every form on affected screen     │
│  - Run the full test suite                  │
│  - Check console for new errors             │
│  - Measure performance (did it improve?)    │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│         STEP 6: COMMIT AND CONTINUE         │
│  - Git commit the improvement               │
│  - Log the before/after metrics             │
│  - Return to STEP 1 with fresh eyes         │
└─────────────────────────────────────────────┘
```

### What to Look For

The agent should actively discover and fix:

**Crashes and Errors:**
- Unhandled exceptions
- Failed API calls with no error UI
- Null/undefined property access
- Race conditions (click during loading)
- Memory leaks (repeated actions cause slowdown)

**Performance:**
- Functions that block the main thread (>50ms)
- Unnecessary re-renders (React profiler)
- Unoptimized images (not lazy-loaded, no srcset)
- Missing request caching
- Synchronous operations that could be async
- Bundle size bloat (unused imports/dependencies)

**User Experience:**
- Actions with no feedback (click a button, nothing visible happens)
- Missing loading states
- Missing error states
- Forms that lose data on navigation
- Confusing navigation paths (>3 clicks to reach a feature)
- Missing confirmation dialogs for destructive actions

**Accessibility:**
- Missing ARIA labels
- Poor color contrast
- No keyboard navigation path
- Focus traps in modals
- Missing skip-to-content link
- Images without alt text

**Security:**
- XSS via user input reflected in DOM
- Sensitive data in localStorage/sessionStorage
- API keys in client-side code
- Missing CSRF protection
- Insecure cookie settings

---

## Phase 7: Reporting

### Status Checkpoints (Every 5 Actions)

```
=== PHANTOM DEPTH CHECKPOINT ===
Cycle: [N]
Time elapsed: [X minutes]

TESTED:
  Elements tested: [X] / [total]
  Combinations tested: [X] / [total]
  Screenshots captured: [X]

FOUND:
  Bugs: [X] (critical: [X], error: [X], warning: [X])
  Performance issues: [X]
  Improvements made: [X]

FIXED:
  Issues fixed: [X]
  Issues verified: [X]
  Regressions: [X]

PERFORMANCE:
  Frame rate: [before] FPS -> [after] FPS
  Load time: [before]ms -> [after]ms
  Memory: [before] MB -> [after] MB

NEXT:
  [what the agent is doing next]
=================================
```

### Final Report

```
=== PHANTOM DEPTH FINAL REPORT ===
Application: [name]
Duration: [total time]
Date: [timestamp]

COVERAGE:
  Screens tested: [X] / [X] (100%)
  Elements tested: [X] / [X] (100%)
  Combinations tested: [X]
  Screenshots captured: [X]

RESULTS:
  Total issues found: [X]
  Total issues fixed: [X]
  Total improvements made: [X]
  Regressions introduced: 0

PERFORMANCE DELTA:
  Frame rate: [before] -> [after] FPS ([+X%])
  Page load: [before] -> [after] ms ([-X%])
  Memory usage: [before] -> [after] MB
  Network requests: [before] -> [after]
  Bundle size: [before] -> [after] KB

EVIDENCE:
  Screenshots: .phantom-depth/screenshots/
  Videos: .phantom-depth/videos/
  Performance logs: .phantom-depth/perf-log.json
  Test report: .phantom-depth/report.json

VERIFICATION:
  All features present: [YES/NO]
  All tests passing: [YES/NO]
  No visual regressions: [YES/NO]
  Performance improved: [YES/NO]
  Zero console errors: [YES/NO]
======================================
```

---

## Constraints

- NEVER close the application while tests are running
- NEVER skip an element because "it probably works"
- NEVER sacrifice visual quality for performance
- NEVER make changes without taking before/after screenshots
- NEVER declare completion without a final full-application walkthrough
- NEVER stop the loop while there are known unfixed issues
- NEVER bundle multiple unrelated fixes into one change
- ALWAYS take a screenshot before AND after every interaction
- ALWAYS re-run affected tests after every fix
- ALWAYS check for regressions after every change
- ALWAYS measure performance before and after optimization changes
- ALWAYS compare baseline screenshots with post-change screenshots
- If you truly cannot fix something, document it with screenshots showing the exact failure and move on, but come back to it before declaring complete
