return {
    "blazkowolf/gruber-darker.nvim",
    lazy = false,
    priority = 1000,
    opts = { italic = false,},
    config = function()
    vim.cmd.colorscheme("gruber-darker")
    end
}
