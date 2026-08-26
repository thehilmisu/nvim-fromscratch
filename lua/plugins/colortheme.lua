return {
	"sainnhe/gruvbox-material",
	lazy = false,
	priority = 1000,
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
}
