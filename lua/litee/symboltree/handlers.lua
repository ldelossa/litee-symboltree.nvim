local lib_state         = require('litee.lib.state')
local lib_panel         = require('litee.lib.panel')
local lib_tree          = require('litee.lib.tree')
local lib_tree_node     = require('litee.lib.tree.node')
local lib_util          = require('litee.lib.util')
local lib_notify        = require('litee.lib.notify')

local M = {}

local function keyify(document_symbol)
    if document_symbol ~= nil then
        local key = document_symbol.name .. ":" ..
                    document_symbol.kind .. ":" ..
                    document_symbol.range.start.line
        return key
    end
end

function M.build_recursive_symbol_tree(depth, document_symbol, parent, prev_depth_table)
        local node = lib_tree_node.new_node(
            document_symbol.name,
            keyify(document_symbol),
            depth
        )
        node.document_symbol = document_symbol
        if parent == nil then
            -- if this node has no parents, its actually the synthetic document_symbol
            -- we use to build this tree. it contains a .uri field which each child
            -- will attach to itself recursively from here on.
            node.location = {
                uri = document_symbol.uri,
                range = node.document_symbol.selectionRange
            }
        end
        -- if we have a previous depth table search it for an old reference of self
        -- and set expanded state correctly.
        if prev_depth_table ~= nil and prev_depth_table[depth] ~= nil then
            for _, child in ipairs(prev_depth_table[depth]) do
                if child.key == node.key then
                    node.expanded = child.expanded
                end
            end
        end
        if parent ~= nil then
            -- the parent will be carrying the uri for the document symbol tree we are building.
            node.location = {
                uri = parent.location.uri,
                range = node.document_symbol.selectionRange
            }
            table.insert(parent.children, node)
        end
        if document_symbol.children ~= nil then
            for _, child_document_symbol in ipairs(document_symbol.children) do
            M.build_recursive_symbol_tree(depth+1, child_document_symbol, node, prev_depth_table)
            end
        end
        return node
end

-- ds_lsp_handler handles the initial request for building
-- a document symbols outline.
M.ds_lsp_handler = function()
    return function(err, result, ctx, _)
        if err ~= nil then
            return
        end
        if result == nil then
            return
        end

        local cur_win = vim.api.nvim_get_current_win()
        local cur_tabpage = vim.api.nvim_win_get_tabpage(cur_win)

        local state = lib_state.get_component_state(cur_tabpage, "symboltree")
        if state == nil then
            state = {}
        end

        -- snag the lsp clients from the buffer issuing the
        -- call hierarchy request
        state.active_lsp_clients = vim.lsp.get_active_clients()

        -- grab the previous depth table if it exists
        local prev_depth_table = nil
        local prev_tree = lib_tree.get_tree(state.tree)
        if prev_tree ~= nil then
            prev_depth_table = prev_tree.depth_table
        end

        -- set the invoking window to the current
        state.invoking_win = cur_win
        -- set the owning tab to the current one
        state.tab = cur_tabpage

        -- remove existing tree from memory is exists
        if state.tree ~= nil then
            lib_tree.remove_tree(state.tree)
        end

        -- create a new tree
        state.tree = lib_tree.new_tree("symboltree")

        -- create a synthetic document symbol to act as a root
        local synthetic_range = {}
        synthetic_range["start"] = {line=0,character=0}
        synthetic_range["end"] = {line=0,character=0}
        local synthetic_root_ds = {
            name = lib_util.relative_path_from_uri(ctx.params.textDocument.uri),
            kind = 1,
            range = synthetic_range, -- provide this so keyify works in tree_node.add
            selectionRange = synthetic_range, -- provide this so keyify works in tree_node.add
            children = result,
            uri = ctx.params.textDocument.uri,
            detail = "file"
        }

        local root = M.build_recursive_symbol_tree(0, synthetic_root_ds, nil, prev_depth_table)

        lib_tree.add_node(state.tree, root, nil, true)

        local cursor = nil
        if vim.api.nvim_win_is_valid(state.win) then
            cursor = vim.api.nvim_win_get_cursor(state.win)
        end

        -- if lsp.wrappers are being used this closes the notification
        -- popup.
        lib_notify.close_notify_popup()

        -- update component state and grab the global since we need it to toggle
        -- the panel open.
        local global_state = lib_state.put_component_state(cur_tabpage, "symboltree", state)

        lib_panel.toggle_panel(global_state, true, false)

        -- restore cursor if possible
        if cursor ~= nil then
           local count = vim.api.nvim_buf_line_count(state.buf)
           if  count ~= nil
               and vim.api.nvim_buf_is_valid(state.buf)
               and vim.api.nvim_buf_line_count(state.buf) >= cursor[1] then
                vim.api.nvim_win_set_cursor(state.win, cursor)
            end
       end
    end
end

return M
