local M = {}
-- _setup_help_buffer performs an idempotent creation
-- of the symboltree help buffer
--
-- help_buf_handle : previous symboltree help buffer handle
-- or nil
--
-- returns:
--   "buf_handle"  -- handle to a valid symboltree help buffer
function M._setup_help_buffer(help_buf_handle)
    if
        help_buf_handle == nil
        or not vim.api.nvim_buf_is_valid(help_buf_handle)
    then
        local buf = vim.api.nvim_create_buf(false, false)
        if buf == 0 then
            vim.api.nvim_err_writeln("ui.help failed: buffer create failed")
            return
        end
        help_buf_handle = buf
        local lines = {
            "SYMBOLTREE HELP:",
            "press '?' to close",
            "",
            "KEYMAP:",
            "Global---------------------------------------------------------------------------------------------",
            "zo                 - expand a symbol",
            "zc                 - collapse a symbol",
            "zM                 - collapse all symbols",
            "return             - jump to symbol",
            "s                  - jump to symbol in a new split",
            "v                  - jump to symbol in a new vsplit",
            "t                  - jump to symbol in a new tab",
            "d                  - show symbol details",
            "H                  - hide this element from the panel, will appear again on toggle",
            "x                  - remove this element from the panel, will not appear until another LSP request",
            "Up,Down,Right,Left - resize the panel",
            "i                  - show hover info for symbol",
        }
        vim.api.nvim_buf_set_lines(help_buf_handle, 0, #lines, false, lines)
    end
    -- set buf options
    vim.api.nvim_buf_set_name(help_buf_handle, "Symboltree Help")
    vim.api.nvim_buf_set_option(help_buf_handle, 'bufhidden', 'hide')
    vim.api.nvim_buf_set_option(help_buf_handle, 'filetype', 'symboltree')
    vim.api.nvim_buf_set_option(help_buf_handle, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(help_buf_handle, 'modifiable', false)
    vim.api.nvim_buf_set_option(help_buf_handle, 'swapfile', false)

    -- set buffer local keymaps
    local opts = {silent=true}
    vim.api.nvim_buf_set_keymap(help_buf_handle, "n", "?", ":lua require('litee.symboltree').help(false)<CR>", opts)

    return help_buf_handle
end

M.help_buffer = M._setup_help_buffer(nil)

return M
