{lib, ...}:
{
  imports = 
    let
      dir = ./.;
      isModule = name: type:
        type == "regular"
        && lib.hasSuffix ".nix" name
        && name != "default.nix";
    in
      map (name: dir + "/${name}")
        (builtins.attrNames (lib.filterAttrs isModule (builtins.readDir dir)));
}
