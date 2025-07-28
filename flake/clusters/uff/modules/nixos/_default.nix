{inputs, ...}: {
  imports = [inputs.quadlet-nix.nixosModules.quadlet];
  system = {
    preset = "server";
    stateVersion = "25.11";
  };

  services = {
    pcsd = {
      enable = true;
      enableBinaryCache = true;
    };
    unbound.enable = true;
  };

  virtualisation = {
    podman.enable = true;
  };
}
