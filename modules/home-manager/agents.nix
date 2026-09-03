{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    # Claude Code from the sadjow/claude-code-nix flake (not nixpkgs).
    # `inputs.claude-code` is the flake; `.packages` is indexed by system
    # string, so we pick the entry matching the machine we're building for.
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default

    # opencode ships in nixpkgs, so we just take it from the shared `pkgs`.
    pkgs.opencode
  ];
}
