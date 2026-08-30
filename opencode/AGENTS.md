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
