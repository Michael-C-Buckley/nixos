{
  flake.modules.nixos.hjem-fastfetch = {
    hjem.users.michael.files = {
      ".config/fastfetch/config.jsonc".source = ./config.jsonc;
    };
  };
}
