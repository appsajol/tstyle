#!/data/data/com.termux/files/usr/bin/bash
# TStyle installer for Termux

set -e

SRC="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
T="$HOME/.tstyle"

G=$'\033[32m'; Y=$'\033[33m'; R=$'\033[31m'; N=$'\033[0m'
info() { echo "${G}[+]${N} $*"; }
warn() { echo "${Y}[!]${N} $*"; }
die()  { echo "${R}[x]${N} $*"; exit 1; }

# Insert (or refresh) the TStyle block in a shell rc file
inject() {
  local file="$1" line="$2"
  touch "$file"
  sed -i '/# >>> tstyle >>>/,/# <<< tstyle <<</d' "$file"
  printf '# >>> tstyle >>>\n%s\n# <<< tstyle <<<\n' "$line" >> "$file"
}

clone_plugin() {
  local name="$1" url="$2"
  if [ -d "$T/plugins/$name/.git" ]; then
    git -C "$T/plugins/$name" pull -q || warn "Could not update $name"
  else
    git clone -q --depth 1 "$url" "$T/plugins/$name" || warn "Could not clone $name"
  fi
}

# --- Checks -----------------------------------------------------------------
[ -d /data/data/com.termux ] || [ -n "$TERMUX_VERSION" ] || die "This installer is for Termux only."
[ -f "$SRC/bin/tstyle" ] || die "Run install.sh from inside the tstyle folder."

echo "${G}"
echo "  ╔══════════════════════════╗"
echo "  ║   TStyle  Installer      ║"
echo "  ╚══════════════════════════╝${N}"

# --- Packages ---------------------------------------------------------------
info "Installing packages..."
pkg update -y
pkg install -y zsh git figlet ruby ncurses-utils

info "Installing lolcat (rainbow colors)..."
gem install lolcat >/dev/null 2>&1 || warn "lolcat install failed. Rainbow header will fall back to a single color."

# --- Files ------------------------------------------------------------------
info "Copying files..."
mkdir -p "$T/plugins" "$T/themes" "$T/backup"

cp "$SRC/core/header.sh"  "$T/header.sh"
cp "$SRC/core/init.zsh"   "$T/init.zsh"
cp "$SRC/themes/"*.zsh    "$T/themes/"
cp "$SRC/core/config.default" "$T/config.default"
[ -f "$T/config" ] || cp "$SRC/core/config.default" "$T/config"

cp "$SRC/bin/tstyle" "$PREFIX/bin/tstyle"
chmod +x "$PREFIX/bin/tstyle"

# --- Backups (only the first time, so the original is never lost) ------------
for f in .zshrc .bashrc; do
  if [ -f "$HOME/$f" ] && [ ! -f "$T/backup/$f.orig" ]; then
    cp "$HOME/$f" "$T/backup/$f.orig"
    info "Backed up ~/$f"
  fi
done

# --- Plugins ----------------------------------------------------------------
info "Installing zsh plugins..."
clone_plugin zsh-autosuggestions      https://github.com/zsh-users/zsh-autosuggestions
clone_plugin zsh-syntax-highlighting  https://github.com/zsh-users/zsh-syntax-highlighting
clone_plugin zsh-completions          https://github.com/zsh-users/zsh-completions

# --- Shell hooks ------------------------------------------------------------
info "Updating shell config..."
inject "$HOME/.zshrc"  '[ -f "$HOME/.tstyle/init.zsh" ] && source "$HOME/.tstyle/init.zsh"'
inject "$HOME/.bashrc" '[ -f "$HOME/.tstyle/header.sh" ] && . "$HOME/.tstyle/header.sh"'

# Hide the default Termux welcome text so only our header shows
if [ ! -e "$HOME/.hushlogin" ]; then
  touch "$HOME/.hushlogin"
  touch "$T/.created_hushlogin"
fi

# --- Default shell ----------------------------------------------------------
if [ "$(basename "${SHELL:-}")" != "zsh" ]; then
  chsh -s zsh || warn "Could not change default shell. Run: chsh -s zsh"
fi

echo
info "Done! Restart Termux (or run: exec zsh), then type: ${G}tstyle${N}"
