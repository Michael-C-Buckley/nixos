{config, ...}: {
  flake.modules.nixos.p520 = {
    imports = with config.flake.modules.nixos; [
      serverPreset
      containerlab
      k3s
    ];

    virtualisation = {
      libvirtd.enable = true;
    };

    system.stateVersion = "25.11";

    # Allows vscode remote connections to just work
    programs.nix-ld.enable = true;
  };
}
