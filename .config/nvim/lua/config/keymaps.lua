-- Non-plugin keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear search highlighting
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Better indenting in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Quick save
keymap("n", "<leader>w", ":w<CR>", opts)

-- Quick quit
keymap("n", "<leader>q", ":q<CR>", opts)

-- Toggle background (vim-unimpaired style)
keymap("n", "<leader>cob", function()
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end, { noremap = true, silent = true, desc = "Toggle background light/dark" })

-- Copy file path with line numbers (for referencing in other tools)
vim.keymap.set("v", "<leader>fp", ":<C-u>lua _G.copy_file_path_with_lines()<CR>", { silent = true, desc = "Copy file path with line numbers" })

_G.copy_file_path_with_lines = function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local filepath = vim.fn.expand("%")

  local output
  if start_line == end_line then
    output = filepath .. ":" .. start_line
  else
    output = filepath .. ":" .. start_line .. "-" .. end_line
  end

  vim.fn.setreg("+", output)
  vim.notify(output)
end
