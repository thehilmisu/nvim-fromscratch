-- In-buffer markdown rendering (headings, tables, code blocks, checkboxes).
-- Uses the treesitter markdown/markdown_inline parsers from treesitter.lua.
-- :RenderMarkdown toggle switches between rendered and raw text; rendering
-- is off automatically on the line you are editing in insert mode.
return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-web-devicons" },
    ft = { "markdown" },
    keys = {
        { "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown: toggle rendering" },
    },
    opts = {
        -- Overrides vim.o.conceallevel = 0 from core/options.lua for markdown
        -- buffers only; raw text comes back on toggle or in insert mode.
        win_options = { conceallevel = { default = 0, rendered = 3 } },
        heading = { sign = false, icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " } },
        code = { sign = false, width = "block", left_pad = 1, right_pad = 1 },
        pipe_table = { preset = "round" },
        checkbox = { enabled = true },
    },
}
