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
in {
  imports = [
    inputs.lazyvim.homeManagerModules.default
  ];

  programs.lazyvim = {
    enable = true;

    extras.lang.nix.enable = true;

    extras.lang.typst = {
      enable = true;
      installDependencies = true; # Install tinymist
    };

    extras.lang.python = {
      enable = true;
      installDependencies = true; # Install ruff
      installRuntimeDependencies = true; # Install python3
    };

    extras.lang.java = {
      enable = true;
      installDependencies = true;
      installRuntimeDependencies = true;
    };

    config.options = ''
      vim.opt.background = "light"
      vim.opt.mouse = ""
      '';

    config.autocmds = ''
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
      alejandra
      jdk
      jdt-language-server
      quartoPatched
    ];

    plugins = {
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

      vscode = ''
        return {
          {
            "Mofiqul/vscode.nvim",
            lazy = false,
            priority = 1000,
            opts = {
              style = "light",
              transparent = false,
            },
          },
          {
            "LazyVim/LazyVim",
            opts = {
              colorscheme = "vscode",
            },
          },
        }
      '';
    };
  };
}
