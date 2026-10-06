---
name: writing-pr-descriptions
description: Use when writing or editing a pull request description in the Eunomia repository (Azure DevOps), or when asked to draft/rewrite a PR description before creating or updating a pull request.
---

# Writing PR Descriptions

## Overview

Every PR in this repo uses the same short template. A good description is
**terse and reviewer-oriented**: enough to understand the change and reproduce
it, nothing more. Match the existing PRs (581, 586, 587), not a design doc.

## Output Contract

Fill this template exactly. Do not add sections, do not reorder.

```markdown
## Summary

## Testing Instructions

1.

## Proof of Acceptance Criteria

## Self-Review Checklist

- [ ] I have performed a self-review of my changes
- [ ] No debug code, commented-out code, or unintended file changes remain
- [ ] Code follows existing project conventions and patterns
- [ ] Tests and documentation updated where appropriate
- [ ] Configuration, accessibility, and security implications considered where applicable
```

### Summary
- 1-3 sentences: the problem and the fix. Optionally 2-4 short bullets.
- If the branch sits on top of an unmerged branch, say the base and the dependency
  (e.g. "Base is `E-1963-shared`; depends on E-1963 (PR 579).").
- Do not paste the work item, root-cause analysis, or a file-by-file diff.

### Testing Instructions
- Numbered, **high-level** steps any reviewer can reproduce on their own
  environment ("start the stack", "stop the API", "probe `/settings`").
- End each assertion step with its acceptance criterion id in parentheses:
  `... never a 200 with null settings (AC1, AC2).`
- Do **not** reference uncommitted/local-only scripts or absolute paths.
- Do **not** list unit-test commands — CI runs them.

### Proof of Acceptance Criteria
- Default to the single line: `Tested locally according to the steps above.`
- Only when the change has UI/visual output, attach a screenshot/recording.

### Self-Review Checklist
- Keep the five checkboxes verbatim; tick them (`[x]`) once self-review is done.

## Example (E-1972)

```markdown
## Summary

Return 503 (`Cache-Control: no-store`) from `ally.local/settings` until the first
successful settings fetch, so a Proxy Agent bootstrapping during a server start
never gets a cacheable 200 with an empty PAC.

Base is `E-1963-shared`; depends on E-1963 (PR 579).

## Testing Instructions

1. Start the stack (mitmproxy + Admin API) from this branch.
2. Stop the Admin API, then start/restart the proxy so it comes up before the API is reachable.
3. Request `http://ally.local/settings` through the proxy: expect 503 (not cacheable) until the API is up, then 200 with a populated PAC - never a 200 with null/empty settings (AC1, AC2).
4. Bootstrap a Proxy Agent during the window: it should keep retrying and end fully configured once the API is up, without a manual restart (AC4).
5. With the proxy healthy, stop the API again and request `/settings`: it should keep serving the last good PAC (200) (AC3).
6. Check the proxy log: one INFO line when settings first load (AC5).

## Proof of Acceptance Criteria

Tested locally according to the steps above.

## Self-Review Checklist

- [x] I have performed a self-review of my changes
- [x] No debug code, commented-out code, or unintended file changes remain
- [x] Code follows existing project conventions and patterns
- [x] Tests and documentation updated where appropriate
- [x] Configuration, accessibility, and security implications considered where applicable
```

## Common Mistakes

| Mistake | Fix |
| --- | --- |
| Testing Instructions mention a local harness/path (`C:\tmp\...`, `test-*.ps1`) | Describe the actions, not the tool |
| Unit-test commands in Testing Instructions | Remove — CI runs them |
| Per-AC evidence table in Proof | Replace with `Tested locally according to the steps above.` |
| Multi-paragraph Summary / root-cause essay | 1-3 sentences + optional bullets |
| No AC ids on assertion steps | Append `(AC1)`, `(AC2)`, … |

## Red Flags — rewrite the description

- Contains a `C:\` path, `test-*.ps1`, `uv run pytest`, `dotnet test`, or an inline JSON payload.
- Proof section is longer than one line (except a screenshot for UI changes).
- Summary is longer than four lines.
- Any template heading is missing or renamed.
