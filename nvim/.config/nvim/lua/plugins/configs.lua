--- Mason & Lsp
local mason = function()
	require("mason").setup()
end

local mason_lspconfig = function()
	-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
	require("mason-lspconfig").setup({
		ensure_installed = { "lua_ls", "prettier", "pyright", "stylua", "ruff" },
		automatic_enable = true,
	})
end

local nvim_cmp = function()
	local cmp = require("cmp")
	require("luasnip.loaders.from_vscode").lazy_load()

	cmp.setup({
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "buffer" },
		}),
	})
end

--- Neo Tree
local neotree = function()
	require("neo-tree").setup({
		filesystem = {
			filtered_items = {
				hide_dotfiles = false,
			},
		},
	})
end

--- Debugger

local nvim_dap = function()
	require("mason-nvim-dap").setup({
		ensure_installed = { "python" },
		automatic_installation = true,
		handlers = {},
	})
	require("dapui").setup()
end
--- Linter & Formatter

local none_ls = function()
	local null_ls = require("null-ls")
	null_ls.setup({
		sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.prettier,
		},
	})
end

local conform = function()
	local conform = require("conform")

	conform.setup({
		formatters_by_ft = {
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			svelte = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			-- markdown = { "prettier" },
			graphql = { "prettier" },
			liquid = { "prettier" },
			lua = { "stylua" },
			python = { "ruff" },
			astro = { "prettier" },
		},
		format_on_save = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		},
	})

	vim.keymap.set({ "n", "v" }, "<leader>mp", function()
		conform.format({
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		})
	end, { desc = "Format file or range (in visual mode)" })
end

--- Treesitter
local treesitter = function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"json",
			"python",
			"javascript",
			"typescript",
			"yaml",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"bash",
			"lua",
			"vim",
		},

		highlight = {
			enable = true,
			use_languagetree = true,
			disbled = { "latex" },
		},

		indent = { enable = true },

		auto_install = true,
	})
end

--- Telescope
local telescope_ui_select = function()
	require("telescope").setup({
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown({}),
			},
		},
	})
	require("telescope").load_extension("ui-select")
end

local lualine = function()
	require("lualine").setup()
end

local ibl = function()
	require("ibl").setup({
		indent = {
			char = "▏", -- This is a slightly thinner char than the default one, check :help ibl.config.indent.char
		},
		scope = {
			show_start = false,
			show_end = false,
		},
	})
	-- disable indentation on the first level
	-- local hooks = require("ibl.hooks")
	-- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
	-- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
end

local gits = function()
	require("gitsigns").setup({
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Git: Siguiente cambio (hunk)" })

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Git: Cambio anterior (hunk)" })

			-- Actions
			map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Git: Agregar hunk" })
			map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Git: Revertir hunk" })

			map("v", "<leader>gs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git: Agregar hunk seleccionado" })

			map("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git: Revertir hunk seleccionado" })

			map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Git: Agregar todo el buffer" })
			map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Git: Revertir todo el buffer" })

			map("n", "<leader>gh", gitsigns.preview_hunk, { desc = "Git: Previsualizar hunk" })
			map("n", "<leader>gi", gitsigns.preview_hunk_inline, { desc = "Git: Previsualizar hunk en línea" })

			map("n", "<leader>gb", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "Git: Blame en línea" })

			map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git: Diff con HEAD" })

			map("n", "<leader>gD", function()
				gitsigns.diffthis("~")
			end, { desc = "Git: Diff con último commit" })

			map("n", "<leader>gQ", function()
				gitsigns.setqflist("all")
			end, { desc = "Git: Enviar todos los hunks al quickfix" })

			map("n", "<leader>gq", gitsigns.setqflist, { desc = "Git: Enviar hunks actuales al quickfix" })

			-- Toggles
			map("n", "<leader>gbb", gitsigns.toggle_current_line_blame, { desc = "Git: Alternar blame línea actual" })
			map("n", "<leader>gww", gitsigns.toggle_word_diff, { desc = "Git: Alternar diff por palabra" })

			-- Text object
			map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Git: Seleccionar hunk" })
		end,
	})
end

--- ToggleTerm
local toggleterm = function()
	require("toggleterm").setup({
		size = 20,
		open_mapping = [[<c-\>]],
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = true,
		shading_factor = 2,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "float",
		close_on_exit = true,
		shell = vim.o.shell,
		float_opts = {
			border = "curved",
			winblend = 0,
			highlights = {
				border = "Normal",
				background = "Normal",
			},
		},
	})
end

--- Neotest
local neotest = function()
	-- Función simple para encontrar el intérprete de Python
	local function get_python_path()
		local cwd = vim.fn.getcwd()

		-- 1. Buscar archivo .nvim-python en el proyecto
		local nvim_python_file = cwd .. "/.nvim-python"
		if vim.fn.filereadable(nvim_python_file) == 1 then
			local python_path = vim.fn.readfile(nvim_python_file)[1]
			if python_path and vim.fn.executable(python_path) == 1 then
				return python_path
			end
		end

		-- 2. Buscar entorno virtual en el proyecto
		local venv_paths = {
			cwd .. "/.venv/bin/python",
			cwd .. "/venv/bin/python",
			cwd .. "/env/bin/python",
		}

		for _, path in ipairs(venv_paths) do
			if vim.fn.executable(path) == 1 then
				return path
			end
		end

		-- 3. Fallback a python3 del sistema
		if vim.fn.executable("python3") == 1 then
			return "python3"
		end

		return "python"
	end

	require("neotest").setup({
		adapters = {
			require("neotest-python")({
				-- Configuración específica para Python
				dap = { justMyCode = false },
				args = { "-v" },
				runner = "unittest",
				python = get_python_path,
			}),
			require("neotest-jest")({
				jestCommand = "npm test --",
				jestConfigFile = "custom.jest.config.ts",
				env = { CI = true },
				cwd = function(path)
					return vim.fn.getcwd()
				end,
			}),
			require("neotest-go"),
		},
		-- Configuración general
		quickfix = {
			enabled = true,
			open = false,
		},
		status = {
			enabled = true,
			virtual_text = true,
			signs = true,
		},
		output = {
			enabled = true,
			open_on_run = "short",
		},
		run = {
			enabled = true,
		},
		summary = {
			enabled = true,
			animated = true,
			follow = true,
			expand_errors = true,
		},
		icons = {
			running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
		},
	})
end

return {
	mason = mason,
	mason_lspconfig = mason_lspconfig,
	nvim_cmp = nvim_cmp,
	nvim_dap = nvim_dap,
	none_ls = none_ls,
	treesitter = treesitter,
	telescope_ui_select = telescope_ui_select,
	lualine = lualine,
	neotree = neotree,
	conform = conform,
	ibl = ibl,
	gits = gits,
	toggleterm = toggleterm,
	neotest = neotest,
}
