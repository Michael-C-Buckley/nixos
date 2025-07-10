{inputs, ...}: {
  imports = [
    inputs.lix.nixosModules.default
    ./networking
    ./systemd
    ./hardware.nix
  ];

  virtualisation = {
    libvirtd.enable = true;
    incus.enable = true;
  };

  security.tpm2.enable = true;

  system = {
    impermanence.enable = true;
    builder.enable = true;
    boot.uuid = "D8CD-79D6";
    preset = "server";
    stateVersion = "24.05";
    zfs.enable = true;
  };
}
