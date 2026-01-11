{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = dev.home.git;
in
{
  options.dev.home.git = { };
  config = { };
}
