local utils = require('core.utils')

local function nmap(key, cmd, opts)
    utils.keymap.buf_map('n', key, cmd, opts)
end

local function lua_nmap(key, cmd, opts)
    nmap(key, '<cmd>lua  ' .. cmd .. '<CR>', opts)
end

return function(client)
    lua_nmap('K', 'vim.lsp.buf.hover()')
		lua_nmap('gD', 'vim.lsp.buf.declaration()')
    lua_nmap('gd', 'vim.lsp.buf.definition()')
    lua_nmap('gi', 'vim.lsp.buf.implementation()')
    lua_nmap('gr', 'vim.lsp.buf.references()')
    lua_nmap('gt', 'vim.lsp.buf.type_definition()')
    lua_nmap('ca', 'vim.lsb.buf.code_action()')
    lua_nmap('<space>gh', 'vim.lsp.buf.signature_help()')
    lua_nmap('<space>rn', 'vim.lsp.buf.rename()')
    lua_nmap('[d', 'vim.diagnostic.goto_prev()')
    lua_nmap(']d', 'vim.diagnostic.goto_next()')

  
    --require('lsp_signature').on_attach()
    require('lsp-status').on_attach(client)

    if client.resolved_capabilities.document_formatting then
        vim.cmd([[
            augroup Format
              autocmd! * <buffer>
              autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 5000)
            augroup END
        ]])
    end
end
