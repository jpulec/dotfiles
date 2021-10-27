local M = {}

-- Mappings
M.keymap = {}
function M.keymap.buf_map(mode, key, cmd, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_buf_set_keymap(0, mode, key, cmd, options)
end

function M.keymap.map(mode, key, cmd, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, key, cmd, options)
end

return M
