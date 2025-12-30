# Not technically a DE/WM but a Quickshell theme I'm just living here
# Currently largely handled by my wrapped package for the actual package needs
# This exists for the system integrations as needed
{
  flake.modules.nixos.noctalia = {
    custom.impermanence.persist.user.directories = [
      ".config/noctalia"
    ];
    # TODO: create custom service unit
  };
}
