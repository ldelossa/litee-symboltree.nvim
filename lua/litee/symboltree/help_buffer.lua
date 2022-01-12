local config = require('litee.symboltree.config').config

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
            ("%-19s- resize the panel"):format("Up,Down,Right,Left"),
        }
        local configurable_mapping_lines = config.keymaps and {
            ("%-19s- expand a symbol"):format(config.keymaps.expand),
            ("%-19s- collapse a symbol"):format(config.keymaps.collapse),
            ("%-19s- collapse all symbols"):format(config.keymaps.collapse_all),
            ("%-19s- jump to symbol"):format(config.keymaps.jump),
            ("%-19s- jump to symbol in a new split"):format(config.keymaps.jump_split),
            ("%-19s- jump to symbol in a new vsplit"):format(config.keymaps.jump_vsplit),
            ("%-19s- jump to symbol in a new tab"):format(config.keymaps.jump_tab),
            ("%-19s- show symbol details"):format(config.keymaps.details),
            ("%-19s- hide this element from the panel, will appear again on toggle"):format(config.keymaps.hide),
            ("%-19s- remove this element from the panel, will not appear until another LSP request"):format(config.keymaps.close),
            ("%-19s- show hover info for symbol"):format(config.keymaps.hover),
        } or {}
        for _, line in pairs(configurable_mapping_lines) do
          table.insert(lines, line)
        end
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

return M
