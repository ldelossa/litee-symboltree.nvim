local M = {}

M.config = {
    jump_mode = "invoking",
    hide_cursor = true,
    map_resize_keys = true,
    no_hls = false,
    auto_highlight = true,
    on_open = "panel",
    disable_keymaps = false,
    keymaps = {
      expand = "zo",
      collapse = "zc",
      collapse_all = "zM",
      jump = "<CR>",
      jump_split = "s",
      jump_vsplit = "v",
      jump_tab = "t",
      hover = "i",
      details = "d",
      close = "X",
      close_panel_pop_out = "<Esc>",
      help = "?",
      hide = "<C-[>",
    },
    icon_set = "default",
    icon_set_custom = nil,
}

return M
