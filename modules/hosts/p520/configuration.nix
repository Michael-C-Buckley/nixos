{inputs, ...}: {
  flake.modules.nixos.p520 = {
    imports = with inputs.self.modules.nixos; [
      serverPreset
      containerlab
    ];

    virtualisation = {
      libvirtd.enable = true;
      podman.enable = true;
    };

    system = {
      stateVersion = "25.11";
    };

    # Allows vscode remote connections to just work
    programs.nix-ld.enable = true;

    hjem.users.michael.rum.programs.git.settings.user.signingKey = "6F749AA097DC10EA46FE0ECD22CDD3676227046F!";
  };
}
