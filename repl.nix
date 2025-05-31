# Preload the Repl with various aliases and functions, see for more info:
# https://bmcgee.ie/posts/2023/01/nix-and-its-slow-feedback-loop/#how-you-should-use-the-repl
# Special thanks to Iynaix for the inspiration:
# https://github.com/iynaix/dotfiles/blob/main/repl.nix
let
  inherit (builtins) getFlake;
  flake = getFlake (toString ./.);

  hosts = builtins.attrNames flake.nixosConfigurations;
in
  rec {
    inherit (flake) inputs lib self;
    inherit (flake.inputs) nixpkgs;
    inherit flake;

    # Aliases to quickly get the configs of my defined systems
    c = builtins.listToAttrs (map (name: {
        inherit name;
        value = flake.nixosConfigurations.${name}.config;
      })
      hosts);

    # Aliases to quickly get my personal hjem configs on my hosts
    ch = builtins.listToAttrs (map (name: {
        inherit name;
        value = flake.nixosConfigurations.${name}.config.hjem.users.michael;
      })
      hosts);
  }
  // flake
