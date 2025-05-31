# lutris.yazi

A [yazi](https://github.com/sxyazi/yazi) plugin to easily make [Lutris](https://lutris.net/) install script for games and install them

## Installation
### Install plugin
```bash
ya pkg add claymorwan/yazi-plugins:lutris
```
### Setup keymaps
Add this keymap to your `keymaps.toml` file:
```toml
prepend_keymap = [
  # Lutris
 	{ on = ["L", "m"], run = "plugin lutris make", desc = "Makes an install script"},
	{ on = ["L", "i"], run = "plugin lutris install", desc = "Install a Lutris install script" },
	{ on = ["L", "a"], run = "plugin lutris add", desc = "Makes and installs script" },

]
```
## Usage
1. To make the install file, press L then m (or whatever you set it up for)
2. Enter the game's name
> If the game is a windows game (aka if it has the .exe file extension), you'll have to enter if the path to the wine prefix you will be using it in
3. Install by pressing L then i (will delete your install file)

>[!NOTE]
> You can make and install automatically by pressing L then a
