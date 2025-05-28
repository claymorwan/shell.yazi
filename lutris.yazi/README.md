# lutris.yazi

A [yazi](https://github.com/sxyazi/yazi) plugin to easily make lutris install script for games
>[!NOTE]
> Doesn't support auto install yet, as i haven't managed to make it work

## Installation
### Install plugin
```bash
ya pack -a claymorwan/yazi-plugins:lutris
```
### Setup keymaps
Add this keymap to your `keymaps.toml` file:
```toml
prepend_keymap = [
  # Lutris
  { on = ["L", "m"], run = "plugin lutris", desc = "Make lutris install file from hovered file" },
]
```
## Usage
1. To make the install file, press L then m (or whatever you set it up for)
2. Enter the game's name
> If the game is a windows game (aka if it has the .exe file extension), you'll have to enter if the path to the wine prefix you will be using it in
3. Install the game, either by running `lutris -i <your install file>.yml` or install directly directly in the app.
