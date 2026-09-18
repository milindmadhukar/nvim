# My Neovim Configuration

![image](https://github.com/milindmadhukar/nvim/assets/68477234/869d0b59-c87a-492d-859a-0eeae783bf14)
![image](https://github.com/milindmadhukar/nvim/assets/68477234/5525596f-c872-4da0-a550-a48da6a69556)

<a href="https://dotfyle.com/milindmadhukar/nvim"><img src="https://dotfyle.com/milindmadhukar/nvim/badges/plugins?style=flat" /></a>

Built on [NvChad](https://github.com/NvChad/NvChad) v2.5, plugins managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

## Install Neovim

**Requires Neovim 0.11 or newer** — the LSP setup uses `vim.lsp.config()` / `vim.lsp.enable()`, which do not exist in older versions.

You can install Neovim with your package manager (`pacman -S neovim`, `brew install neovim`, `apt install neovim`, ...), but remember that when you update your packages Neovim may be upgraded to a newer version — and on Debian/Ubuntu the packaged version is usually too old for this config.

I have included a script to install Neovim from a release or by building from source:

```sh
bash <(curl -s https://raw.githubusercontent.com/milindmadhukar/nvim/main/install_neovim)
```

(make sure to read the script before running it.)

It asks whether you want a prebuilt release (`latest` or `nightly`) or a source build, picks the right archive for your OS and CPU (`linux`/`macos` × `x86_64`/`arm64`), and verifies the download against the checksum GitHub publishes for the asset.

| Environment variable | Effect |
| --- | --- |
| `NEOVIM_INSTALL_PREFIX` | Where the release is installed. Default `~/.local`, so the binary lands at `~/.local/bin/nvim` — make sure that is on your `PATH`. |
| `NEOVIM_SKIP_CHECKSUM=1` | Install even if the checksum could not be fetched (e.g. GitHub API rate limit). |

If a directory inside the prefix is a symlink — a `stow`-managed `~/.local/share/applications`, say — the installer writes *through* it instead of replacing it, and tells you where the files actually went.

Building from source keeps the checkout in `~/.config/nvim/neovim` and needs the toolchain:

```sh
sudo pacman -S base-devel cmake unzip ninja curl git   # Arch
sudo apt install build-essential cmake gettext ninja-build unzip curl git   # Ubuntu
```

## Install the Config

Make sure to remove or move your current `nvim` directory

```sh
git clone https://github.com/milindmadhukar/nvim.git ~/.config/nvim
```

Run `nvim` and wait for the plugins to be installed

**NOTE** (You will notice treesitter pulling in a bunch of parsers the next time you open Neovim)

**NOTE** Checkout this file for some predefined keymaps: [mappings](https://github.com/milindmadhukar/nvim/blob/main/lua/core/mappings.lua)

## Get healthy

Open `nvim` and enter the following:

```
:checkhealth
```

You'll probably notice you don't have support for copy/paste also that python and node haven't been setup

So let's fix that

First we'll fix copy/paste

- On mac `pbcopy` should be builtin

- On Arch

  ```sh
  sudo pacman -S xsel          # for X11
  sudo pacman -S wl-clipboard  # for wayland
  ```

- On Ubuntu

  ```sh
  sudo apt install xsel          # for X11
  sudo apt install wl-clipboard  # for wayland
  ```

Next we need to install python support (node is optional, but several Mason tools such as `prettier` need it)

- Neovim python support

  ```sh
  sudo pacman -S python-pynvim   # Arch — pip refuses to touch the system env (PEP 668)
  pip install pynvim             # elsewhere, or inside a virtualenv
  ```

- Neovim node support

  ```sh
  npm i -g neovim
  ```

We will also need `ripgrep` for Telescope to work:

- Ripgrep

  ```sh
  sudo pacman -S ripgrep   # Arch
  sudo apt install ripgrep # Ubuntu
  ```

Other external tools this config reaches for:

| Tool | Used by | Arch | Ubuntu |
| --- | --- | --- | --- |
| `lazygit` | `<leader>gg` floating terminal | `sudo pacman -S lazygit` | see [lazygit install](https://github.com/jesseduffield/lazygit#installation) |
| `latexmk`, `zathura` | vimtex (only loads when `latexmk` exists) | `sudo pacman -S texlive-binextra biber zathura zathura-pdf-mupdf` | `sudo apt install latexmk biber zathura` |
| C compiler, `git` | treesitter parsers, Mason | `sudo pacman -S base-devel` | `sudo apt install build-essential` |

---

**NOTE** make sure you have [node](https://nodejs.org/en/) installed, I recommend a node manager like [fnm](https://github.com/Schniz/fnm).

## Fonts

Install the icon Fonts

```bash
mkdir -p ~/.fonts && cp fonts/* ~/.fonts && fc-cache -fv
```

I recommend using the following repo to get a "Nerd Font" (Font that supports icons)

[getnf](https://github.com/ronniedroid/getnf)

On Arch they are also packaged, e.g. `sudo pacman -S ttf-jetbrains-mono-nerd`.

## Configuration

### LSP

To add a new LSP

First Enter:

```
Mason
```

and press `i` on the Language Server you wish to install

or

Add the server name to [`lua/plugins/lsp/servers.lua`](https://github.com/milindmadhukar/nvim/blob/main/lua/plugins/lsp/servers.lua) — it drives both `mason-lspconfig`'s `ensure_installed` and `vim.lsp.enable()`. Per-server overrides go in [`lua/plugins/lsp/settings/`](https://github.com/milindmadhukar/nvim/tree/main/lua/plugins/lsp/settings).

### Formatters and linters

Formatting is handled by [conform.nvim](https://github.com/stevearc/conform.nvim). Add the filetype to `formatters_by_ft` in [`lua/plugins/lsp/configs/conform.lua`](https://github.com/milindmadhukar/nvim/blob/main/lua/plugins/lsp/configs/conform.lua), and add the formatter's Mason package to the `tools` list in [`lua/plugins/lsp/configs/mason.lua`](https://github.com/milindmadhukar/nvim/blob/main/lua/plugins/lsp/configs/mason.lua) so it gets installed — the two lists have to stay in sync.
