# Setup

One config, two machines. Everything OS-specific branches on `vim.fn.has('win32')`,
so the same repo works on Windows and macOS with no edits.

Config location:
- Windows — `%LOCALAPPDATA%\nvim`  (`C:\Users\<you>\AppData\Local\nvim`)
- macOS/Linux — `~/.config/nvim`

## macOS, from scratch

```sh
# 1. Tools
brew install neovim ripgrep git
xcode-select --install                 # provides clangd + a C++ toolchain

# 2. Font (the icons need a Nerd Font)
brew install --cask font-iosevka-term-nerd-font

# 3. The config itself
git clone https://github.com/thehilmisu/nvim-fromscratch.git ~/.config/nvim

# 4. First launch — lazy.nvim installs every plugin at the versions in
#    lazy-lock.json, so both machines end up identical.
nvim
```

Then set the terminal font to **`IosevkaTerm Nerd Font Mono`**
(iTerm2: Settings → Profiles → Text → Font. Ghostty/WezTerm/Alacritty: in their config file.)

Check it worked: `:checkhealth`, then `:LspInfo` inside a C++ file.

## What differs per OS, and where

| Thing | Windows | macOS | Defined in |
|---|---|---|---|
| clangd binary | `C:\msys64\clang64\bin\clangd.exe` + `--query-driver` for MinGW/Qt | `clangd` from PATH | `lua/plugins/lsp.lua` |
| `Ctrl+b` terminal | `wt split-pane` | `open -a Terminal` | `lua/core/keymaps.lua` |
| `Ctrl+d` build | `build.bat` in a new console | `./build.sh`, else `cmake --build build`, in a split | `lua/core/keymaps.lua` |

Everything else — keymaps, plugins, colorscheme, git setup — is identical.

## Keeping the two in sync

```sh
git add -A && git commit -m "..." && git push     # on the machine you changed
git pull                                          # on the other one
nvim  # then :Lazy sync   if lazy-lock.json moved
```

`lazy-lock.json` pins exact plugin commits — commit it, or the machines drift.

## Notes

**Plugin version pins.** `mason.nvim`, `mason-lspconfig.nvim` and `nvim-lspconfig` are
pinned to their 1.x lines in `lua/plugins/lsp.lua`. 2.x needs `vim.lsp.enable()`, which
only exists in Neovim 0.11+; the Windows machine runs 0.10.3. The pins are also fine on
0.11+, so they can stay. Remove them only once every machine is on 0.11 or newer.

**Per-project clangd.** clangd finds its flags through a `compile_commands.json`. Generate
it with `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`, and if the build tree is not `build/`, point
at it from a `.clangd` file in the project root:

```yaml
CompileFlags:
  CompilationDatabase: build/Desktop_Qt_6_11_1_MinGW_64_bit_Debug
```

That file belongs to the project, not to this repo — each machine's build directory differs.

**treesitter** is present but commented out in `init.lua`. Enabling it needs a C compiler
on PATH to build the parsers.
