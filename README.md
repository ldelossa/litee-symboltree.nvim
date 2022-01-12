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

First ensure you also have the litee.nvim (https://github.com/ldelossa/litee.nvim) 
library installed.

litee-symboltree.nvim hooks directly into the LSP infrastructure by hijacking the necessary
handlers like so:

    vim.lsp.handlers['textDocument/documentSymbol'] = vim.lsp.with(
                require('litee.lsp.handlers').ws_lsp_handler(), {}
    )

This occurs when `require('litee.symboltree').setup()` is called.

Once `require('litee.symboltree').setup()` is ran, the normal "vim.lsp.buf.document_symbol" function will open the Symboltree UI.

By default the Symboltree will open in a PopOut Panel, however this default is controlled by the "on_open" configuration
flag and can be changed to open in a side panel instead. (see h: litee-symboltree-config).

Once the Symboltree is open checkout (h: litee-symboltree-commands) to see all the available actions you can take on a Symboltree.

Check out the help file for full details.

