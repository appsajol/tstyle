# TStyle zsh init - sourced from ~/.zshrc
_T="$HOME/.tstyle"
[ -f "$_T/config" ] && source "$_T/config"

# Header
[ -f "$_T/header.sh" ] && source "$_T/header.sh"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# Completion
[ -d "$_T/plugins/zsh-completions/src" ] && fpath=("$_T/plugins/zsh-completions/src" $fpath)
autoload -Uz compinit && compinit -u
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Prompt theme
[ -f "$_T/themes/${THEME:-default}.zsh" ] && source "$_T/themes/${THEME:-default}.zsh"

# Command suggestion (grey text from history)
if [ "${SUGGEST:-1}" = "1" ] && [ -f "$_T/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
  source "$_T/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Syntax highlighting (must be loaded last)
if [ "${HIGHLIGHT:-1}" = "1" ] && [ -f "$_T/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$_T/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

unset _T
