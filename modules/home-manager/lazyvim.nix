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
  };
}
