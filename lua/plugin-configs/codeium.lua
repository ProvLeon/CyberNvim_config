-- plugin-configs/codeium.lua

local windline = require("windline")
local helper = require("windline.helpers")

local codeium = {}

-- Function to get Codeium status
local function getCodeiumStatus()
	if vim.fn.mode() == "n" then
		local codeium_enabled = vim.api.nvim_call_function("codeium#GetStatusString", {}) ~= "0"
		return "Codeium: " .. (codeium_enabled and "ON" or "OFF")
	else
		local codeium_status = vim.api.nvim_call_function("codeium#GetStatusString", {})
		if codeium_status == "3/8" then
			return "Codeium: 3/8" -- Third suggestion out of 8
		elseif codeium_status == "0" then
			return "Codeium: No suggestions" -- Codeium returned no suggestions
		elseif codeium_status == "*" then
			return "Codeium: Waiting for response" -- Waiting for Codeium response
		else
			return "Codeium: Unknown status" -- Unknown status
		end
	end
end

-- Configure the Codeium component in Windline
codeium.setup = function()
	windline.setup({
		statuslines = {
			{
				sections = {
					lualine_a = { "mode" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = { { getCodeiumStatus, "CodeiumStatus" } }, -- Add Codeium component to right side
					lualine_y = {},
					lualine_z = { "location" },
				},
			},
		},
		colors_name = function(colors)
			colors["CodeiumStatus"] = "#ff8800"
		end,
	})
end

return codeium
