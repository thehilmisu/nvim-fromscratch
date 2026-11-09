return {
	{
		"blazkowolf/gruber-darker.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			italic = { strings = false, comments = false, operators = false, folds = false },
		},
		config = function(_, opts)
			require("gruber-darker").setup(opts)
			vim.cmd.colorscheme("gruber-darker")

			-- gruber-darker clears every @lsp.* group; clangd reports inactive
			-- preprocessor regions (#if ... false) as "comment" semantic tokens.
			vim.api.nvim_set_hl(0, "@lsp.type.comment", { fg = "#6b6b6b" })

			-- No italics anywhere (e.g. neo-tree git status groups default to italic).
			local function strip_italic()
				for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
					if hl.italic or (hl.cterm and hl.cterm.italic) then
						hl.italic = false
						if hl.cterm then
							hl.cterm.italic = false
						end
						hl.default = nil
						vim.api.nvim_set_hl(0, name, hl)
					end
				end
			end
			strip_italic()
			vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
				callback = function()
					vim.defer_fn(strip_italic, 100)
				end,
			})
		end,
	},
	{
	"sainnhe/gruvbox-material",
	lazy = true,
	config = function()
		-- gruvbox-material is a vimscript colorscheme: every option is a global
		-- that has to be set BEFORE :colorscheme runs.
		vim.o.background = "dark"

		-- "hard" | "medium" | "soft"
		vim.g.gruvbox_material_background = "hard"

		-- "material" | "mix" | "original"
		vim.g.gruvbox_material_foreground = "material"

		-- Matches the no-italics preference carried over from gruber-darker.
		vim.g.gruvbox_material_enable_italic = false
		vim.g.gruvbox_material_disable_italic_comment = true
		vim.g.gruvbox_material_enable_bold = false

		vim.g.gruvbox_material_better_performance = 1
		vim.g.gruvbox_material_ui_contrast = "high"
		vim.g.gruvbox_material_diagnostic_virtual_text = "colored"

		vim.cmd.colorscheme("gruvbox-material")
	end,
	},
}
