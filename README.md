# zsh.yazi

A [yazi](https://github.com/sxyazi/yazi) plugin to use shell aliases and zsh plugins in the shell input box.
Based on [this](https://github.com/sxyazi/yazi/issues/1206#issuecomment-2188759899) script with some tweaks of mine.
For now only works with [Bash](https://www.gnu.org/software/bash/), [Zsh](https://www.zsh.org/) and other shell that works like them.

# Installation
## Install plugin
```
ya pack -a 'claymorwan/shell'
```
## Setup keymaps
Add this to your `keymaps.toml` file:
```
prepend_keymap = [
	# Shell plugin
	{ on = [ ":" ], run = "plugin shell block" },
  { on = [ ";" ], run = "plugin shell noblock" },
]
```

# Usage
Works like the usual shel block command: 
- press `;` for shell commands
- press `:` for shell commands (as block)

## Skipping stuff in your shell config file
If you have stuff that runs when loading your shell (like a neofetch for example) you probably don't want it to run when using this plugin.
You can put these commands in a condition with the `YAZI_SHELL_SKIP_CMD` variable like so:
```
if [[ "$YAZI_SHELL_SKIP_CMD" != true ]]; then
  # Place commands here, for example:
  fastfetch
fi
```
