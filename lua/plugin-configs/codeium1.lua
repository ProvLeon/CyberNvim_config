-- plugin-configs/codeium.lua

local windline = require("windline")

local codeium = {}

-- Function to get Codeium status
local function getCodeiumStatus()
	local codeium_status = vim.fn.mode() == "n"
			and (vim.api.nvim_call_function("codeium#GetStatusString", {}) ~= "0" and "ON" or "OFF")
		or vim.api.nvim_call_function("codeium#GetStatusString", {})
	return "Codeium: " .. codeium_status
end

-- Configure the Codeium component for Windline
codeium.setup = function()
	windline.setup({
		statuslines = {
			{
				sections = {
					lualine_a = { "mode" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = { getCodeiumStatus }, -- Add Codeium component to right side
					lualine_y = {},
					lualine_z = { "location" },
				},
			},
		},
	})
end

return codeium
