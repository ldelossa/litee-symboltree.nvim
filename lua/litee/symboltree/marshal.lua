local M = {}

-- marshal_func is a function which returns the necessary
-- values for marshalling a symboltree node into a buffer
-- line.
function M.marshal_func(node)
    local icon_set = require('litee.symboltree').icon_set
    local name, detail, icon = "", "", ""
    if node.document_symbol ~= nil then
        name = node.document_symbol.name
        local kind = vim.lsp.protocol.SymbolKind[node.document_symbol.kind]
        if kind ~= "" then
            icon = icon_set[kind] or  "[" .. kind .. "]"
        end
        if node.document_symbol.detail ~= nil then
            detail = node.document_symbol.detail
        end
    end

    -- all nodes in a symboltree are known ahead of time,
    -- so if a node has no children leave off the expand_guide
    -- indicating it's a leaf without having to expand the node.
    if #node.children == 0 then
        return name, detail, icon, " "
    else
        return name, detail, icon
    end
end

return M
