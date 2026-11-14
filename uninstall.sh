#!/data/data/com.termux/files/usr/bin/bash
# TStyle uninstaller for Termux

PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
T="$HOME/.tstyle"

G=$'\033[32m'; Y=$'\033[33m'; N=$'\033[0m'
info() { echo "${G}[+]${N} $*"; }
warn() { echo "${Y}[!]${N} $*"; }
ask()  { local a; read -r -p "$1 [y/N] " a; [[ "$a" =~ ^[Yy]$ ]]; }

echo "This will remove TStyle from Termux."
ask "Continue?" || { echo "Cancelled."; exit 0; }

# 1. Remove the TStyle block from rc files
for f in "$HOME/.zshrc" "$HOME/.bashrc"; do
  if [ -f "$f" ]; then
    sed -i '/# >>> tstyle >>>/,/# <<< tstyle <<</d' "$f"
    info "Cleaned $f"
  fi
done

# 2. Restore the original rc files?
if [ -d "$T/backup" ] && ls "$T/backup"/*.orig >/dev/null 2>&1; then
  if ask "Restore your original .zshrc / .bashrc from backup?"; then
    for f in .zshrc .bashrc; do
      [ -f "$T/backup/$f.orig" ] && cp "$T/backup/$f.orig" "$HOME/$f" && info "Restored ~/$f"
    done
  fi
fi

# 3. Bring back the default Termux welcome text (only if we created the file)
if [ -f "$T/.created_hushlogin" ]; then
  rm -f "$HOME/.hushlogin"
  info "Restored default Termux welcome message"
fi

# 4. Remove command and data
rm -f "$PREFIX/bin/tstyle"
rm -rf "$T"
info "Removed tstyle command and ~/.tstyle"

# 5. Optional extras
if ask "Switch default shell back to bash?"; then
  chsh -s bash && info "Default shell is now bash"
fi

if ask "Also uninstall figlet, lolcat and zsh?"; then
  gem uninstall lolcat -a -x >/dev/null 2>&1
  pkg uninstall -y figlet zsh
fi

echo
info "TStyle removed. Restart Termux to apply."
