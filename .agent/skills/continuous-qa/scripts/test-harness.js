#!/usr/bin/env node

/**
 * PhantomQA Test Harness
 * 
 * Universal software testing script that works with any project type.
 * Runs a battery of checks and outputs structured results that the
 * Antigravity agent can parse and act on.
 * 
 * Usage: node test-harness.js [--project-root /path/to/project]
 */

import fs from "fs";
import path from "path";
import { execSync } from "child_process";

const args = process.argv.slice(2);
const rootIndex = args.indexOf("--project-root");
const PROJECT_ROOT = rootIndex !== -1 ? args[rootIndex + 1] : process.cwd();

const issues = [];
let issueCounter = 0;

// ── Helpers ─────────────────────────────────────────────────────
function addIssue(severity, category, message, file = null, line = null, fix = null) {
  const id = `${severity[0].toUpperCase()}-${String(++issueCounter).padStart(3, "0")}`;
  issues.push({ id, severity, category, message, file, line, fix });
}

function runCmd(cmd, opts = {}) {
  try {
    return execSync(cmd, {
      cwd: PROJECT_ROOT,
      encoding: "utf-8",
      timeout: 30000,
      stdio: ["pipe", "pipe", "pipe"],
      ...opts,
    });
  } catch (e) {
    return e.stdout || e.stderr || e.message || "";
  }
}

function fileExists(p) {
  return fs.existsSync(path.join(PROJECT_ROOT, p));
}

function findFiles(pattern, excludeDirs = ["node_modules", ".git", "__pycache__", "venv", ".venv", "dist", "build", ".next"]) {
  const excludeArgs = excludeDirs.map((d) => `--exclude-dir=${d}`).join(" ");
  return runCmd(`grep -rln ${pattern} ${excludeArgs} . 2>/dev/null || true`).trim().split("\n").filter(Boolean);
}

function grepWithContext(pattern, extensions = "js,jsx,ts,tsx,py,go,rs,html,css,vue,svelte,rb,java,cpp,c,h") {
  const includes = extensions.split(",").map((e) => `--include="*.${e}"`).join(" ");
  const excludes = "--exclude-dir=node_modules --exclude-dir=.git --exclude-dir=__pycache__ --exclude-dir=dist --exclude-dir=build --exclude-dir=venv";
  return runCmd(`grep -rn ${pattern} ${includes} ${excludes} . 2>/dev/null || true`).trim().split("\n").filter(Boolean);
}

// ── Detect Project Type ─────────────────────────────────────────
function detectProject() {
  const project = {
    type: "unknown",
    language: "unknown",
    framework: "unknown",
    hasTests: false,
    hasBuild: false,
    hasDocker: false,
  };

  if (fileExists("package.json")) {
    project.language = "javascript";
    const pkg = JSON.parse(fs.readFileSync(path.join(PROJECT_ROOT, "package.json"), "utf-8"));
    const deps = { ...pkg.dependencies, ...pkg.devDependencies };
    if (deps["react"]) project.framework = "react";
    else if (deps["vue"]) project.framework = "vue";
    else if (deps["svelte"]) project.framework = "svelte";
    else if (deps["next"]) project.framework = "nextjs";
    else if (deps["express"]) project.framework = "express";
    else if (deps["fastify"]) project.framework = "fastify";
    if (pkg.scripts?.test) project.hasTests = true;
    if (pkg.scripts?.build) project.hasBuild = true;
    project.type = deps["react"] || deps["vue"] || deps["svelte"] ? "frontend" : "backend";
  } else if (fileExists("requirements.txt") || fileExists("pyproject.toml") || fileExists("setup.py")) {
    project.language = "python";
    project.type = "python";
    if (fileExists("manage.py")) project.framework = "django";
    else if (fileExists("app.py") || fileExists("wsgi.py")) project.framework = "flask";
  } else if (fileExists("Cargo.toml")) {
    project.language = "rust";
    project.type = "rust";
  } else if (fileExists("go.mod")) {
    project.language = "go";
    project.type = "go";
  } else if (fileExists("pom.xml") || fileExists("build.gradle")) {
    project.language = "java";
    project.type = "java";
  }

  project.hasDocker = fileExists("Dockerfile") || fileExists("docker-compose.yml");
  return project;
}

// ── Check: Placeholder Content ──────────────────────────────────
function checkPlaceholders() {
  console.log("  [1/8] Scanning for placeholder content...");

  const patterns = [
    { pattern: '"lorem ipsum"', label: "Lorem ipsum text" },
    { pattern: '"dolor sit amet"', label: "Lorem ipsum text" },
    { pattern: '"TODO"', label: "TODO marker" },
    { pattern: '"FIXME"', label: "FIXME marker" },
    { pattern: '"HACK"', label: "HACK marker" },
    { pattern: '"XXX"', label: "XXX marker" },
    { pattern: '"placeholder"', label: "Placeholder reference", caseSensitive: false },
    { pattern: '"example\\.com"', label: "Example domain" },
    { pattern: '"test@test"', label: "Test email" },
    { pattern: '"john.doe\\|jane.doe"', label: "Dummy name" },
    { pattern: '"foo.bar\\|foobar"', label: "Foobar test data" },
    { pattern: '"coming soon"', label: "Coming soon placeholder", caseSensitive: false },
    { pattern: '"under construction"', label: "Under construction placeholder", caseSensitive: false },
    { pattern: '"sample text\\|sample data\\|sample content"', label: "Sample placeholder", caseSensitive: false },
    { pattern: '"TBD\\|TBA"', label: "TBD/TBA marker" },
    { pattern: '"your.* here"', label: "Fill-in-the-blank placeholder", caseSensitive: false },
    { pattern: '"\\$[0-9]\\+\\.00"', label: "Suspiciously round price" },
  ];

  for (const { pattern, label, caseSensitive } of patterns) {
    const flag = caseSensitive === false ? "-i" : "";
    const results = grepWithContext(`${flag} ${pattern}`);
    for (const line of results) {
      const match = line.match(/^\.\/(.+?):(\d+):(.+)$/);
      if (match) {
        addIssue("warning", "placeholder", `${label} found: ${match[3].trim().slice(0, 120)}`, match[1], parseInt(match[2]), `Replace ${label.toLowerCase()} with real content`);
      }
    }
  }
}

// ── Check: Code Quality ─────────────────────────────────────────
function checkCodeQuality() {
  console.log("  [2/8] Checking code quality...");

  // Debug statements
  const debugPatterns = [
    { pattern: '"console\\.log"', label: "console.log debug statement", ext: "js,jsx,ts,tsx,vue,svelte" },
    { pattern: '"print("', label: "print() debug statement", ext: "py" },
    { pattern: '"fmt\\.Println"', label: "fmt.Println debug statement", ext: "go" },
    { pattern: '"println!"', label: "println! debug statement", ext: "rs" },
    { pattern: '"System\\.out\\.print"', label: "System.out.print debug statement", ext: "java" },
  ];

  for (const { pattern, label, ext } of debugPatterns) {
    const results = grepWithContext(pattern, ext);
    for (const line of results) {
      // Skip test files
      if (/\.(test|spec|_test)\./i.test(line)) continue;
      const match = line.match(/^\.\/(.+?):(\d+):(.+)$/);
      if (match) {
        addIssue("info", "code-quality", `${label}: ${match[3].trim().slice(0, 120)}`, match[1], parseInt(match[2]), "Remove debug statement or replace with proper logging");
      }
    }
  }

  // Hardcoded secrets
  const secretPatterns = [
    '"password\\s*=\\s*[\'\\"]"',
    '"api_key\\s*=\\s*[\'\\"]"',
    '"secret\\s*=\\s*[\'\\"]"',
    '"token\\s*=\\s*[\'\\"]"',
    '"PRIVATE_KEY"',
  ];

  for (const pattern of secretPatterns) {
    const results = grepWithContext(pattern);
    for (const line of results) {
      if (/\.env\.example|\.env\.sample|test|spec|mock/i.test(line)) continue;
      const match = line.match(/^\.\/(.+?):(\d+):(.+)$/);
      if (match) {
        addIssue("critical", "security", `Possible hardcoded secret: ${match[3].trim().slice(0, 100)}`, match[1], parseInt(match[2]), "Move to environment variable or secrets manager");
      }
    }
  }

  // Empty catch blocks
  const emptyCatches = grepWithContext('"catch\\s*(.*?)\\s*{\\s*}"', "js,jsx,ts,tsx");
  for (const line of emptyCatches) {
    const match = line.match(/^\.\/(.+?):(\d+):(.+)$/);
    if (match) {
      addIssue("warning", "code-quality", `Empty catch block (errors silently swallowed)`, match[1], parseInt(match[2]), "Add error handling or at minimum log the error");
    }
  }
}

// ── Check: Build ────────────────────────────────────────────────
function checkBuild(project) {
  console.log("  [3/8] Attempting build...");

  let buildCmd;
  switch (project.language) {
    case "javascript":
      if (project.hasBuild) buildCmd = "npm run build 2>&1";
      break;
    case "python":
      buildCmd = "python -m py_compile $(find . -name '*.py' -not -path './venv/*' -not -path './.venv/*' | head -20 | tr '\\n' ' ') 2>&1";
      break;
    case "rust":
      buildCmd = "cargo check 2>&1";
      break;
    case "go":
      buildCmd = "go build ./... 2>&1";
      break;
    case "java":
      if (fileExists("pom.xml")) buildCmd = "mvn compile 2>&1";
      else if (fileExists("build.gradle")) buildCmd = "gradle compileJava 2>&1";
      break;
  }

  if (!buildCmd) {
    addIssue("info", "build", "No build command detected for this project type");
    return;
  }

  const output = runCmd(buildCmd);
  if (output.toLowerCase().includes("error") || output.toLowerCase().includes("failed")) {
    // Extract individual errors
    const errorLines = output.split("\n").filter((l) => /error|Error|ERROR|failed|Failed/i.test(l));
    for (const errLine of errorLines.slice(0, 20)) {
      addIssue("critical", "build", `Build error: ${errLine.trim().slice(0, 200)}`, null, null, "Fix the build error");
    }
  } else {
    addIssue("passed", "build", "Build completed successfully");
  }
}

// ── Check: Tests ────────────────────────────────────────────────
function checkTests(project) {
  console.log("  [4/8] Running test suite...");

  let testCmd;
  switch (project.language) {
    case "javascript":
      if (project.hasTests) testCmd = "npm test -- --passWithNoTests 2>&1";
      break;
    case "python":
      testCmd = "python -m pytest -v --tb=short 2>&1 || python -m unittest discover -v 2>&1";
      break;
    case "rust":
      testCmd = "cargo test 2>&1";
      break;
    case "go":
      testCmd = "go test -v ./... 2>&1";
      break;
  }

  if (!testCmd) {
    addIssue("warning", "tests", "No test suite found. Consider adding tests.", null, null, "Add unit tests for core functionality");
    return;
  }

  const output = runCmd(testCmd);
  const failMatch = output.match(/(\d+)\s*(fail|failed|FAIL)/i);
  const passMatch = output.match(/(\d+)\s*(pass|passed|PASS|ok)/i);

  if (failMatch) {
    addIssue("error", "tests", `${failMatch[1]} test(s) failing`, null, null, "Fix failing tests");
    // Extract individual failures
    const failLines = output.split("\n").filter((l) => /FAIL|fail|✕|✗|Error|AssertionError/i.test(l));
    for (const fl of failLines.slice(0, 15)) {
      addIssue("error", "tests", `Test failure: ${fl.trim().slice(0, 200)}`);
    }
  } else if (passMatch) {
    addIssue("passed", "tests", `${passMatch[1]} test(s) passing`);
  }
}

// ── Check: Dependencies ─────────────────────────────────────────
function checkDependencies(project) {
  console.log("  [5/8] Checking dependencies...");

  if (project.language === "javascript" && fileExists("package.json")) {
    // Check if node_modules exists
    if (!fileExists("node_modules")) {
      addIssue("critical", "dependencies", "node_modules missing -- dependencies not installed", "package.json", null, "Run: npm install");
      return;
    }

    // Check for outdated/vulnerable packages
    const auditOutput = runCmd("npm audit --json 2>/dev/null || true");
    try {
      const audit = JSON.parse(auditOutput);
      if (audit.metadata?.vulnerabilities) {
        const { critical, high, moderate } = audit.metadata.vulnerabilities;
        if (critical > 0) addIssue("critical", "dependencies", `${critical} critical vulnerability(ies) in dependencies`, null, null, "Run: npm audit fix");
        if (high > 0) addIssue("error", "dependencies", `${high} high severity vulnerability(ies)`, null, null, "Run: npm audit fix");
        if (moderate > 0) addIssue("warning", "dependencies", `${moderate} moderate vulnerability(ies)`, null, null, "Run: npm audit fix");
      }
    } catch {}
  }

  if (project.language === "python") {
    // Check if requirements are installed
    if (fileExists("requirements.txt")) {
      const missing = runCmd("pip check 2>&1 || true");
      if (missing.includes("has requirement") || missing.includes("not found")) {
        addIssue("error", "dependencies", `Missing Python dependencies detected`, null, null, "Run: pip install -r requirements.txt");
      }
    }
  }
}

// ── Check: File Structure ───────────────────────────────────────
function checkStructure() {
  console.log("  [6/8] Checking project structure...");

  // Missing essential files
  const essentialFiles = [
    { file: "README.md", fix: "Add a README.md with project documentation" },
    { file: ".gitignore", fix: "Add a .gitignore to prevent committing build artifacts and secrets" },
  ];

  for (const { file, fix } of essentialFiles) {
    if (!fileExists(file)) {
      addIssue("warning", "structure", `Missing ${file}`, null, null, fix);
    }
  }

  // Check for committed secrets files
  const dangerousFiles = [".env", ".env.local", ".env.production"];
  for (const file of dangerousFiles) {
    if (fileExists(file)) {
      // Check if it's in gitignore
      const gitignore = fileExists(".gitignore") ? fs.readFileSync(path.join(PROJECT_ROOT, ".gitignore"), "utf-8") : "";
      if (!gitignore.includes(file) && !gitignore.includes(".env")) {
        addIssue("critical", "security", `${file} exists but is not in .gitignore`, file, null, `Add ${file} to .gitignore`);
      }
    }
  }

  // Check for empty directories
  const emptyDirs = runCmd('find . -type d -empty -not -path "./.git/*" -not -path "./node_modules/*" 2>/dev/null || true').trim();
  if (emptyDirs) {
    for (const dir of emptyDirs.split("\n").filter(Boolean).slice(0, 10)) {
      addIssue("info", "structure", `Empty directory: ${dir}`, null, null, "Remove or add content");
    }
  }
}

// ── Check: Application Runtime ──────────────────────────────────
function checkRuntime(project) {
  console.log("  [7/8] Checking application runtime...");

  // Try to import/compile the entry point
  if (project.language === "javascript") {
    const entryPoints = ["index.js", "src/index.js", "src/main.js", "src/app.js", "server.js", "app.js"];
    for (const entry of entryPoints) {
      if (fileExists(entry)) {
        const output = runCmd(`node --check ${entry} 2>&1`);
        if (output.includes("SyntaxError") || output.includes("Error")) {
          addIssue("critical", "runtime", `Syntax error in ${entry}: ${output.slice(0, 200)}`, entry, null, "Fix the syntax error");
        } else {
          addIssue("passed", "runtime", `${entry} passes syntax check`);
        }
        break;
      }
    }
  }

  if (project.language === "python") {
    const entryPoints = ["app.py", "main.py", "manage.py", "src/main.py", "src/app.py"];
    for (const entry of entryPoints) {
      if (fileExists(entry)) {
        const output = runCmd(`python -m py_compile ${entry} 2>&1`);
        if (output) {
          addIssue("critical", "runtime", `Python syntax error in ${entry}: ${output.slice(0, 200)}`, entry, null, "Fix the syntax error");
        } else {
          addIssue("passed", "runtime", `${entry} compiles cleanly`);
        }
        break;
      }
    }
  }
}

// ── Check: TypeScript / Linting ─────────────────────────────────
function checkLinting(project) {
  console.log("  [8/8] Running linting checks...");

  if (project.language === "javascript") {
    // TypeScript check
    if (fileExists("tsconfig.json")) {
      const output = runCmd("npx tsc --noEmit 2>&1 || true");
      const errors = output.split("\n").filter((l) => /error TS/i.test(l));
      for (const err of errors.slice(0, 20)) {
        const match = err.match(/(.+?)\((\d+),\d+\):\s*error\s*TS\d+:\s*(.+)/);
        if (match) {
          addIssue("error", "typescript", match[3].trim(), match[1], parseInt(match[2]), "Fix TypeScript error");
        } else {
          addIssue("error", "typescript", err.trim().slice(0, 200));
        }
      }
      if (errors.length === 0 && output.length < 10) {
        addIssue("passed", "typescript", "TypeScript compilation clean");
      }
    }

    // ESLint check
    if (fileExists(".eslintrc.js") || fileExists(".eslintrc.json") || fileExists("eslint.config.js")) {
      const output = runCmd("npx eslint . --format compact 2>&1 || true");
      const errorCount = (output.match(/\d+ error/g) || []).length;
      if (errorCount > 0) {
        addIssue("warning", "lint", `ESLint found ${errorCount} error(s)`, null, null, "Run: npx eslint . --fix");
      }
    }
  }

  if (project.language === "python") {
    // Try ruff or flake8
    const ruffOutput = runCmd("ruff check . 2>&1 || true");
    if (ruffOutput && !ruffOutput.includes("command not found") && !ruffOutput.includes("No such file")) {
      const errorLines = ruffOutput.split("\n").filter((l) => /:\d+:\d+:/.test(l));
      if (errorLines.length > 0) {
        addIssue("warning", "lint", `Ruff found ${errorLines.length} issue(s)`, null, null, "Run: ruff check . --fix");
      }
    }
  }
}

// ── Main ────────────────────────────────────────────────────────
function main() {
  console.log(`
╔══════════════════════════════════════════════════╗
║        PhantomQA Test Harness v1.0               ║
║        Autonomous Software Validator             ║
╚══════════════════════════════════════════════════╝
`);
  console.log(`  Project root: ${PROJECT_ROOT}`);
  console.log(`  Timestamp:    ${new Date().toISOString()}`);
  console.log("");

  const project = detectProject();
  console.log(`  Detected: ${project.language} / ${project.framework} (${project.type})`);
  console.log(`  Tests: ${project.hasTests ? "yes" : "no"} | Build: ${project.hasBuild ? "yes" : "no"} | Docker: ${project.hasDocker ? "yes" : "no"}`);
  console.log("");

  // Run all checks
  checkPlaceholders();
  checkCodeQuality();
  checkBuild(project);
  checkTests(project);
  checkDependencies(project);
  checkStructure();
  checkRuntime(project);
  checkLinting(project);

  // Count by severity
  const counts = { critical: 0, error: 0, warning: 0, info: 0, passed: 0 };
  for (const issue of issues) {
    counts[issue.severity] = (counts[issue.severity] || 0) + 1;
  }

  const actionable = counts.critical + counts.error + counts.warning;

  // Output results
  console.log(`
╔══════════════════════════════════════════════════╗
║                  RESULTS                         ║
╠══════════════════════════════════════════════════╣
║  Critical:  ${String(counts.critical).padEnd(36)}║
║  Errors:    ${String(counts.error).padEnd(36)}║
║  Warnings:  ${String(counts.warning).padEnd(36)}║
║  Info:      ${String(counts.info).padEnd(36)}║
║  Passed:    ${String(counts.passed).padEnd(36)}║
║  ─────────────────────────────────────────────  ║
║  Actionable issues: ${String(actionable).padEnd(28)}║
╚══════════════════════════════════════════════════╝
`);

  // Print all actionable issues
  if (actionable > 0) {
    console.log("=== ISSUE CATALOG ===");
    console.log("");

    for (const severity of ["critical", "error", "warning"]) {
      const sev = issues.filter((i) => i.severity === severity);
      if (sev.length === 0) continue;

      console.log(`${severity.toUpperCase()} (${sev.length}):`);
      for (const issue of sev) {
        const location = issue.file ? ` [${issue.file}${issue.line ? `:${issue.line}` : ""}]` : "";
        console.log(`  [ ] ${issue.id}: ${issue.message}${location}`);
        if (issue.fix) console.log(`       Fix: ${issue.fix}`);
      }
      console.log("");
    }

    console.log("=== END CATALOG ===");
  }

  // Write JSON report
  const reportPath = path.join(PROJECT_ROOT, ".phantom-qa-report.json");
  fs.writeFileSync(reportPath, JSON.stringify({ project, issues, counts, timestamp: new Date().toISOString() }, null, 2));
  console.log(`\n  Full report written to: ${reportPath}`);

  // Exit code
  if (counts.critical > 0) process.exit(2);
  if (counts.error > 0) process.exit(1);
  process.exit(0);
}

main();
