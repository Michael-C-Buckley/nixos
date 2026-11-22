vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.g.vscode then
  -- VS Code Neovim extension
  -- Exists exclusively for the Vscode-Neovim Extension
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }
  local nv = { "n", "v" }

  local function vscode_action(action)
    return "<Cmd>lua require('vscode').action('" .. action .. "')<CR>"
  end

  keymap("n", "<Space>", "", opts)

  -- Core editing.
  keymap(nv, "<leader>y", '"+y', opts)
  keymap(nv, "<leader>p", '"+p', opts)
  keymap("v", "p", '"_dP', opts)
  keymap("v", "<", "<gv", opts)
  keymap("v", ">", ">gv", opts)
  keymap("v", "J", ":move '>+1<CR>gv=gv", opts)
  keymap("v", "K", ":move '<-2<CR>gv=gv", opts)
  keymap("n", "<Esc>", "<Esc>:nohlsearch<CR>", opts)
  keymap("n", "n", "nzzzv", opts)
  keymap("n", "N", "Nzzzv", opts)
  keymap("n", "<C-u>", "<C-u>zz", opts)

  -- Navigation and diagnostics.
  keymap("n", "gd", vscode_action("editor.action.revealDefinition"), opts)
  keymap("n", "gD", vscode_action("editor.action.peekDefinition"), opts)
  keymap("n", "gr", vscode_action("editor.action.goToReferences"), opts)
  keymap("n", "gi", vscode_action("editor.action.goToImplementation"), opts)
  keymap("n", "gy", vscode_action("editor.action.goToTypeDefinition"), opts)
  keymap("n", "]d", vscode_action("editor.action.marker.next"), opts)
  keymap("n", "[d", vscode_action("editor.action.marker.prev"), opts)

  -- Files and editors.
  keymap(nv, "<leader>ff", vscode_action("workbench.action.quickOpen"), opts)
  keymap(nv, "<leader>fg", vscode_action("workbench.action.findInFiles"), opts)
  keymap(nv, "<leader>fs", vscode_action("workbench.action.gotoSymbol"), opts)
  keymap(nv, "<leader>fS", vscode_action("workbench.action.showAllSymbols"), opts)
  keymap("n", "<leader>w", vscode_action("workbench.action.files.save"), opts)
  keymap({ "n", "i", "v" }, "<C-s>", vscode_action("workbench.action.files.save"), opts)
  keymap("n", "<leader>q", vscode_action("workbench.action.closeActiveEditor"), opts)
  keymap("n", "<leader>bd", vscode_action("workbench.action.closeActiveEditor"), opts)

  -- Language actions.
  keymap(nv, "<leader>la", vscode_action("editor.action.quickFix"), opts)
  keymap(nv, "<leader>lc", vscode_action("editor.action.codeAction"), opts)
  keymap(nv, "<leader>lr", vscode_action("editor.action.rename"), opts)
  keymap(nv, "<leader>ld", vscode_action("editor.action.showHover"), opts)
  keymap(nv, "<leader>lf", vscode_action("editor.action.formatDocument"), opts)
  keymap(nv, "<leader>lp", vscode_action("workbench.actions.view.problems"), opts)

  -- Windows and terminal.
  keymap("n", "<C-h>", vscode_action("workbench.action.focusLeftGroup"), opts)
  keymap("n", "<C-l>", vscode_action("workbench.action.focusRightGroup"), opts)
  keymap("n", "<C-k>", vscode_action("workbench.action.focusAboveGroup"), opts)
  keymap("n", "<C-j>", vscode_action("workbench.action.focusBelowGroup"), opts)
  keymap("n", "<leader>wh", vscode_action("workbench.action.moveEditorToLeftGroup"), opts)
  keymap("n", "<leader>wl", vscode_action("workbench.action.moveEditorToRightGroup"), opts)
  keymap(nv, "<leader>tt", vscode_action("workbench.action.terminal.toggleTerminal"), opts)

  -- Search, comments, Git, and debugging.
  keymap("n", "<leader>ss", vscode_action("workbench.action.findInFiles"), opts)
  keymap("n", "<leader>sw", vscode_action("editor.action.addSelectionToNextFindMatch"), opts)
  keymap("n", "<C-d>", vscode_action("editor.action.addSelectionToNextFindMatch"), opts)
  keymap("n", "<leader>mc", vscode_action("editor.action.insertCursorBelow"), opts)
  keymap(nv, "<leader>/", vscode_action("editor.action.commentLine"), opts)
  keymap("n", "<leader>gs", vscode_action("workbench.view.scm"), opts)
  keymap("n", "<leader>gd", vscode_action("git.openChange"), opts)
  keymap(nv, "<leader>db", vscode_action("editor.debug.action.toggleBreakpoint"), opts)
  keymap(nv, "<leader>cp", vscode_action("workbench.action.showCommands"), opts)
  keymap(nv, "<leader>cn", vscode_action("notifications.clearAll"), opts)

  -- VSCode Harpoon.
  keymap(nv, "<leader>ha", vscode_action("vscode-harpoon.addEditor"), opts)
  keymap(nv, "<leader>ho", vscode_action("vscode-harpoon.editorQuickPick"), opts)
  keymap(nv, "<leader>he", vscode_action("vscode-harpoon.editEditors"), opts)
  for index = 1, 9 do
    keymap(nv, "<leader>h" .. index, vscode_action("vscode-harpoon.gotoEditor" .. index), opts)
  end

  -- VSCode Project Manager.
  keymap(nv, "<leader>pa", vscode_action("projectManager.saveProject"), opts)
  keymap(nv, "<leader>po", vscode_action("projectManager.listProjectsNewWindow"), opts)
  keymap(nv, "<leader>pe", vscode_action("projectManager.editProjects"), opts)
  return
end

-- Editor options
do
  local opt = vim.opt

  -- Editing defaults carried over from NVF
  opt.expandtab = true
  opt.matchtime = 2
  opt.shiftwidth = 2
  opt.shiftround = true
  opt.smartindent = true
  opt.softtabstop = 2
  opt.tabstop = 2

  -- Keep context visible without adding a custom status column
  opt.cursorline = true
  opt.number = true
  opt.relativenumber = true
  opt.scrolloff = 10
  opt.sidescrolloff = 10
  opt.signcolumn = "yes"
  opt.termguicolors = true
  opt.wrap = false

  -- File handling
  opt.exrc = true
  opt.swapfile = false
  opt.undofile = true
  opt.writebackup = false

  -- General behavior
  opt.clipboard = "unnamedplus"
  opt.completeopt = { "menuone", "noselect", "popup" }
  opt.confirm = true
  opt.foldlevel = 99
  opt.foldlevelstart = 99
  opt.ignorecase = true
  opt.mouse = "a"
  opt.scrollback = 10000
  opt.smartcase = true
  opt.splitbelow = true
  opt.splitright = true
  opt.timeoutlen = 300
  opt.ttimeoutlen = 0
  opt.updatetime = 250

  -- Start with a plain empty buffer, not Neovim's intro screen
  opt.shortmess:append("I")
end

-- Install and load plugins before configuring them.
do
  if vim.fn.has("nvim-0.12") == 0 then
    error("This configuration requires Neovim 0.12 or newer (vim.pack and native LSP config).")
  end

  local plugins = {
    {
      src = "https://github.com/uhs-robert/oasis.nvim",
      version = "v6.1.0",
    },
    "https://github.com/folke/snacks.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/akinsho/bufferline.nvim",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    {
      src = "https://github.com/Saghen/blink.cmp",
      version = vim.version.range("^1"),
    },
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/folke/todo-comments.nvim",
    "https://codeberg.org/andyg/leap.nvim",
    "https://github.com/stevearc/aerial.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/refractalize/oil-git-status.nvim",
    "https://github.com/jmbuhr/otter.nvim",
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/mfussenegger/nvim-dap-python",
    "https://github.com/m4xshen/smartcolumn.nvim",
    "https://github.com/Shatur/neovim-ayu",
    "https://github.com/webhooked/kanso.nvim",
    "https://github.com/t-b-t-nchos/aquavium.nvim",
  }

  -- Set this flag before loading init.lua when Nix supplies the plugin,
  -- parsers, and queries on runtimepath.
  if not vim.g.nix_treesitter then
    plugins[#plugins + 1] = "https://github.com/nvim-treesitter/nvim-treesitter"
  end

  vim.pack.add(plugins, {
    confirm = false,
    load = true,
  })

  vim.api.nvim_create_user_command("PackUpdate", function()
    local names = {
      "oasis.nvim",
      "snacks.nvim",
      "mini.nvim",
      "lualine.nvim",
      "bufferline.nvim",
      "oil.nvim",
      "plenary.nvim",
      "blink.cmp",
      "friendly-snippets",
      "conform.nvim",
      "nvim-autopairs",
      "todo-comments.nvim",
      "leap.nvim",
      "aerial.nvim",
      "gitsigns.nvim",
      "oil-git-status.nvim",
      "otter.nvim",
      "nvim-dap",
      "nvim-nio",
      "nvim-dap-ui",
      "nvim-dap-python",
      "smartcolumn.nvim",
      "neovim-ayu",
      "kanso.nvim",
      "aquavium.nvim",
    }

    if not vim.g.nix_treesitter then
      names[#names + 1] = "nvim-treesitter"
    end

    vim.pack.update(names)
  end, { desc = "Review updates for this config's active plugins" })
end

-- Theme and general plugins
do
  -- THEME
  vim.o.background = "dark"

  require("oasis").setup({
    style = "moonlight",
    integrations = {
      default_enabled = false,
      plugins = {
        gitsigns = true,
        mini = true,
        snacks = true,
      },
    },
  })

  vim.cmd.colorscheme("oasis-moonlight")

  -- UI
  require("mini.icons").setup()
  MiniIcons.mock_nvim_web_devicons()

  require("bufferline").setup({
    options = {
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
    },
  })

  require("lualine").setup({
    options = {
      globalstatus = true,
      theme = "auto",
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "lsp_status", "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    extensions = { "oil", "quickfix" },
  })

  require("smartcolumn").setup({
    colorcolumn = "80",
    disabled_filetypes = {
      "help",
      "text",
      "markdown",
      "oil",
      "snacks_picker_input",
      "snacks_picker_list",
    },
    custom_colorcolumn = {
      go = "120",
      nix = "110",
      python = { "80", "120" },
    },
  })

  require("nvim-autopairs").setup({
    map_cr = false,
  })

  require("todo-comments").setup()

  vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next()
  end, { silent = true, desc = "Next TODO comment" })

  vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
  end, { silent = true, desc = "Previous TODO comment" })

  vim.keymap.set("n", "<leader>xt", "<Cmd>TodoQuickFix<CR>", {
    silent = true,
    desc = "TODO comments",
  })
end

-- Snacks: pickers, notifications, and utilities
do
  local snacks = require("snacks")

  snacks.setup({
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = {
      enabled = true,
      replace_netrw = false, -- Let Oil handle directory buffers.
    },
    notifier = {
      enabled = true,
      style = "compact",
      timeout = 3000,
    },
    picker = { enabled = true },
    scroll = { enabled = true },
  })

  -- LSP progress is shown by lualine's lsp_status component.

  -- Keep native selectors (including LSP code actions) in the same picker UI.
  vim.ui.select = snacks.picker.select

  local function map(lhs, callback, desc, mode)
    vim.keymap.set(mode or "n", lhs, callback, { silent = true, desc = desc })
  end

  -- Files and search.
  map("<leader><space>", function()
    snacks.picker.smart()
  end, "Smart find files")
  map("<leader>f", function()
    snacks.picker.files()
  end, "Find files")
  map("<leader>e", function()
    snacks.explorer()
  end, "File explorer")
  map("<leader>?", function()
    snacks.picker()
  end, "Browse pickers")
  map("<leader>;", function()
    snacks.picker.resume()
  end, "Resume last picker")
  map("<leader>/", function()
    snacks.picker.grep()
  end, "Grep")
  map("<leader>b", function()
    snacks.picker.buffers()
  end, "Buffers")
  map("<leader>cs", function()
    snacks.picker.colorschemes()
  end, "Colorschemes")
  map("<leader>u", function()
    snacks.picker.undo()
  end, "Undo history")
  map("<leader>nh", function()
    snacks.notifier.show_history()
  end, "Notification history")
  map("<leader>nd", function()
    snacks.notifier.hide()
  end, "Dismiss notifications")
  map("<leader>s", function()
    snacks.picker.lsp_symbols()
  end, "Document symbols")
  map("<leader>S", function()
    snacks.picker.lsp_workspace_symbols()
  end, "Workspace symbols")

  -- LSP navigation through the same picker used everywhere else. grr, gri and
  -- grt replace Neovim's default gr* maps so the whole gr* family stays intact.
  map("gd", function()
    snacks.picker.lsp_definitions()
  end, "LSP definitions")
  map("gD", function()
    snacks.picker.lsp_declarations()
  end, "LSP declarations")
  map("grr", function()
    snacks.picker.lsp_references()
  end, "LSP references")
  map("gri", function()
    snacks.picker.lsp_implementations()
  end, "LSP implementations")
  map("grt", function()
    snacks.picker.lsp_type_definitions()
  end, "LSP type definitions")
  map("gy", function()
    snacks.picker.lsp_type_definitions()
  end, "LSP type definitions")

  -- Diagnostic picker equivalents for the old Trouble bindings.
  map("<leader>xx", function()
    snacks.picker.diagnostics()
  end, "Workspace diagnostics")
  map("<leader>xX", function()
    snacks.picker.diagnostics_buffer()
  end, "Buffer diagnostics")
  map("<leader>xL", function()
    snacks.picker.loclist()
  end, "Location list")
  map("<leader>xQ", function()
    snacks.picker.qflist()
  end, "Quickfix list")

  -- Git and terminal utilities already used in the Lua configs.
  map("<leader>gg", function()
    snacks.lazygit()
  end, "Lazygit")
  map("<leader>gf", function()
    snacks.lazygit.log_file()
  end, "Lazygit file log")
  map("<leader>gs", function()
    snacks.picker.git_status()
  end, "Git status")
  map("<leader>gd", function()
    snacks.picker.git_diff()
  end, "Git diff")
  map("<leader>gb", function()
    snacks.picker.git_branches()
  end, "Git branches")
  map("<M-t>", function()
    snacks.terminal()
  end, "Toggle terminal", { "n", "t" })
end

-- Completion and snippets
do
  require("blink.cmp").setup({
    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    snippets = { preset = "default" },
    signature = { enabled = true },
    fuzzy = { implementation = "prefer_rust" },
  })
end

-- Formatting: the same formatters as .config/treefmt.toml, with LSP formatting
-- for other filetypes or when a formatter isn't on PATH.
do
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      markdown = { "mdformat" },
      nix = { "nixfmt" },
      toml = { "taplo" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters = {
      stylua = {
        -- stylua doesn't look in .config/ on its own; treefmt passes it explicitly.
        prepend_args = function(_, ctx)
          local root = vim.fs.root(ctx.filename, ".git")
          local config = root and root .. "/.config/stylua.toml"
          if config and vim.uv.fs_stat(config) then
            return { "--config-path", config }
          end
          return {}
        end,
      },
    },
  })
end

-- File navigation and code outline
do
  require("oil").setup({
    default_file_explorer = true,
    columns = { "icon" },
    win_options = {
      signcolumn = "yes:2",
    },
    view_options = {
      show_hidden = true,
      natural_order = "fast",
    },
  })

  require("oil-git-status").setup()

  vim.keymap.set("n", "-", "<Cmd>Oil<CR>", {
    silent = true,
    desc = "Open parent directory in Oil",
  })

  require("aerial").setup()

  vim.keymap.set("n", "<leader>a", "<Cmd>AerialToggle!<CR>", {
    silent = true,
    desc = "Toggle code outline",
  })
end

-- Git
do
  local gs = require("gitsigns")

  gs.setup()

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      silent = true,
      desc = "Git: " .. desc,
    })
  end

  map("n", "]c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "]c", bang = true })
    else
      gs.nav_hunk("next")
    end
  end, "Next hunk")

  map("n", "[c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    else
      gs.nav_hunk("prev")
    end
  end, "Previous hunk")

  map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
  map("x", "<leader>hs", function()
    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, "Stage selected hunk")
  map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
  map("x", "<leader>hr", function()
    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, "Reset selected hunk")
  map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
  map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
  map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
  map("n", "<leader>hb", function()
    gs.blame_line({ full = true })
  end, "Blame line")
  map("n", "<leader>hd", gs.diffthis, "Diff against index")
end

-- Debugging: nvim-dap, its UI, and the Python adapter are configured by the
-- first DAP keymap instead of at startup.
do
  local configured = false

  local function setup()
    if configured then
      return
    end
    configured = true

    local dap = require("dap")
    local dapui = require("dapui")
    local dap_python = require("dap-python")

    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.4 },
            { id = "breakpoints", size = 0.15 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.2 },
          },
          size = 50,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 12,
          position = "bottom",
        },
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticUnnecessary" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

    -- Python: prefer uv; otherwise dap-python uses python3, which needs debugpy.
    dap_python.setup(vim.fn.executable("uv") == 1 and "uv" or nil)
    dap_python.test_runner = "pytest"

    dap.configurations.python = dap.configurations.python or {}

    table.insert(dap.configurations.python, {
      type = "python",
      request = "launch",
      name = "Launch file with arguments",
      program = "${file}",
      args = function()
        local input = vim.fn.input("Arguments: ")
        return vim.split(input, " ", { trimempty = true })
      end,
    })

    table.insert(dap.configurations.python, {
      type = "python",
      request = "launch",
      name = "Launch module (-m)",
      module = function()
        return vim.fn.input("Module name: ")
      end,
    })

    table.insert(dap.configurations.python, {
      type = "python",
      request = "attach",
      name = "Attach to running process",
      connect = {
        host = "127.0.0.1",
        port = function()
          return tonumber(vim.fn.input("Port [5678]: ")) or 5678
        end,
      },
    })
  end

  -- Every DAP mapping configures DAP before running its action.
  local function map(mode, lhs, action, desc)
    vim.keymap.set(mode, lhs, function()
      setup()
      action()
    end, { silent = true, desc = "DAP: " .. desc })
  end

  -- Action that calls require(module)[method]() with no arguments.
  local function call(module, method)
    return function()
      require(module)[method]()
    end
  end

  map("n", "<F5>", call("dap", "continue"), "Continue or start")
  map("n", "<S-F5>", call("dap", "terminate"), "Terminate")
  map("n", "<F9>", call("dap", "restart"), "Restart")
  map("n", "<F10>", call("dap", "step_over"), "Step over")
  map("n", "<F11>", call("dap", "step_into"), "Step into")
  map("n", "<F12>", call("dap", "step_out"), "Step out")

  map("n", "<leader>db", call("dap", "toggle_breakpoint"), "Toggle breakpoint")
  map("n", "<leader>dB", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, "Conditional breakpoint")
  map("n", "<leader>dl", function()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end, "Set log point")
  map("n", "<leader>dC", call("dap", "clear_breakpoints"), "Clear breakpoints")
  map("n", "<leader>dr", call("dap.repl", "toggle"), "Toggle REPL")
  map("n", "<leader>dt", call("dap", "run_to_cursor"), "Run to cursor")
  map("n", "<leader>dx", call("dap", "terminate"), "Terminate")
  map("n", "<leader>dd", call("dap", "run_last"), "Run last")
  map({ "n", "t" }, "<M-d>", call("dapui", "toggle"), "Toggle UI")
  map("n", "<leader>du", call("dapui", "toggle"), "Toggle UI")
  map({ "n", "x" }, "<leader>dh", call("dapui", "eval"), "Evaluate under cursor")
  map("n", "<leader>dp", function()
    require("dapui").eval(vim.fn.input("Expression: "))
  end, "Evaluate expression")

  map("n", "<leader>dm", call("dap-python", "test_method"), "Debug Python test method")
  map("n", "<leader>dc", call("dap-python", "test_class"), "Debug Python test class")
  map("x", "<leader>ds", call("dap-python", "debug_selection"), "Debug Python selection")
end

-- General keymaps
do
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  local all_modes = { "n", "i", "v", "c", "t", "o", "x", "s" }
  local active_modes = { "n", "i", "v", "t" }

  -- Save and quit.
  map("n", "<leader>w", "<Cmd>write<CR>", { desc = "Save" })
  map("n", "<leader>qq", "<Cmd>quit<CR>", { desc = "Quit" })
  map("n", "<Esc>", "<Cmd>nohlsearch<CR>")
  map(all_modes, "<F1>", "<Nop>")
  map(active_modes, "<C-s>", "<Cmd>write<CR>", { desc = "Save" })

  -- Buffers and windows.
  map(active_modes, "<M-,>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
  map(active_modes, "<M-.>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
  map(active_modes, "<M-w>", "<Cmd>bdelete<CR>", { desc = "Delete buffer" })
  map(active_modes, "<M-a>", "<Cmd>wincmd w<CR>", { desc = "Next window" })
  map(active_modes, "<M-v>", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
  map("n", "<leader>,", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
  map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
  map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
  map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
  map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

  -- Editing helpers.
  map({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
  map({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
  map("x", "p", '"_dP', { desc = "Paste without replacing yank" })
  map("x", "<", "<gv", { desc = "Indent left and reselect" })
  map("x", ">", ">gv", { desc = "Indent right and reselect" })
  map("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })
  map("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })
  map("i", "<A-t>", "<C-v><Tab>", { desc = "Insert literal tab" })
  -- Native commenting (gc / gcc).
  map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
  map("x", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })

  -- Diagnostics and formatting.
  -- ]d / [d are Neovim's defaults; the float on jump comes from
  -- vim.diagnostic.config({ jump = ... }) in the Diagnostics section.
  map("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

  local function format()
    require("conform").format()
  end

  map({ "n", "x" }, "f<leader>", format, { desc = "Format buffer or selection" })
  map({ "n", "x" }, "<leader>cf", format, { desc = "Format buffer or selection" })

  map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })

  vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap" })
  vim.keymap.set("n", "S", "<Plug>(leap-from-window)", { desc = "Leap from window" })
end

-- Key hints: mini.clue lists the next keys after a trigger. It has no timeout,
-- so a mapping must not also be the prefix of a longer one.
do
  local miniclue = require("mini.clue")

  miniclue.setup({
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
      { mode = "n", keys = "<C-w>" },
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      { mode = "i", keys = "<C-x>" },
    },
    clues = {
      { mode = "n", keys = "<Leader>c", desc = "+Code" },
      { mode = "x", keys = "<Leader>c", desc = "+Code" },
      { mode = "n", keys = "<Leader>d", desc = "+Debug" },
      { mode = "x", keys = "<Leader>d", desc = "+Debug" },
      { mode = "n", keys = "<Leader>g", desc = "+Git" },
      { mode = "n", keys = "<Leader>h", desc = "+Hunks" },
      { mode = "x", keys = "<Leader>h", desc = "+Hunks" },
      { mode = "n", keys = "<Leader>n", desc = "+Notifications" },
      { mode = "n", keys = "<Leader>q", desc = "+Quit" },
      { mode = "n", keys = "<Leader>x", desc = "+Lists and diagnostics" },
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
    window = {
      delay = 300, -- Same as timeoutlen.
    },
  })
end

-- General autocmds
do
  local function augroup(name)
    return vim.api.nvim_create_augroup("michael_" .. name, { clear = true })
  end

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
      vim.hl.on_yank()
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup("write_housekeeping"),
    callback = function(event)
      local path = vim.api.nvim_buf_get_name(event.buf)
      if path ~= "" then
        vim.fn.mkdir(vim.fs.dirname(path), "p")
      end

      if not vim.bo[event.buf].modifiable or vim.bo[event.buf].binary then
        return
      end

      local view = vim.fn.winsaveview()
      vim.cmd([[silent keepjumps keeppatterns %s/\s\+$//e]])
      vim.fn.winrestview(view)
    end,
  })

  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    group = augroup("check_external_changes"),
    callback = function()
      if vim.fn.getcmdwintype() == "" then
        vim.cmd("checktime")
      end
    end,
  })

  vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup("terminal"),
    callback = function()
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end,
  })
end

-- Diagnostics
do
  vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = { current_line = true },
    -- Defaults for ]d, [d, ]D, [D: show the diagnostic in a float after a jump.
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
      end,
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = "rounded",
      source = true,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "✘",
        [vim.diagnostic.severity.WARN] = "▲",
        [vim.diagnostic.severity.INFO] = "●",
        [vim.diagnostic.severity.HINT] = "➜",
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      },
    },
  })

  local function blend(fg, bg, alpha)
    local fr, fgg, fb = math.floor(fg / 0x10000) % 0x100, math.floor(fg / 0x100) % 0x100, fg % 0x100
    local br, bgg, bb = math.floor(bg / 0x10000) % 0x100, math.floor(bg / 0x100) % 0x100, bg % 0x100
    local function mix(a, b)
      return math.floor(a * alpha + b * (1 - alpha))
    end
    return string.format("#%02x%02x%02x", mix(fr, br), mix(fgg, bgg), mix(fb, bb))
  end

  local function style_virtual_lines()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    if not normal.bg then
      return
    end

    for _, severity in ipairs({ "Error", "Warn", "Info", "Hint" }) do
      local base = vim.api.nvim_get_hl(0, { name = "Diagnostic" .. severity, link = false })
      if base.fg then
        vim.api.nvim_set_hl(
          0,
          "DiagnosticVirtualLines" .. severity,
          vim.tbl_extend("force", base, {
            bold = true,
            bg = blend(base.fg, normal.bg, 0.18),
          })
        )
      end
    end
  end

  style_virtual_lines()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("michael_diagnostic_colors", { clear = true }),
    callback = style_virtual_lines,
  })
end

-- Language servers
do
  require("otter").setup()

  vim.keymap.set("n", "<leader>lo", "<Cmd>OtterActivate<CR>", {
    silent = true,
    desc = "Activate embedded-language LSP",
  })

  local capabilities = require("blink.cmp").get_lsp_capabilities()

  local servers = {
    lua_ls = {
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
      before_init = function(_, config)
        -- Read from somewhere like .config if available since I do that a lot
        local path = config.root_dir and (config.root_dir .. "/.config/luarc.json")
        if not path or vim.fn.filereadable(path) ~= 1 then
          return
        end

        local project_settings = vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
        local default_library = config.settings.Lua.workspace.library
        project_settings.workspace.library = vim.list_extend(default_library, project_settings.workspace.library)
        config.settings.Lua = vim.tbl_deep_extend("force", config.settings.Lua, project_settings)
      end,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          },
        },
      },
    },
    nil_ls = {
      cmd = { "nil" },
      filetypes = { "nix" },
      root_markers = { "flake.nix", ".git" },
      settings = {
        ["nil"] = {
          formatting = { command = { "nixfmt" } },
          nix = {
            flake = {
              autoArchive = true,
              nixpkgsInputName = "nixpkgs",
              maxMemoryMB = 4096,
            },
          },
        },
      },
    },
    zuban = {
      cmd = { "zuban", "server" },
      root_markers = { "pyproject.toml", ".git" },
      filetypes = { "python" },
    },
    basedpyright = {
      cmd = { "basedpyright-langserver", "--stdio" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
      settings = {
        basedpyright = {
          typeCheckingMode = "standard",
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
          },
        },
      },
    },
    ruff = {
      cmd = { "ruff", "server" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", "setup.py", ".git" },
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
      end,
    },
    gopls = {
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_markers = { "go.work", "go.mod", ".git" },
    },
    bashls = {
      cmd = { "bash-language-server", "start" },
      filetypes = { "bash", "sh", "zsh" },
      root_markers = { ".git" },
    },
    yamlls = {
      cmd = { "yaml-language-server", "--stdio" },
      filetypes = { "yaml" },
      root_markers = { ".git" },
    },
    jsonls = {
      cmd = { "vscode-json-language-server", "--stdio" },
      filetypes = { "json", "jsonc" },
      root_markers = { ".git" },
    },
    nushell = {
      cmd = { "nu", "--lsp" },
      filetypes = { "nu" },
      root_markers = { ".git" },
    },
  }

  -- basedpyright is only a fallback for when zuban is unavailable.
  if vim.fn.executable(servers.zuban.cmd[1]) == 1 then
    servers.basedpyright = nil
  end

  local missing = {}
  for name, config in pairs(servers) do
    config.capabilities = capabilities
    vim.lsp.config(name, config)

    if vim.fn.executable(config.cmd[1]) == 1 then
      vim.lsp.enable(name)
    else
      table.insert(missing, config.cmd[1])
    end
  end
  table.sort(missing)

  vim.api.nvim_create_user_command("LspMissing", function()
    if #missing == 0 then
      vim.notify("All configured language servers are available.")
      return
    end
    vim.notify("Missing language-server commands: " .. table.concat(missing, ", "), vim.log.levels.WARN)
  end, { desc = "Show configured language servers missing from PATH" })

  -- Neovim already maps K to hover on attach; these add leader aliases for
  -- the default grn and gra.
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("michael_lsp_attach", { clear = true }),
    callback = function(event)
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = event.buf, silent = true, desc = "LSP: " .. desc })
      end

      map("<leader>rn", vim.lsp.buf.rename, "Rename")
      map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    end,
  })
end

-- Treesitter
do
  local parsers = {
    "bash",
    "diff",
    "go",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "nu",
    "python",
    "query",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
    "yang",
  }

  -- Nix supplies the plugin, parsers, and queries on runtimepath. Skip setup
  -- in that mode so the local install directory is not prepended ahead of them.
  if not vim.g.nix_treesitter then
    local treesitter = require("nvim-treesitter")
    treesitter.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Portable installs compile parsers locally; Nix provides prebuilt ones.
    -- Check the build tools before starting a separate failing job per parser.
    vim.schedule(function()
      local installed = treesitter.get_installed("parsers")
      local missing = vim.tbl_filter(function(parser)
        return not vim.list_contains(installed, parser)
      end, parsers)
      if #missing == 0 then
        return
      end

      local missing_tools = {}
      for _, tool in ipairs({ "tree-sitter", "curl", "tar" }) do
        if vim.fn.executable(tool) == 0 then
          missing_tools[#missing_tools + 1] = tool
        end
      end

      -- RB supplies Zig for hosts without a system compiler. Keep an explicit
      -- CC override or the platform's default compiler when available.
      if not vim.env.CC and vim.fn.executable("cc") == 0 and vim.fn.executable("zig") == 1 then
        vim.env.CC = "zig cc"
        -- tree-sitter passes a Rust target triple that Zig does not accept.
        -- CFLAGS comes after that argument; build for this host instead.
        vim.env.CFLAGS = (vim.env.CFLAGS or "") .. " -target native"
      end
      local compiler = vim.split(vim.env.CC or "cc", "%s+", { trimempty = true })[1] or "cc"
      if vim.fn.executable(compiler) == 0 then
        missing_tools[#missing_tools + 1] = "C compiler (install zig through RB or set CC)"
      end

      if #missing_tools > 0 then
        vim.notify(
          "Treesitter parser installation skipped. Missing: " .. table.concat(missing_tools, ", "),
          vim.log.levels.WARN
        )
      else
        treesitter.install(parsers)
      end
    end)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("michael_treesitter", { clear = true }),
    callback = function(event)
      local language = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
      if not language then
        return
      end

      if pcall(vim.treesitter.start, event.buf, language) then
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
      end
    end,
  })
end
