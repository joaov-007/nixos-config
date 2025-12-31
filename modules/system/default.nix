{ lib, ... }:

let
  fs = lib.fileset;

  excluded = [
    "default.nix"
  ];

  modules = fs.toList (
    fs.fileFilter (f: f.hasExt "nix" && !(lib.elem f.name excluded) && f.hasExt "hm.nix") (
      fs.recursive ./system
    )
  );
in
{
  imports = modules;
}
