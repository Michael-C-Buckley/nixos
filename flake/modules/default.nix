{
  inputs,
  system,
  ...
}: let
  inherit (inputs.home-manager.packages.${system}) home-manager;
in {
  imports = [
    # keep-sorted start
    ./graphical
    ./hardware
    ./network
    ./packageSets
    ./packages
    ./presets
    ./programs
    ./security
    ./storage
    ./system
    ./virtualization
    # keep-sorted end
  ];

  # Add Home-manager to the path
  environment.systemPackages = [home-manager];
}
