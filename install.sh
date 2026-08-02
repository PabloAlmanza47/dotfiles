#!/usr/bin/env bash
# Dotfiles installer for Linux/WSL. Symlinks configs into place and wires up
# the managed Bash sourcing block. Safe to re-run; existing real files are
# backed up before being replaced.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
BACKUP_ROOT="$HOME/.dotfiles-backup"
BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
backup_dir_made=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run] [--help]

Symlinks this repository's configs into place:
  nvim/                    -> ~/.config/nvim
  tmux/tmux.conf           -> ~/.tmux.conf
  starship/starship.toml   -> ~/.config/starship.toml
  bash/bashrc-additions    -> ~/.config/pablo-dotfiles/bashrc-additions

Also adds a managed block to ~/.bashrc that sources bashrc-additions
(only if that block isn't already present).

Options:
  --dry-run   Print planned operations without changing anything.
  --help      Show this help message.

Any existing real file or directory at a destination is moved into
~/.dotfiles-backup/<timestamp>/ before being replaced. Symlinks that
already point at the right place are left alone. No packages are
installed and sudo is never used.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --help) usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; usage; exit 1 ;;
  esac
done

log() { echo "==> $*"; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

ensure_backup_dir() {
  [ "$backup_dir_made" -eq 1 ] && return
  run mkdir -p "$BACKUP_ROOT"
  run mkdir "$BACKUP_DIR"
  backup_dir_made=1
}

# link SRC DEST: symlink SRC (absolute, inside the repo) to DEST (absolute,
# under $HOME), backing up whatever currently occupies DEST if it isn't
# already the correct symlink.
link() {
  local src="$1" dest="$2" dest_parent
  dest_parent="$(dirname "$dest")"

  if [ ! -d "$dest_parent" ]; then
    log "Creating directory $dest_parent"
    run mkdir -p "$dest_parent"
  fi

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then
      log "Already linked: $dest"
      return
    fi
    log "Backing up existing symlink: $dest"
    ensure_backup_dir
    run mv "$dest" "$BACKUP_DIR/"
  elif [ -e "$dest" ]; then
    log "Backing up existing file/directory: $dest"
    ensure_backup_dir
    run mv "$dest" "$BACKUP_DIR/"
  fi

  log "Linking $dest -> $src"
  run ln -s "$src" "$dest"
}

add_bashrc_block() {
  local bashrc="$HOME/.bashrc"
  local marker="# >>> pablo-dotfiles >>>"

  if [ -f "$bashrc" ] && grep -qF "$marker" "$bashrc"; then
    log "Managed Bash block already present in $bashrc"
    return
  fi

  log "Adding managed Bash block to $bashrc"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] append managed pablo-dotfiles block to $bashrc"
    return
  fi

  {
    echo ""
    echo "$marker"
    echo 'if [ -f "$HOME/.config/pablo-dotfiles/bashrc-additions" ]; then'
    echo '    . "$HOME/.config/pablo-dotfiles/bashrc-additions"'
    echo 'fi'
    echo "# <<< pablo-dotfiles <<<"
  } >> "$bashrc"
}

log "Dotfiles repository: $REPO_DIR"
[ "$DRY_RUN" -eq 1 ] && log "Dry run: no changes will be made"

link "$REPO_DIR/nvim" "$HOME/.config/nvim"
link "$REPO_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
link "$REPO_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link "$REPO_DIR/bash/bashrc-additions" "$HOME/.config/pablo-dotfiles/bashrc-additions"

add_bashrc_block

if [ "$backup_dir_made" -eq 1 ] && [ "$DRY_RUN" -eq 0 ]; then
  log "Backed up replaced files to: $BACKUP_DIR"
fi

log "Done."
log "Open a new shell, or run: source ~/.bashrc"
