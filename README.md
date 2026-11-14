# TStyle

A small customization tool for Termux. Change your startup header, get command suggestions, syntax highlighting, better completion and prompt themes, all from one menu.

## Features

- **Custom header**: your own text, 14 figlet fonts, rainbow or solid colors
- **Command suggestion**: grey inline suggestions from your history (`zsh-autosuggestions`)
- **Syntax highlighting**: valid commands turn green, mistakes turn red (`zsh-syntax-highlighting`)
- **Extra completion**: more tab completions (`zsh-completions`)
- **Prompt themes**: `default`, `minimal`, `hacker`, `cyber`
- **Safe**: backs up your `.zshrc` and `.bashrc` once, and the uninstaller can restore them

## Install

```bash
pkg install git -y
git clone https://github.com/appsajol/tstyle.git
cd tstyle
bash install.sh
```

Then restart Termux (or run `exec zsh`).

## Usage

```bash
tstyle            # open the menu
tstyle preview    # show the current header
```

Menu overview:

| Option | What it does |
|--------|--------------|
| Header settings | Change text, font, color, show or hide the header |
| Command suggestion | Turn history suggestions on or off |
| Syntax highlighting | Turn highlighting on or off |
| Prompt theme | Pick a zsh prompt style |
| Reset to defaults | Restore the default settings |

Settings live in `~/.tstyle/config`. Plugin and prompt changes apply to new sessions.

## Uninstall

```bash
cd tstyle
bash uninstall.sh
```

It removes the `tstyle` command, `~/.tstyle`, and the lines added to your rc files. It can also restore your original `.zshrc` / `.bashrc`, switch your shell back to bash, and remove figlet, lolcat and zsh.

## Project structure

```
tstyle/
├── install.sh
├── uninstall.sh
├── README.md
├── LICENSE
├── bin/
│   └── tstyle          # interactive menu (installed to $PREFIX/bin)
├── core/
│   ├── header.sh       # prints the header (bash and zsh)
│   ├── init.zsh        # loads header, completion, theme, plugins
│   └── config.default  # default settings
└── themes/
    └── *.zsh           # prompt themes
```

To add a theme, create `themes/mytheme.zsh` that sets `PROMPT=...`, then run `bash install.sh` again. It will show up in the menu.

## Troubleshooting

- **Header not showing**: run `tstyle`, open Header settings and make sure the header is ON.
- **No rainbow colors**: `gem install lolcat`
- **Suggestions or highlighting not working**: they need zsh. Check with `echo $SHELL`, and run `chsh -s zsh` if needed.
- **Old Termux welcome text still appears**: make sure `~/.hushlogin` exists.
- **Plugin clone failed**: check your internet, then run `bash install.sh` again.

## License

MIT
