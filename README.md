# Pablo's Dotfiles

Personal configuration for Neovim, tmux, Starship, and Bash, tuned for a
WSL + Windows Terminal workflow with a consistent GitHub-Dark-inspired
palette across every tool. A single installer symlinks everything into
place and leaves anything it replaces safely backed up.

## Components

- **Neovim** (`nvim/`) — modular Lua config (lazy.nvim-managed) built for
  TS/JS/Angular, C#, Python, Lua, C/C++, and web/markup/SQL work. See
  [`nvim/README.md`](nvim/README.md) for the full plugin list and setup
  notes.
- **tmux** (`tmux/tmux.conf`) — mouse support, vi-style copy mode, intuitive
  pane splitting/navigation, and a themed status bar.
- **Starship** (`starship/starship.toml`) — a compact two-line prompt
  showing directory, git branch/status, language versions, and command
  duration.
- **Bash additions** (`bash/bashrc-additions`) — PATH setup for
  `~/.local/bin`, optional NVM loading, and Starship initialization, all
  guarded so they no-op cleanly on machines without those tools installed.
- **Windows Terminal theme** (`windows-terminal/`) — a matching color
  scheme, installed manually (see below).

## Repository layout

```
.
├── install.sh
├── bash/
│   └── bashrc-additions
├── nvim/
│   ├── init.lua
│   ├── lazy-lock.json
│   ├── README.md
│   └── lua/pablo/
│       ├── autocmds.lua
│       ├── keymaps.lua
│       ├── lazy.lua
│       ├── options.lua
│       └── plugins/
│           ├── colorscheme.lua
│           ├── completion.lua
│           ├── editor.lua
│           ├── formatting.lua
│           ├── git.lua
│           ├── lsp.lua
│           ├── statusline.lua
│           ├── telescope.lua
│           └── treesitter.lua
├── starship/
│   └── starship.toml
├── tmux/
│   └── tmux.conf
└── windows-terminal/
    ├── pablo-workspace.json
    └── README.md
```

## Requirements

- Linux or WSL (Ubuntu, etc.) with Bash.
- Not supported on macOS.
- Neovim, tmux, and Starship are **not installed automatically** — install
  them yourself first through your distro's package manager (or however
  you prefer). `install.sh` only links configuration files; it never
  installs packages and never invokes `sudo`.

## Installation

```sh
git clone https://github.com/PabloAlmanza47/dotfiles.git dotfiles
cd dotfiles
./install.sh --dry-run   # preview what would happen
./install.sh             # apply it
```

`install.sh` creates these symlinks:

| Source | Destination |
|---|---|
| `nvim/` | `~/.config/nvim` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `bash/bashrc-additions` | `~/.config/pablo-dotfiles/bashrc-additions` |

### Automatic backups

Before replacing any existing **real** file or directory at one of the
destinations above, the installer moves it into
`~/.dotfiles-backup/<timestamp>/` (one fresh timestamped folder per run —
previous backups are never overwritten). If a destination is already the
correct symlink, it's left untouched; if it's a symlink pointing somewhere
else (or broken), that symlink itself is backed up before being replaced.

### The managed Bash block

The installer appends this block to `~/.bashrc` (only if it isn't already
there — running `install.sh` again won't duplicate it):

```sh
# >>> pablo-dotfiles >>>
if [ -f "$HOME/.config/pablo-dotfiles/bashrc-additions" ]; then
    . "$HOME/.config/pablo-dotfiles/bashrc-additions"
fi
# <<< pablo-dotfiles <<<
```

`~/.bashrc` itself is otherwise left completely alone.

### Windows Terminal (manual)

Windows Terminal configuration is **not** touched by `install.sh`. Follow
[`windows-terminal/README.md`](windows-terminal/README.md) to import the
color scheme by hand.

### After installing

Open a new shell, or run:

```sh
source ~/.bashrc
```

### Restoring from backup

Every replaced file/directory lives under `~/.dotfiles-backup/<timestamp>/`,
named the same as it was at its destination. To restore one, move it back,
e.g.:

```sh
mv ~/.dotfiles-backup/<timestamp>/nvim ~/.config/nvim
```

## Neovim shortcuts

Leader is `<Space>`. Full details, including LSP/formatter setup, live in
[`nvim/README.md`](nvim/README.md).

| Key | Action |
|---|---|
| `<leader>w` | Save file |
| `<leader>q` | Close window |
| `<leader>e` / `<leader>E` | Toggle / focus project tree |
| `<leader>ff` / `<leader>fg` / `<leader>fb` | Find files / text / buffers |
| `gd` / `gr` / `K` | Go to definition / references / hover docs |
| `<leader>rn` / `<leader>ca` | Rename / code actions |
| `<leader>f` | Format buffer |
| `<leader>gp` / `<leader>gs` / `<leader>gb` | Git hunk preview / stage / blame |

## tmux shortcuts

Prefix is the tmux default (`Ctrl+b`).

| Key | Action |
|---|---|
| `\|` / `-` | Split pane vertically / horizontally (same directory) |
| `h` / `j` / `k` / `l` | Move between panes |
| `H` / `J` / `K` / `L` (repeatable) | Resize pane |
| `r` | Reload `~/.tmux.conf` |
| Mouse | Click/drag to select panes, resize, and switch windows |

## Starship behavior

Two-line prompt showing the current directory, git branch/status, Python
and Node.js versions when relevant, and command duration for anything
taking longer than 2 seconds. Colors follow the same palette used by tmux
and Windows Terminal. Starship only activates in `bashrc-additions` if the
`starship` binary is found on `PATH`, so an unmodified shell isn't affected
if it isn't installed.

## Updating

```sh
git pull
./install.sh
```

Re-running `install.sh` is safe: symlinks that already point to the right
place are left alone, and the managed Bash block is never duplicated.

## Uninstallation

To remove this setup without touching your backups:

```sh
rm ~/.config/nvim ~/.tmux.conf ~/.config/starship.toml
rm -r ~/.config/pablo-dotfiles
```

Then remove the block between (and including) the `# >>> pablo-dotfiles >>>`
and `# <<< pablo-dotfiles <<<` markers from `~/.bashrc`.

This only removes the symlinks and the managed block — anything under
`~/.dotfiles-backup/` is left in place.

## Security and privacy notes

This repository intentionally excludes:

- `.claude/` and other local Claude Code settings.
- Secrets, credentials, and `.env` files.
- Neovim's downloaded plugins and generated state (`nvim/lazy/`,
  `nvim/.cache/`, `nvim/.local/`, `.nvimlog`) — these are fetched fresh by
  lazy.nvim on first launch, not vendored here.
- Editor temporary/swap files and OS metadata (`.DS_Store`, `Thumbs.db`).

See [`.gitignore`](.gitignore) for the full list. Nothing in this repo
requires or stores machine-specific paths, tokens, or personal data.

## License

Licensed under the [MIT License](LICENSE).
