vim.cmd([[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
    autocmd FileType man setl laststatus=0 noruler
    autocmd FileType vim,css,javascript,sh,zsh setl sw=2
    autocmd TermOpen term://* setl nornu nonu nocul so=0 scl=no
    autocmd BufReadPost,FileReadPost * normal zR
  augroup end
  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end
  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end
  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end
  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end
]])

-- Open Alpha (or a blank buffer) instead of exiting when no listed buffers remain
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.bo.filetype == "alpha" then
			return
		end
		if #vim.fn.getbufinfo({ buflisted = 1 }) == 0 then
			-- ensure there's a normal buffer for Alpha to attach to
			if vim.bo.buftype ~= "" then
				vim.cmd("enew")
			end
			local ok, alpha = pcall(require, "alpha")
			if ok then
				alpha.start(false)
			else
				vim.cmd("enew")
			end
		end
	end,
})
