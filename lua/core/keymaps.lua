vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opts = { noremap = true, silent = true }

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Allow moving the cursor through wrapped lines with j, k
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- clear highlights
vim.keymap.set("n", "<Esc>", ":noh<CR>", opts)

-- save file
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", opts)

-- save file without auto-formatting
vim.keymap.set("n", "<leader>W", "<cmd>noautocmd w <CR>", opts)

-- quit file
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Vertical scroll and center. <C-d> is the Helix build binding below, so only
-- <C-u> keeps its scroll behaviour; <C-f> takes over scrolling down.
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "<C-f>", "<C-d>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--------------------------------------------------------------------------
-- Helix parity: the [keys.normal] / [keys.select] block from config.toml
--------------------------------------------------------------------------

-- helix: "C-up"/"C-down" = move the current line (or selection) up/down
vim.keymap.set("n", "<C-Up>", ":m .-2<CR>==", opts)
vim.keymap.set("n", "<C-Down>", ":m .+1<CR>==", opts)
vim.keymap.set("i", "<C-Up>", "<Esc>:m .-2<CR>==gi", opts)
vim.keymap.set("i", "<C-Down>", "<Esc>:m .+1<CR>==gi", opts)
-- helix [keys.select]: same, keeping the selection afterwards
vim.keymap.set("v", "<C-Up>", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "<C-Down>", ":m '>+1<CR>gv=gv", opts)

local is_win = vim.fn.has("win32") == 1
local is_mac = vim.fn.has("mac") == 1

-- helix: "C-b" = :sh wt -w 0 split-pane -d .
vim.keymap.set("n", "<C-b>", function()
  local cwd = vim.fn.getcwd()
  if is_win then
    vim.fn.jobstart({ "wt", "-w", "0", "split-pane", "-d", cwd }, { detach = true })
  elseif is_mac then
    vim.fn.jobstart({ "open", "-a", "Terminal", cwd }, { detach = true })
  else
    vim.cmd("botright split | terminal")
  end
end, { noremap = true, silent = true, desc = "Split a terminal pane here" })

-- helix: "C-/" = search_selection then global_search
local function global_search_selection()
  local ok, builtin = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("telescope is not available", vim.log.levels.WARN)
    return
  end
  builtin.grep_string({ search = vim.fn.expand("<cword>") })
end

local function global_search_visual()
  local ok, builtin = pcall(require, "telescope.builtin")
  if not ok then
    return
  end
  -- Yank the visual selection to a scratch register and search for it.
  local saved = vim.fn.getreg("z")
  vim.cmd('noautocmd normal! "zy')
  local text = vim.fn.getreg("z")
  vim.fn.setreg("z", saved)
  builtin.grep_string({ search = text })
end

-- Terminals send <C-_> for Ctrl+/, so both are bound.
for _, lhs in ipairs({ "<C-/>", "<C-_>" }) do
  vim.keymap.set("n", lhs, global_search_selection, { noremap = true, silent = true, desc = "Global search word" })
  vim.keymap.set("v", lhs, global_search_visual, { noremap = true, silent = true, desc = "Global search selection" })
end

-- helix: "C-d" = :sh start cmd /k build.bat
vim.keymap.set("n", "<C-d>", function()
  vim.cmd("silent! wall")
  local cwd = vim.fn.getcwd()
  if is_win then
    vim.fn.jobstart({ "cmd.exe", "/c", "start", "cmd", "/k", "build.bat" },
      { detach = true, cwd = cwd })
  else
    local script = vim.fn.filereadable(cwd .. "/build.sh") == 1 and "./build.sh" or "cmake --build build"
    vim.cmd("botright 15split | terminal " .. script)
  end
end, { noremap = true, silent = true, desc = "Build project" })

-- helix: "S-tab" = :buffer-next
vim.keymap.set("n", "<S-Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<Tab>", ":bprevious<CR>", opts)

--------------------------------------------------------------------------

-- File tree. Helix has no equivalent; <C-b> is the terminal split there, so
-- the tree moves to <leader>e.
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", opts)

vim.keymap.set("n", "<leader>x", ":Bdelete!<CR>", opts)   -- close buffer
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

-- Increment/decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", opts) -- increment
vim.keymap.set("n", "<leader>-", "<C-x>", opts) -- decrement

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts)      -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts)      -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts)     -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts)   -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts)     --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts)     --  go to previous tab

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Replace word under cursor
vim.keymap.set("n", "<leader>j", "*``cgn", opts)

-- Explicitly yank to system clipboard (highlighted and entire row)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Toggle diagnostics
local diagnostics_active = true

vim.keymap.set("n", "<leader>do", function()
  diagnostics_active = not diagnostics_active
  vim.diagnostic.enable(diagnostics_active)
end, { desc = "Toggle diagnostics" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Save and load session
vim.keymap.set("n", "<leader>Ss", ":mksession! .session.vim<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>Sl", ":source .session.vim<CR>", { noremap = true, silent = false })
