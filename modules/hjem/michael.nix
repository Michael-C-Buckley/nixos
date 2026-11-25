{ config, lib, ... }:
{
  user = "michael";
  directory = "/home/michael";
  environment.sessionVariables.NH_FLAKE = lib.mkDefault "\${NH_FLAKE:-${config.directory}/.config/flake}";
}
