# Azure DevOps

When the user provides an Azure DevOps URL on `dev.azure.com`, including links
to pull requests, work items, user stories, wiki pages, repositories, builds,
pipelines, or boards:

- Do not fetch the URL directly with HTTP tools such as `curl`, `wget`, browser
  fetchers, or web-search tools; these URLs require authenticated access.
- Use the authenticated Azure CLI instead: `az` and `az devops`.
- Parse the organization, project, and resource identifiers from the URL, then
  use the appropriate Azure DevOps CLI command or `az devops invoke`.
- If the needed Azure DevOps CLI extension is unavailable, install it with
  `az extension add --name azure-devops`.
- Prefer read-only commands unless the user explicitly requests a change.
- Before any mutation—creating, updating, completing, abandoning, or deleting
  Azure DevOps resources—state exactly what will change and request confirmation.
- If CLI access fails because the current Azure subscription, organization,
  project, or authentication context is incorrect, report the CLI error and ask
  the user which context to use rather than attempting unauthenticated access.

# Exlain/investigate
When the user asks to explain/investigate smth, don't change files, just provide details explanation on the topic user asked.

# Running lint, format, checks
- After editing, format only edited source files. Lint only changed files. Do not run full-repository lint, formatting, or tests unless explicitly requested, before a commit, or after a broad refactor.
- Never run all tests, run only tests related to changes. Prefer 

# Commit files rule
Never commit test files unless explictly specified

# CLI scripts
You are running in nushell, when providing any script for user output for nushell

# Long-running / background processes (Windows PowerShell)
Tool calls can hang and never return when a command leaves a long-running child
process behind (dev servers, watchers, `agent-browser` daemons). The tool waits
for the process tree, so the shell can finish while the call stays blocked.
Treat every process-starting command as hostile until proven otherwise:

- Default: keep the process lifetime inside a single tool call and stop it in
  `finally` before the call returns. This can never hang, because the tool gets
  completion once the child is dead.

  ```powershell
  $p = Start-Process node -ArgumentList 'server.js' -PassThru -WindowStyle Hidden `
    -RedirectStandardOutput "$env:TEMP\app.out.log" -RedirectStandardError "$env:TEMP\app.err.log"
  try {
    for ($i = 0; $i -lt 20; $i++) {
      Start-Sleep -Seconds 1
      if (Get-NetTCPConnection -LocalPort 3000 -State Listen -ErrorAction SilentlyContinue) { break }
    }
    curl.exe -s --max-time 10 http://localhost:3000/ -o "$env:TEMP\page.html"
  } finally {
    Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
  }
  ```

- If a process must outlive the tool call (the user explicitly wants a server
  kept running), launch it detached and do NOT use `Start-Process
  -RedirectStandardOutput/-RedirectStandardError` — that option makes the child
  inherit the tool's stdio handles and is the main hang trigger. Redirect inside
  a `cmd.exe` child instead:

  ```powershell
  Start-Process cmd.exe -WindowStyle Hidden `
    -ArgumentList '/c','start "" /min cmd.exe /c "node server.js > %TEMP%\app.log 2>&1"'
  ```

  Still expect that call to possibly not return; continue in a new call, and
  clean up later by PID/port.
- Always pass the tool `timeout` for process-starting commands, and record the
  PID (`$p.Id | Out-File ...`) so it can be stopped later.
- Probe HTTP with `curl.exe --max-time N`, never bare `Invoke-WebRequest`
  (PS 5.1 can wait indefinitely). Avoid `Get-CimInstance Win32_Process` (WMI
  enumeration hangs); use `Get-Process`, `Get-NetTCPConnection`, `netstat -ano`.
- PS 5.1 parsing: parentheses inside an interpolated `"$()"` string (e.g.
  `"$($x.Contains('('))"`) can fail with "missing the closing ')'"; compute
  values in separate statements before printing.
