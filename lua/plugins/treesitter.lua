-- nvim-treesitter `main` branch: requires nvim >= 0.12, the `tree-sitter` CLI and a C compiler.
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    -- tree-sitter CLI defaults to cl.exe on Windows; use gcc when MSVC is absent.
    if vim.fn.has 'win32' == 1 and vim.fn.executable 'cl' == 0 and vim.fn.executable 'gcc' == 1 then
      vim.env.CC = 'gcc'
    end
    local ts = require 'nvim-treesitter'
    local parsers = { 'c', 'cpp', 'cmake', 'lua', 'luadoc', 'json', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'diff', 'bash' }
    ts.install(parsers)

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end
        -- Install missing parsers on demand, start highlighting once available.
        if not pcall(vim.treesitter.language.add, lang) then
          if vim.list_contains(ts.get_available(), lang) then
            ts.install(lang):await(function()
              if vim.api.nvim_buf_is_valid(args.buf) and pcall(vim.treesitter.language.add, lang) then
                pcall(vim.treesitter.start, args.buf, lang)
              end
            end)
          end
          return
        end
        pcall(vim.treesitter.start, args.buf, lang)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
