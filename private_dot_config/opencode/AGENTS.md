# Fish Rules

- Prefer writing abbreviations over aliases, as they basically have the same effect, except that they make more sense in the shell history, or if I ever have other people read my commands as I'm typing them.
- When writing things like fish or bash scripts, you should generally prefer long names, i.e. (`--help` over `-h`) since short names are really only designed for use when a user is running a command interactively, and long names are more readable when viewing a script with fresh eyes.

# Communication Style

- Be concise and action-oriented. Lead with the recommended path, then a short rationale.
- Use collaborative directness in tone (`we should`, `recommended`) instead of rigid or absolute phrasing.
- For bug work, include reproducible steps, expected result, actual result, and a concrete error example when available.

# Task Tracking (Linear)

When a session begins what looks like a real task (bug fix, feature, refactor, config change — anything that will produce actual work product), propose tracking it in Linear before starting the work:

1. **Ask first.** Confirm with me that this session warrants a Linear issue before searching for or creating one. Never create an issue unprompted. If I decline, skip Linear for the rest of the task.
2. **Search.** Once confirmed, look for an existing relevant issue (search by keywords from the task; also check open issues assigned to me). Also search the repo's open GitHub PRs (`gh pr list`, `gh search prs`) for in-flight or overlapping work, and call out anything that conflicts before starting.
3. **Create if missing.** If nothing relevant exists, create an issue in the **Anything** team with a concise title and a description noting it tracks this opencode session, plus the repo/worktree it concerns.
4. **Claim it.** Assign the issue to me and move it to In Progress (or the team's equivalent started state).

Rules of thumb:

- Skip this entirely (don't even ask) for quick questions, explanations, code reading, or trivial one-off commands — only sessions producing real work need an issue.
- Personal config, dotfiles, and tooling tweaks (including changes to these rules) usually don't warrant an issue. Lean toward not asking for that kind of work.
- One issue per session is the norm. If the session pivots to an unrelated task, repeat the check for the new task.
- If Linear tools are unavailable, say so and continue without blocking the work.

# Coding Preferences

- Preserve existing API behavior unless a change is explicitly requested; call out compatibility breaks before making them.
- Favor concrete fixes over speculative abstractions. Add indirection only when it solves a real repeated problem.
- Keep naming explicit and boring. Prioritize clarity over cleverness.
- If an upstream implementation already solves the same problem, align with it rather than inventing a new variant.

## Comments

- Default to **no comments**. Clear naming, small functions, and obvious control flow are preferred over inline narration.
- **Comments should explain _why_, not _what_.** The code already shows what is happening; a good comment captures the reason it has to be that way when that reason is not obvious from reading the code. If you find yourself writing a comment that paraphrases the next line, delete it and improve the naming instead.
- Do not add comments that restate what the code does, label sections of a function (`// setup`, `// main loop`), summarize a diff, narrate the change being made (`// now using X instead of Y`), or describe what a function does when its name already does that.
- Comments are warranted only when the code cannot explain itself, and even then they should focus on the _why_:
  - Non-obvious workarounds — explain the underlying reason (bug, API quirk, ordering constraint) with a link or issue reference when possible.
  - Subtle invariants or gotchas a careful reader would still miss — explain why the invariant must hold, not just that it does.
  - `TODO`/`FIXME` markers that include enough context to be actionable (who/what/why, not just "fix this").
- When editing a file, also remove nearby low-value comments (restating-the-code, stale section headers, "now does X" narration) that fall within the area being changed. Leave comments outside the edited area alone.

# Scope Discipline

Default to the smallest cohesive change that fully solves the stated task and could merge as a single PR. Optimize for easy review and easy rollback.

- **One mergeable unit per session.** Before coding, identify the minimal slice that delivers the request end-to-end. Build exactly that, then stop.
- **Minimal does not mean partial.** The slice must stand on its own: it builds, tests pass, and it leaves no half-migrated state, dead code, or unwired flags.
- **If the request needs multiple slices, propose the split before starting.** Recommend which slice to build first and confirm scope; don't silently build the rest.
- **If scope grows mid-task, stop and re-confirm** instead of quietly growing the diff.
- **No drive-by changes.** Don't fix adjacent bugs, refactor neighboring code, rename for taste, or bump dependencies unless the task requires it.
- **Discovered work becomes follow-ups, not scope.** Collect out-of-scope findings and list them at the end of the session; offer to file Linear issues for anything worth tracking.
- **A pre-existing bug that genuinely blocks the task gets the smallest viable fix,** called out explicitly so it can be reviewed or split out on its own.
- Litmus test: if the diff can't be described in one sentence, it's probably more than one change.

# Implementation Checklist

- Confirm API and integration compatibility end-to-end (inputs, outputs, naming/casing, enums, nullability).
- Keep the diff to the agreed slice; route out-of-scope findings to follow-ups (see Scope Discipline).
- For bug fixes, add or update a regression test when practical.
- Validate changes with project-local scripts before finishing.

# Review Heuristics

- Prioritize correctness and compatibility risks over style-only nits.
- When raising a concern, propose one concrete alternative.
- Reference upstream behavior when it is relevant and available.
- Call out whether feedback is blocking or follow-up.

# Git

## Worktree Layout

Most of my projects are laid out as a parent directory containing a bare repo in `.git/` with worktrees as sibling directories alongside it. Concretely, something like:

```
my-project/
├── .git/          # bare repo (shared)
├── main/          # worktree for main
├── feature-a/     # worktree
└── feature-b/     # worktree
```

The important consequence: **all worktrees share a single stash, reflog, and index lock.** That means parallel opencode instances working in different worktrees of the same project can step on each other if they all use `git stash` / `git stash pop` blindly — one instance can pop another instance's stash and silently corrupt that worktree's state.

## Stash Rules

- **Never use anonymous `git stash` / `git stash pop`** in these projects. The unnamed stash is shared across all worktrees and is unsafe under parallel agents.
- **Always use named stashes** via `git stash push --message "<descriptive-name>"`, and pop them by their stash ref (e.g. `git stash pop stash@{0}` only after confirming via `git stash list` that the top entry is yours, or better, by matching on the message).
- Prefer scoping the stash name with the worktree/branch so it's obvious whose it is, e.g. `git stash push --message "wt:feature-a:wip-refactor"`.
- Before popping, run `git stash list` and grep for your message to find the right ref instead of assuming `stash@{0}`.
- If you can avoid stashing entirely (e.g. by committing a WIP commit on the branch and resetting later), prefer that — it's worktree-local and immune to this class of bug.

# Available Tools

You have access to a number of command line tools that you can call such as:

- `ast-grep`
- `ripgrep`
  - You should almost always use this instead of `grep`
- `fastmod`

## Commands
You should generally prefer running commands based on local scripts, such as shell script files or npm scripts. That way you'll get the specific version installed for a given project. You almost always should do this instead of calling `npx`.

## Github

You have github access via the github CLI (`gh`). Most of the time, if you get a github url, it's probably in a private repo and you should use the CLI instead of trying to fetch a github url directly.

When creating a PR, always assign me unless told otherwise: `gh pr create --assignee jpulec`.

## AWS

The AWS CLI (`aws`) is available, but it has no default credentials. You **must** pass `--profile <name>` on every invocation, otherwise the call will fail with a credentials error. If you don't know which profile to use, ask before running the command rather than guessing.

# Chezmoi Conventions

Personal config is managed by [chezmoi](https://chezmoi.io) across two source repos:

- `~/.local/share/chezmoi` (jpulec/dotfiles) — portable shell/editor/CLI config.
  `chezmoi apply` must succeed on any platform; fish must start cleanly over
  SSH, on macOS, etc. Files may reference graphical tools (`hyprctl`,
  `notify-send`) inside lazy-loaded functions, but loading must never error.

- `~/.local/share/griever` (jpulec/griever) — Arch + Hyprland bootstrap.
  Assumes specific packages installed. Touched rarely after machine setup.

When adding new templated values, prefer **`.chezmoidata.toml`** at the
dotfiles source root for defaults (loaded before templates render — no need
for `| default "..."` clutter). Personal overrides go in
`~/.config/chezmoi/chezmoi.toml`'s `[data]` block.

For SSH, **`github.com` routes to the work key via 1Password agent**. Personal
GitHub access uses `git@github-personal:jpulec/...` (alias defined in
`~/.ssh/config`, key at `~/.ssh/id_github_personal`).

The starship prompt shows `!cz` on the right when either chezmoi source has
uncommitted changes. The `chezdiff` fish abbreviation shows the drift.

# Typescript Rules

## Rules

- Don't use `any`. It should almost never be necessary.
- Don't add typecasts. If you're type casting, you're probably doing something wrong.
- Don't run `tsc`. Prefer just running the `typescript` npm script in a project or just `tsgo`

## Logging

When using the logger, if you wish to log some sort of error, you should use the key `err`, i.e.

```typescript
try {
  await operationThatMightFail();
} catch (error) {
  logger.error(
    {
      err: error,
    },
    "Something went wrong",
  );
}
```

## Testing

- When writing tests, don't ever try mocking or asserting against any sort of logging. Logging should be considered a side effect of any system.
- Don't mock the ORM, since that's where a lot of important behavior gets tested.
- When using jest, assume that the `clearMocks` option has been set to true.

## Packages

- Don't be too afraid to use a package. Especially for very common behavior like transforms and string manipulation you might find in a package like `es-toolkit` or `lodash`
