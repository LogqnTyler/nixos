{
  pkgs,
  inputs,
  ...
}: {
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

    extraPackages = with pkgs; [
      nixd
      alejandra
      jdk
      jdt-language-server
    ];

    plugins = {
      vscode = ''
        return {
          {
            "Mofiqul/vscode.nvim",
            lazy = false,
            priority = 1000,
            config = function()
              vim.o.background = "dark"
              require("vscode").setup({
                transparent = false,
              })
              require("vscode").load()
            end,
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
