--- Define el estilo 'tree' como predeterminado para el explorador
vim.cmd("let g:netrw_liststyle = 3")

--- Map leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--- Left numbers
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 2             -- Ancho de la columna de numeros.
vim.o.conceallevel = 2            -- Oculta parcialmente ciertos caracteres en los archivos.
vim.opt.fillchars = { eob = " " } -- Remueve los ~ de la columna.

--- Tabs
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

--- Set theme
vim.cmd([[colorscheme kanagawa]])

--- Set spell
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text" },
	callback = function()
		vim.opt_local.spelllang = "es_es"
		vim.opt_local.spell = true
	end,
})

--- Comando para verificar el intérprete de Python que usa Neotest
vim.api.nvim_create_user_command("NeotestPythonInfo", function()
	local cwd = vim.fn.getcwd()
	local info_lines = { "🐍 Información del intérprete de Python para Neotest:", "" }
	
	-- Buscar .nvim-python
	local nvim_python = cwd .. "/.nvim-python"
	if vim.fn.filereadable(nvim_python) == 1 then
		local path = vim.fn.readfile(nvim_python)[1]
		table.insert(info_lines, "✓ Archivo .nvim-python encontrado:")
		table.insert(info_lines, "  " .. path)
		if vim.fn.executable(path) == 1 then
			local version = vim.fn.system(path .. " --version")
			table.insert(info_lines, "  " .. vim.trim(version))
		else
			table.insert(info_lines, "  ⚠️  No ejecutable o no existe")
		end
	else
		table.insert(info_lines, "✗ No se encontró .nvim-python")
	end
	
	table.insert(info_lines, "")
	
	-- Buscar .python-version
	local python_version_file = cwd .. "/.python-version"
	if vim.fn.filereadable(python_version_file) == 1 then
		local version = vim.fn.readfile(python_version_file)[1]
		table.insert(info_lines, "✓ Archivo .python-version encontrado: " .. version)
	else
		table.insert(info_lines, "✗ No se encontró .python-version")
	end
	
	table.insert(info_lines, "")
	
	-- Buscar entornos virtuales
	local venvs = {
		{ path = ".venv/bin/python", name = ".venv" },
		{ path = "venv/bin/python", name = "venv" },
		{ path = "env/bin/python", name = "env" },
	}
	
	local found_venv = false
	for _, venv in ipairs(venvs) do
		local full_path = cwd .. "/" .. venv.path
		if vim.fn.executable(full_path) == 1 then
			table.insert(info_lines, "✓ Entorno virtual encontrado: " .. venv.name)
			local version = vim.fn.system(full_path .. " --version")
			table.insert(info_lines, "  " .. vim.trim(version))
			found_venv = true
		end
	end
	
	if not found_venv then
		table.insert(info_lines, "✗ No se encontró entorno virtual (.venv, venv, env)")
	end
	
	table.insert(info_lines, "")
	table.insert(info_lines, "Python del sistema:")
	if vim.fn.executable("python3") == 1 then
		local version = vim.fn.system("python3 --version")
		table.insert(info_lines, "  " .. vim.trim(version))
		local which = vim.fn.system("which python3")
		table.insert(info_lines, "  " .. vim.trim(which))
	end
	
	-- Mostrar en un buffer flotante
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, info_lines)
	
	local width = 70
	local height = #info_lines + 2
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		col = (vim.o.columns - width) / 2,
		row = (vim.o.lines - height) / 2,
		style = "minimal",
		border = "rounded",
	}
	
	vim.api.nvim_open_win(buf, true, opts)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.keymap.set("n", "q", ":close<CR>", { buffer = buf, silent = true })
	vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = buf, silent = true })
end, {})


