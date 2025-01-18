return {
	"blazkowolf/gruber-darker.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		bold = false,
		italic = {
			strings = false,
			comments = false,
			operators = false,
			folds = false,
		},
	},
	config = function()
		vim.cmd.colorscheme("gruber-darker")

		vim.api.nvim_set_hl(0, "String", { fg = "#73c936", italic = false })
		vim.api.nvim_set_hl(0, "Character", { fg = "#73c936", italic = false })
		vim.api.nvim_set_hl(0, "Comment", { fg = "#cc8c3c", italic = false })
	end,
}
