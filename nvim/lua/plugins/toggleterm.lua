return {
	"akinsho/toggleterm.nvim",
	opts = function()
		return {
			on_open = function()
				vim.cmd("startinsert!")
			end,
			direction = "float",
			float_opts = {
				border = "curved",
				winblend = 5,
				width = math.floor(vim.api.nvim_win_get_width(0)),
				height = math.floor(vim.api.nvim_win_get_height(0)) - 1,
			},
		}
	end,
	init = function()
		local c = require("dracula").colors()
		local darkBg = "#15161C"
		local Terminal = require("toggleterm.terminal").Terminal

		local terminal_one = Terminal:new({
			highlights = {
				NormalFloat = { guibg = darkBg },
				FloatBorder = { guifg = c.green, guibg = darkBg },
			},
		})
		local terminal_two = Terminal:new({
			highlights = {
				NormalFloat = { guibg = darkBg },
				FloatBorder = { guifg = c.red, guibg = darkBg },
			},
		})

		function Toggle_terminal_one()
			terminal_one:toggle()
		end
		function Toggle_terminal_two()
			terminal_two:toggle()
		end

		vim.keymap.set({ "n", "t" }, "<C-t>", "<cmd>lua Toggle_terminal_one()<CR>", {
			desc = "Terminal one",
		})
		vim.keymap.set({ "n", "t" }, "<C-y>", "<cmd>lua Toggle_terminal_two()<CR>", {
			desc = "Terminal two",
		})
	end,
}
