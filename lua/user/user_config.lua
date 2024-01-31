-- use a user-config.lua file to provide your own configuration
local vim = vim
local M = {}

-- add any null-ls sources you want here
M.setup_sources = function(b)
	return {
		b.formatting.clang_format,
		b.completion.luasnip,
		b.completion.tags,
		b.formatting.stylua,
		b.formatting.autopep8,
		b.formatting.beautysh,
		b.formatting.cbfmt,
		b.formatting.gofumpt,
		b.formatting.jq,
		b.formatting.cmake_format,
		b.formatting.prettierd.with({
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"html",
				"css",
			},
		}),
		b.diagnostics.checkmake,
		b.diagnostics.clang_check,
		b.diagnostics.cmake_lint,
		-- b.diagnostics.pylint,
		b.diagnostics.revive,
		-- b.diagnostics.xo,
		b.code_actions.cspell,
		-- b.code_actions.xo,
		b.code_actions.gitrebase,
		b.code_actions.gitsigns,
		b.code_actions.gomodifytags,
		b.code_actions.proselint,
		b.code_actions.refactoring,
		b.hover.dictionary,
	}
end

-- add null_ls sources to auto-install
M.ensure_installed = {}

M.formatting_servers = {
	["rust_analyzer"] = { "rust" },
	["null-ls"] = {
		"lua",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"html",
		"css",
		"json",
		"python",
		"sh",
		"bash",
		"zsh",
		"go",
		"cpp",
		"c",
		"cmake",
		"make",
	},
}

M.enable_plugins = {
	autosave = false,
}

M.options = {
	opt = {
		swapfile = false,
	},
}

M.plugins = {
	"simrat39/rust-tools.nvim",
	"mfussenegger/nvim-dap-python",
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		dependencies = {
			"zbirenbaum/copilot-cmp",
			config = function()
				require("copilot_cmp").setup()
			end,
		},
		config = function()
			require("user.plugin-configs.copilot")
		end,
	},
	{
		"aurum77/live-server.nvim",
		run = function()
			require("live_server.util").setup()
		end,
		cmd = { "LiveServer", "LiveServerStart", "LiveServerStop" },
	},
	{
		"xiyaowong/transparent.nvim",
		opts = function(_, opts)
			opts.ensure_installed = require("transparent").setup({ -- Optional, you don't have to run setup.
				transparent = vim.g.transparent_enabled,
				groups = { -- table: default groups
					"Normal",
					"NormalNC",
					"Comment",
					"Constant",
					"Special",
					"Identifier",
					"Statement",
					"PreProc",
					"Type",
					"Underlined",
					"Todo",
					"String",
					"Function",
					"Conditional",
					"Repeat",
					"Operator",
					"Structure",
					"LineNr",
					"NonText",
					"SignColumn",
					"CursorLine",
					"CursorLineNr",
					"StatusLine",
					"StatusLineNC",
					"EndOfBuffer",
				},
				extra_groups = {
					"BufferLineTabClose",
					"BufferlineBufferSelected",
					"BufferLineFill",
					"BufferLineBackground",
					"BufferLineSeparator",
					"BufferLineIndicatorSelected",

					"IndentBlanklineChar",

					-- make floating windows transparent
					"LspFloatWinNormal",
					"Normal",
					"NormalFloat",
					"FloatBorder",
					"TelescopeNormal",
					"TelescopeBorder",
					"TelescopePromptBorder",
					"SagaBorder",
					"SagaNormal",
				}, -- table: additional groups that should be cleared
				exclude_groups = {}, -- table: groups you don't want to clear
			})
		end,
	},
	{
		"0x00-ketsu/autosave.nvim",
		opts = function(_, opts)
			opts.ensure_installed = require("autosave").setup({
				--'0x00-ketsu/autosave.nvim',
				-- lazy-loading on events
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer, to the configuration section below

				event = { "InsertLeave", "TextChanged" },
			})
		end,
	},
	{
		"Exafunction/codeium.vim",
		event = "BufEnter",
		config = function()
			local windline = require("windline")
			-- Call function to get Codeium status
			local function getCodeiumStatus()
				local codeium_status = vim.fn["codeium#GetStatusString"]()
				return "Codeium: " .. codeium_status
			end

			-- Setup Windline statusline
			local statusline = {
				sections = {
					lualine_a = { "mode" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = { getCodeiumStatus() }, -- Add Codeium component to right side
					lualine_y = {},
					lualine_z = { "location" },
				},
			}

			windline.setup({ statuslines = { statusline } })
			--windline.setup_default_mappings()
			--windline.reload()

			vim.api.nvim_call_function("codeium#GetStatusString", {})
			vim.keymap.set("i", "<C-Tab>", function()
				return vim.fn["codeium#Accept"]()
			end, {})
			vim.keymap.set("i", "<c-;>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<c-,>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true, silent = true })
			-- vim.keymap.set()
		end,
	},
}

M.user_conf = function()
	require("user.init")
	vim.g.rust_recommended_style = false
end

M.mappings = require("user.mappings")

return M
