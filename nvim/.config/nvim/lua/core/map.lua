local map = vim.keymap.set

--- Move one line ---
map({ "n", "i" }, "<A-k>", "<cmd>m -2<CR>")
map({ "n", "i" }, "<A-j>", "<cmd>m +1<CR>")

--- Move many lines ---
map("v", "<A-k>", ":m '<-2<CR>gv=gv")
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("n", "<leader>e", ":Neotree filesystem reveal right <CR>")

--- Clear search
map({ "n", "v" }, "<leader>h", ":nohlsearch<CR>")

--- Copy text
map({ 'n', 'v' }, '<leader>y', '"+y', { desc = "Copy" })

--- Buffer Actions
map('n', '<leader>bx', ":bdelete<CR>", { desc = "Buffer: Delete" })
map('n', '<leader>bp', ":bprevious<CR>", { desc = "Buffer: Previous" })

--- Speell
map('n', '<leader>sc', "z=1<Enter><CR>", { desc = "Correct spell" })

--- Window Navigation
map('n', '<C-h>', '<C-w>h', { desc = "Move to left window" })
map('n', '<C-j>', '<C-w>j', { desc = "Move to window below" })
map('n', '<C-k>', '<C-w>k', { desc = "Move to window above" })
map('n', '<C-l>', '<C-w>l', { desc = "Move to right window" })
