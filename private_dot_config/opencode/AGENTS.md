# Fish Rules

- Prefer writing abbreviations over aliases, as they basically have the same effect, except that they make more sense in the shell history, or if I ever have other people read my commands as I'm typing them.
- When writing things like fish or bash scripts, you should generally prefer long names, i.e. (`--help` over `-h`) since short names are really only designed for use when a user is running a command interactively, and long names are more readable when viewing a script with fresh eyes.

# Communication Style

- Be concise and action-oriented. Lead with the recommended path, then a short rationale.
- Use collaborative directness in tone (`we should`, `recommended`) instead of rigid or absolute phrasing.
- For bug work, include reproducible steps, expected result, actual result, and a concrete error example when available.

# Coding Preferences

- Preserve existing API behavior unless a change is explicitly requested; call out compatibility breaks before making them.
- Favor concrete fixes over speculative abstractions. Add indirection only when it solves a real repeated problem.
- Keep naming explicit and boring. Prioritize clarity over cleverness.
- If an upstream implementation already solves the same problem, align with it rather than inventing a new variant.

# Implementation Checklist

- Confirm API and integration compatibility end-to-end (inputs, outputs, naming/casing, enums, nullability).
- Keep the diff minimal and avoid unrelated refactors unless explicitly requested.
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

## AWS

The AWS CLI (`aws`) is available, but it has no default credentials. You **must** pass `--profile <name>` on every invocation, otherwise the call will fail with a credentials error. If you don't know which profile to use, ask before running the command rather than guessing.

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
