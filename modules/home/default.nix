{ lib, ... }:

let
  fs = lib.fileset;

  excluded = [
    "default.nix"
  ];

  modules = fs.toList (
    fs.fileFilter (f: f.hasExt "nix" && !(lib.elem f.name excluded)) (fs.recursive ./modules)
  );
in
{
  imports = modules;
}
