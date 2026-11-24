{ lib, modules, ... }:
{
  imports = [ modules.limine ];

  programs.limine = {
    enable = true;
    efiSupport = true;
    biosSupport = false;
    maxGenerations = lib.mkDefault 15;
  };
}
