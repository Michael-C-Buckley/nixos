{lib, ...}: {
  flake.nixosModules = lib.genAttrs [
    "graphical"
    "hardware"
    "network"
    "packageSets"
    "packages"
    "presets"
    "programs"
    "security"
    "services"
    "storage"
    "system"
    "virtualization"
  ] (name: {imports = [../flake/nixos/modules/${name}];});
}
