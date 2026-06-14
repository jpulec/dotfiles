import type { Plugin } from "@opencode-ai/plugin"

const TITLE = "OpenCode"
const EXPIRE_MS = 5000
const DEBOUNCE_MS = 1000

const MESSAGES = {
  permission: "needs permission",
  complete: "has finished",
  error: "encountered an error",
} as const

type Kind = keyof typeof MESSAGES

export const WorkspaceNotifier: Plugin = async ({ $, directory, worktree }) => {
  const lastSent: Record<string, number> = {}

  const resolveWorkspace = async (): Promise<string | undefined> => {
    const root = (worktree ?? directory ?? "").replace(/\/+$/, "")
    const base = root.split("/").filter(Boolean).pop()
    if (!base) return undefined
    // wt-workspace names a workspace "<prefix><worktree>", so the worktree
    // basename is the name when the prefix is empty. When hyprctl is reachable,
    // recover a non-empty prefix by matching the live workspace list.
    try {
      const raw = await $`hyprctl workspaces -j`.quiet().text()
      const names: string[] = JSON.parse(raw).map((w: { name: string }) => w.name)
      if (names.includes(base)) return base
      const prefixed = names.find((n) => n !== base && n.endsWith(base))
      if (prefixed) return prefixed
    } catch {}
    return base
  }

  // foot with `[bell] urgent=yes` raises XDG-activation urgency on BEL when the
  // window is unfocused; writing to /dev/tty targets this session's foot window
  // without disturbing the TUI. Hyprland clears urgency once the window is focused.
  const ringBell = async () => {
    const bel = "\x07"
    await $`printf %s ${bel} > /dev/tty`.quiet().nothrow()
  }

  const notify = async (kind: Kind) => {
    const now = Date.now()
    if (lastSent[kind] && now - lastSent[kind] < DEBOUNCE_MS) return
    lastSent[kind] = now

    const workspace = await resolveWorkspace()
    const summary = workspace ? `${TITLE} · ${workspace}` : TITLE
    const urgency = kind === "error" ? "critical" : "normal"

    await Promise.allSettled([
      $`notify-send --app-name=${TITLE} --urgency=${urgency} --expire-time ${EXPIRE_MS} ${summary} ${MESSAGES[kind]}`
        .quiet()
        .nothrow(),
      ringBell(),
    ])
  }

  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") await notify("complete")
      else if (event.type === "session.error") await notify("error")
      else if (event.type === "permission.asked") await notify("permission")
    },
  }
}
