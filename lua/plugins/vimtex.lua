return {
  {
    "lervag/vimtex",
	-- There is no LaTeX toolchain installed here; without this guard vimtex
	-- reports 2 ERRORs and 3 WARNINGs in :checkhealth on every machine that
	-- lacks latexmk. Install texlive-binextra/biber/zathura to re-enable.
	cond = function()
		return vim.fn.executable("latexmk") == 1
	end,
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        continuous = 1,
        callback = 1,
      }
      vim.g.vimtex_quickfix_mode = 2
      vim.g.vimtex_quickfix_autoclose_after_keystrokes = 0
    end,
  },
}
