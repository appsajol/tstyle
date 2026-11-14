# TStyle header - works in both bash and zsh
[ -f "$HOME/.tstyle/config" ] && . "$HOME/.tstyle/config"

if [ "${HEADER:-1}" = "1" ] && command -v figlet >/dev/null 2>&1; then
  _ts_out=$(figlet -f "${FONT:-standard}" "${TEXT:-Termux}" 2>/dev/null) \
    || _ts_out=$(figlet "${TEXT:-Termux}")

  case "${COLOR:-rainbow}" in
    red) _ts_c=31 ;;
    green) _ts_c=32 ;;
    yellow) _ts_c=33 ;;
    blue) _ts_c=34 ;;
    magenta) _ts_c=35 ;;
    cyan) _ts_c=36 ;;
    white) _ts_c=37 ;;
    *) _ts_c=0 ;;
  esac

  if [ "${COLOR:-rainbow}" = "rainbow" ] && command -v lolcat >/dev/null 2>&1; then
    printf '%s\n' "$_ts_out" | lolcat
  elif [ "$_ts_c" != "0" ]; then
    printf '\033[%sm%s\033[0m\n' "$_ts_c" "$_ts_out"
  else
    printf '\033[36m%s\033[0m\n' "$_ts_out"
  fi

  unset _ts_out _ts_c
fi
