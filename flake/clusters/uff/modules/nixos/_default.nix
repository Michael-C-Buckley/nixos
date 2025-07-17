{inputs, ...}: {
  imports = [inputs.quadlet-nix.nixosModules.quadlet];
  system = {
    preset = "server";
    stateVersion = "25.11";
    impermanence.enable = true;
    zfs.enable = true;
  };

  services = {
    pcsd = {
      enable = true;
      enableBinaryCache = true;
    };
    unbound.enable = true;
  };

  virtualisation = {
    incus.enable = true;
    podman.enable = true;
  };
}
