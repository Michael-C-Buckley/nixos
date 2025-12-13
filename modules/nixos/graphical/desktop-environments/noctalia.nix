# Not technically a DE/WM but a Quickshell theme I'm just living here
# Currently largely handled by my wrapped package for the actual package needs
# This exists for the system integrations as needed
{inputs, ...}: {
  flake.modules.nixos.noctalia = {pkgs, ...}: {
    imports = [inputs.noctalia.nixosModules.default];

    custom.impermanence.persist.user.directories = [
      ".config/noctalia"
    ];

    # TODO: manage the shell via systemd user
    # current wrapped version is spawned imperatively
    # by niri on launch
    services.noctalia-shell = {
      enable = false;
      package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia;
    };
  };
}
