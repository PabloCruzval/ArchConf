local map = vim.keymap.set

--- Telescope

map({ "n", "v" }, "<leader>tf", "<cmd> Telescope find_files <CR>", { desc = "Telescope: Open Files" })
map({ "n", "v" }, "<leader>tc", "<cmd> Telescope commands <CR>", { desc = "Telescope: Open Commands" })
map({ "n", "v" }, "<leader>tr", "<cmd> Telescope oldfiles <CR>", { desc = "Telescope: Open Oldfiles" })
map({ "n", "v" }, "<leader>tb", "<cmd> Telescope buffers <CR>", { desc = "Telescope: Open Buffers" })
map({ "n", "v" }, "<leader>tt", "<cmd> Telescope live_grep <CR>", { desc = "Telescope: Find Text" })

--- LSP
map("n", "<leader>lh", vim.lsp.buf.hover, { desc = "LSP: Hover" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "LSP: Diagnostic" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP: Rename" })

--- Debugger
map("n", "<leader>do", '<cmd>lua require("dapui").open()<CR>', {})
map("n", "<leader>dx", '<cmd>lua require("dapui").close()<CR>')
map("n", "<leader>dt", '<cmd>lua require("dap").toggle_breakpoint()<CR>', { desc = "Dap: Toogle Breakpoint" })
map("n", "<leader>dc", '<cmd>lua require("dap").continue()<CR>', { desc = "Dap: Continue" })

--- MarkDown

--- Formatting
map("n", "<leader>lf", function()
	vim.cmd("lua vim.lsp.buf.format()")
	vim.cmd("w")
end, { desc = "LSP: Format" })

--- Comment
map("n", "<leader>/", '<cmd>lua require("Comment.api").toggle.linewise.current() <CR>', { desc = "Toggle Comment" })
map(
	"v",
	"<leader>/",
	'<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
	{ desc = "Toggle Comment" }
)

--- nvim-surround
map("n", "<leader>s(", "ysiw(", { noremap = false, desc = "Surround: Inner Word" })

--- ToggleTerm
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "ToggleTerm: Float" })
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "ToggleTerm: Horizontal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<CR>", { desc = "ToggleTerm: Vertical" })

-- Mapeos en modo terminal para salir más fácilmente
map("t", "<esc>", [[<C-\><C-n>]], { desc = "ToggleTerm: Exit terminal mode" })
map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "ToggleTerm: Move left" })
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "ToggleTerm: Move down" })
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "ToggleTerm: Move up" })
map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "ToggleTerm: Move right" })

--- Neotest
map("n", "<leader>ntn", '<cmd>lua require("neotest").run.run()<CR>', { desc = "Neotest: Run Nearest Test" })
map("n", "<leader>ntf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { desc = "Neotest: Run File" })
map("n", "<leader>ntd", '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>', { desc = "Neotest: Debug Nearest Test" })
map("n", "<leader>nts", '<cmd>lua require("neotest").run.stop()<CR>', { desc = "Neotest: Stop Test" })
map("n", "<leader>nta", '<cmd>lua require("neotest").run.attach()<CR>', { desc = "Neotest: Attach to Test" })
map("n", "<leader>nto", '<cmd>lua require("neotest").output.open({ enter = true })<CR>', { desc = "Neotest: Show Output" })
map("n", "<leader>ntO", '<cmd>lua require("neotest").output_panel.toggle()<CR>', { desc = "Neotest: Toggle Output Panel" })
map("n", "<leader>ntS", '<cmd>lua require("neotest").summary.toggle()<CR>', { desc = "Neotest: Toggle Summary" })
map("n", "<leader>ntl", '<cmd>lua require("neotest").run.run_last()<CR>', { desc = "Neotest: Run Last Test" })
map("n", "<leader>ntL", '<cmd>lua require("neotest").run.run_last({strategy = "dap"})<CR>', { desc = "Neotest: Debug Last Test" })

