# My Neovim Configuration

![image](https://github.com/milindmadhukar/nvim/assets/68477234/869d0b59-c87a-492d-859a-0eeae783bf14)
![image](https://github.com/milindmadhukar/nvim/assets/68477234/5525596f-c872-4da0-a550-a48da6a69556)

## Install Neovim 0.9

You can install Neovim with your package manager e.g. brew, apt, pacman etc.. but remember that when you update your packages Neovim may be upgraded to a newer version.

I have included scripts to install neovim from release or building from source

## Install the config

Make sure to remove or move your current `nvim` directory

```sh
git clone https://github.com/milindmadhukar/nvim.git ~/.config/nvim
```

Run `nvim` and wait for the plugins to be installed

**NOTE** (You will notice treesitter pulling in a bunch of parsers the next time you open Neovim)

**NOTE** Checkout this file for some predefined keymaps: [keymaps](https://github.com/milindmadhukar/nvim/blob/master/lua/user/keymaps.lua)

## Get healthy

Open `nvim` and enter the following:

```
:checkhealth
```

You'll probably notice you don't have support for copy/paste also that python and node haven't been setup

So let's fix that

First we'll fix copy/paste

- On mac `pbcopy` should be builtin

- On Ubuntu

  ```sh
  sudo apt install xsel # for X11
  sudo apt install wl-clipboard # for wayland
  ```

Next we need to install python support (node is optional)

- Neovim python support

  ```sh
  pip install pynvim
  ```

- Neovim node support

  ```sh
  npm i -g neovim
  ```

We will also need `ripgrep` for Telescope to work:

- Ripgrep

  ```sh
  sudo apt install ripgrep
  ```

---

**NOTE** make sure you have [node](https://nodejs.org/en/) installed, I recommend a node manager like [fnm](https://github.com/Schniz/fnm).

## Fonts

Install the icon Fonts
```bash
mkdir -p ~/.fonts && cp fonts/* ~/.fonts && fc-cache -fv
```

I recommend using the following repo to get a "Nerd Font" (Font that supports icons)

[getnf](https://github.com/ronniedroid/getnf)

## Configuration

### LSP

To add a new LSP

First Enter:

```
Mason
```

and press `i` on the Language Server you wish to install

or

Add the server name to the `servers` in the mason config file: [mason](https://github.com/milindmadhukar/nvim/blob/master/lua/user/lsp/mason.lua)

### Formatters and linters

Make sure the formatter or linter is installed and add it to this setup function: [null-ls](https://github.com/milindmadhukar/nvim/blob/master/lua/user/lsp/null-ls.lua)
