```
██╗     ██╗████████╗███████╗███████╗   ███╗   ██╗██╗   ██╗██╗███╗   ███╗
██║     ██║╚══██╔══╝██╔════╝██╔════╝   ████╗  ██║██║   ██║██║████╗ ████║ Lightweight
██║     ██║   ██║   █████╗  █████╗     ██╔██╗ ██║██║   ██║██║██╔████╔██║ Integrated
██║     ██║   ██║   ██╔══╝  ██╔══╝     ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║ Text
███████╗██║   ██║   ███████╗███████╗██╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║ Editing
╚══════╝╚═╝   ╚═╝   ╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ Environment
====================================================================================
```

![litee screenshot](./contrib/litee-screenshot.png)

# litee-symboltree

litee-symboltree utilizes the [litee.nvim](https://github.com/ldelossa/litee.nvim) library to implement a tool analogous to VSCode's
"Outline" tool. 

This tool exposes an explorable tree of document symbols.

The tree is live and will update as you navigate around your source code.

Like all `litee.nvim` backed plugins the UI will work with other `litee.nvim` plugins, 
keeping its appropriate place in a collapsible panel.

# Usage

## Get it

Plug:
```
 Plug 'ldelossa/litee.nvim'
 Plug 'ldelossa/litee-symboltree.nvim'
```

## Set it

Call the setup function from anywhere you configure your plugins from.

Configuration dictionary is explained in ./doc/litee.txt (:h litee-config)

```
-- configure the litee.nvim library 
require('litee.lib').setup({})
-- configure litee-symboltree.nvim
require('litee.symboltree').setup({})
```

## Use it

LITEE.nvim hooks directly into the LSP infrastructure by hijacking the necessary
handlers like so:

    vim.lsp.handlers['textDocument/documentSymbol'] = vim.lsp.with(
                require('litee.lsp.handlers').ws_lsp_handler(), {}
    )

This occurs when `require('litee.symboltree` is called.

Once the handlers are in place issuing the normal "vim.lsp.buf.document_symbol" function will open the Symboltree UI.

All of LITEE.nvim can be controlled via commands making it possible to navigate
the Symboltree via key bindings. 

Check out the help file for full details.
