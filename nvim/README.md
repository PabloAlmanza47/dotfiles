# nvim config

Modular Neovim config, GitHub-Dark-styled, built for TS/JS/Angular, C#, Python,
Lua, C/C++, and web/markup/SQL work over WSL + Windows Terminal.

## Structure

```
init.lua                         leader keys, then requires the files below
lua/pablo/options.lua             editor options + 2-space filetype overrides
lua/pablo/keymaps.lua              global keymaps not owned by a plugin
lua/pablo/autocmds.lua             yank highlight, cursor restore, insert-mode relnumber
lua/pablo/lazy.lua                 lazy.nvim bootstrap + plugin import
lua/pablo/plugins/colorscheme.lua  github-nvim-theme + palette overrides
lua/pablo/plugins/editor.lua       nvim-tree, which-key
lua/pablo/plugins/telescope.lua    fuzzy finder + keymaps
lua/pablo/plugins/git.lua          gitsigns
lua/pablo/plugins/lsp.lua          mason, mason-lspconfig, nvim-lspconfig, LSP keymaps
lua/pablo/plugins/completion.lua   nvim-cmp, LuaSnip
lua/pablo/plugins/formatting.lua   conform.nvim
lua/pablo/plugins/statusline.lua   lualine
lua/pablo/plugins/treesitter.lua   nvim-treesitter (main branch)
```

Plugin-specific keymaps live next to their plugin (Telescope's in
`telescope.lua`, LSP's in `lsp.lua`, etc.) instead of one central file, using
lazy.nvim's own `keys` field / attach autocommands — there's no separate
keymap-registration layer to maintain.

## Shortcuts

**General** — `<Space>` leader, `\` local leader
| Key | Action |
|---|---|
| `<leader>w` | Save file |
| `<leader>q` | Close window |
| `<Esc>` | Clear search highlight |
| `<A-j>` / `<A-k>` (visual) | Move selected lines down/up |

**Explorer**
| Key | Action |
|---|---|
| `<leader>e` | Toggle project tree |
| `<leader>E` | Focus project tree |

**Find (Telescope)**
| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Find text in project |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help |
| `<leader>fc` | Find current word |

**LSP** (buffer-local, only active where a server attached)
| Key | Action |
|---|---|
| `gd` / `gD` | Go to definition / declaration |
| `gr` / `gi` | References / implementation |
| `K` | Hover docs |
| `<leader>rn` | Rename |
| `<leader>ca` | Code actions |
| `<leader>ds` | Document symbols |
| `[d` / `]d` | Prev/next diagnostic |
| `<leader>d` | Diagnostic float |

**Formatting**
| Key | Action |
|---|---|
| `<leader>f` | Format buffer (normal or visual selection) |

**Git (Gitsigns, buffer-local on attach)**
| Key | Action |
|---|---|
| `]c` / `[c` | Next/prev hunk (defers to native diff nav in diff mode) |
| `<leader>gp` | Preview hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gb` | Show line blame |

> Note: `<leader>f` is both a standalone "format" mapping and the prefix for
> `<leader>ff/fg/fb/...`. Vim's mapping resolution waits for `timeoutlen` to
> disambiguate, so pressing `<leader>f` alone formats after a short pause —
> this is inherent to having both, not a bug.

## Installing language servers

Servers are declared in `lua/pablo/plugins/lsp.lua` and auto-installed +
auto-enabled by mason-lspconfig on first launch. To manage manually: `:Mason`.

| Language | Server | Needs on this machine |
|---|---|---|
| Lua | `lua_ls` | — |
| Python | `basedpyright` | python3 (found) |
| TypeScript/JavaScript | `ts_ls` | node/npm (found) |
| Angular | `angularls` | node/npm (found) + project's own `@angular/language-service` |
| C/C++ | `clangd` | — (Mason ships its own binary) |
| C# | `csharp_ls` | **dotnet SDK — not found on this machine** |
| JSON | `jsonls` | node/npm (found) |
| HTML | `html` | node/npm (found) |
| CSS | `cssls` | node/npm (found) |

C# won't function until the .NET SDK is installed and `dotnet` is on PATH —
this is true of every current C# language server (csharp_ls, OmniSharp, or
Roslyn), so it isn't specific to this choice. Everything else starts working
immediately since Mason can fetch/manage those binaries itself. A missing
server never blocks Neovim from starting.

Formatter binaries (separate from LSP, used by `<leader>f` / format-on-save)
are also plain Mason packages:

```
:MasonInstall stylua prettier ruff clang-format csharpier
```

`csharpier` also needs `dotnet`.

## Updating plugins

- `:Lazy` — status/update UI (background update checks are off; run this manually).
- `:Lazy sync` — install/update/clean in one step.
- `:Mason` — update installed language servers/formatters.

## Restoring the previous configuration

A git checkpoint and an external backup were made before this rewrite.
`init.vim.backup` (the pre-Lua config) is also still present, untouched.

## Legacy `~/.config/nvim/lazy/` backup

The old vendored copy of lazy.nvim used to live at `~/.config/nvim/lazy/`.
lazy.nvim now bootstraps into the standard `stdpath("data")/lazy/` location
instead. `~/.config/nvim/lazy/` is **no longer referenced anywhere** but is
left in place as a legacy backup — safe to delete by hand once you've
confirmed the new setup works, not touched automatically by this config.

## Health checks

```
:Lazy           plugin status
:Mason          language server / formatter status
:checkhealth    overall Neovim + plugin health
:LspInfo        active LSP clients for the current buffer
:ConformInfo    formatter resolution for the current buffer
:Telescope      fuzzy finder
:NvimTreeToggle project tree
```

## Treesitter parsers need `tree-sitter-cli`

Confirmed by testing: nvim-treesitter's `main` branch requires the
`tree-sitter` CLI (v0.26.1+) to compile parsers, and upstream explicitly says
to install it **via a system package manager, not npm**. This machine has
`cc`/`tar`/`curl` (the other requirements) but not `tree-sitter-cli`, and
since installing it would mean either a system package (not allowed here) or
fetching a standalone binary on your behalf (not something this change should
do unprompted), parser compilation currently fails — caught safely, so
Neovim still starts and normal (non-treesitter) syntax highlighting still
works via Neovim's built-in defaults. To get treesitter's better highlighting:
install `tree-sitter-cli` yourself (e.g. a release binary from
https://github.com/tree-sitter/tree-sitter/releases onto your PATH, or
`cargo install tree-sitter-cli` if you have Rust), then run `:TSUpdate`.

One visible side effect until then: Neovim 0.12 itself (not this config)
ships built-in `ftplugin/{lua,help,query}.lua` files that call
`vim.treesitter.start()` unconditionally with no guard. Opening a `.lua`
file, a `:help` window, or a treesitter query file will print a (non-fatal)
`Parser could not be created` error until a real `lua`/`vimdoc`/`query`
parser exists — confirmed by comparing against `nvim -u NONE` (no crash,
because `-u NONE` also skips `filetype plugin on`, so those ftplugins never
load at all) versus a normal config (loads them, hits the unguarded call).
Every other filetype in this config (Python, TS/JS, C#, C/C++, JSON, CSS,
HTML, Markdown, bash, SQL) is unaffected — Neovim doesn't ship built-in
treesitter-calling ftplugins for those, and this config's own treesitter
autocmd is pcall-guarded. Installing `tree-sitter-cli` and running
`:TSUpdate` removes the error entirely.

## Known, deliberate gaps

- **Treesitter indentation**: left off — still marked experimental upstream.
- **SQL formatting**: no formatter configured (no reliable stdlib-adjacent
  default); `<leader>f` on a `.sql` file will just report "no formatter".
- **fzf-native / lspkind.nvim**: skipped — Telescope's built-in sorter and a
  dozen hand-written kind-icon lines cover the same need without adding a
  build step or an extra dependency.
- **roslyn.nvim**: skipped — Roslyn isn't in nvim-lspconfig itself, and it
  needs `dotnet` exactly like `csharp_ls` does, so the extra plugin buys
  nothing today.
- **Which-key groups**: the request named File/Find/Git/LSP/Workspace groups,
  but the concrete keymaps given only form two real multi-key prefixes
  (`<leader>f` → "Find", `<leader>g` → "Git") plus `<leader>d`/`<leader>ds`
  ("LSP"). There's no shared prefix for a "File" or "Workspace" group in the
  spec, so none was invented — every other leaf keymap still shows its own
  label via `desc`, which which-key picks up automatically.
