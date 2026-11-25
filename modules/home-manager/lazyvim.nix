{
  pkgs,
  inputs,
  ...
}:
let
  # Quarto 1.10 emits this option, but nixpkgs' Pandoc 3.7 expects the old name.
  quartoPatched = pkgs.quarto.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      substituteInPlace $out/bin/quarto.js \
        --replace-fail "syntax-highlighting" "highlight-style"
    '';
  });
in
{
  imports = [
    inputs.lazyvim.homeManagerModules.default
  ];

  programs.neovim.defaultEditor = true;

  programs.lazyvim = {
    enable = true;

    extras.lang = {
      nix.enable = true;
      clangd.enable = true;
      yaml.enable = true;

      typst = {
        enable = true;
        installDependencies = true; # Install tinymist
      };

      python = {
        enable = true;
        installDependencies = true; # Install ruff
        installRuntimeDependencies = true; # Install python3
      };

      java = {
        enable = true;
        installDependencies = false;
        installRuntimeDependencies = true;
      };
    };

    config.options = ''
      vim.opt.mouse = ""
    '';

    config.keymaps = ''
      vim.api.nvim_create_user_command("Jr", function()
        if vim.bo.filetype ~= "java" then
          vim.notify("Not a Java file", vim.log.levels.WARN)
          return
        end
        vim.cmd("write")
        local file = vim.fn.expand("%:p")
        local dir = vim.fn.expand("%:p:h")
        local class = vim.fn.expand("%:t:r")
        local escape = vim.fn.shellescape
        local command = "(cd " .. escape(dir)
          .. " && javac -d .build -sourcepath . "
          .. escape(file)
          .. " && java -cp .build "
          .. escape(class)
          .. ")"

        local terminal = assert(Snacks.terminal.get(nil, { cwd = LazyVim.root() }))
        terminal:show():focus()
        vim.api.nvim_chan_send(vim.b[terminal.buf].terminal_job_id, command .. "\n")
        vim.cmd("startinsert")
      end, { desc = "Compile and run current Java file" })

      vim.cmd([[cnoreabbrev <expr> jr (getcmdtype() ==# ':' && getcmdline() ==# 'jr') ? 'Jr' : 'jr']])
    '';

    config.autocmds = ''
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "nix",
        callback = function()
          vim.opt_local.autoindent = true
          vim.opt_local.smartindent = true
        end,
      })

      LazyVim.on_load("mini.pairs", function()
        local function setup_typst_pairs(args)
          MiniPairs.map_buf(args.buf, "i", "$", {
            action = "closeopen",
            pair = "$$",
          })

          vim.keymap.set("i", "<Space>", function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local line = vim.api.nvim_get_current_line()

            if line:sub(col, col + 1) == "$$" then
              return "  <Left>"
            end

            return " "
          end, { buffer = args.buf, expr = true, silent = true })
        end

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "typst",
          callback = setup_typst_pairs,
        })

        if vim.bo.filetype == "typst" then
          setup_typst_pairs({ buf = vim.api.nvim_get_current_buf() })
        end
      end)

    '';
    extraPackages = with pkgs; [
      nixd
      nixfmt
      jdk
      jdt-language-server
      quartoPatched
      clang-tools
      yaml-language-server
    ];

    plugins = {
      typst-preview = ''
        return {
          {
            "chomosuke/typst-preview.nvim",
            opts = {
              open_cmd = "xdg-open '%s' 2>/dev/null",
            },
          },
        }
      '';

      quarto = ''
        return {
          {
            "quarto-dev/quarto-nvim",
            dependencies = {
              "jmbuhr/otter.nvim",
              "nvim-treesitter/nvim-treesitter",
            },
            opts = {},
          },
        }
      '';

      theme = ''
        return {
          {
            "catppuccin/nvim",
            name = "catppuccin",
            opts = {},
          },
          { "0Risotto/rainbow12" },
          {
            "LazyVim/LazyVim",
            opts = { colorscheme = "rainbow12" },
          },
          {
            "f-person/auto-dark-mode.nvim",
            lazy = false,
            opts = {
              set_light_mode = function()
                vim.opt.background = "light"
                vim.cmd.colorscheme("catppuccin-latte")
              end,
              set_dark_mode = function()
                vim.opt.background = "dark"
                vim.cmd.colorscheme("rainbow12")
              end,
            },
          },
        }
      '';
    };
  };
}
