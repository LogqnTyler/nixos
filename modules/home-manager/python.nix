{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    jetbrains.pycharm
    uv
  ];
}
