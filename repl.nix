# Preload the Repl with various aliases and functions, see for more info:
# https://bmcgee.ie/posts/2023/01/nix-and-its-slow-feedback-loop/#how-you-should-use-the-repl
# Special thanks to Iynaix for the inspiration:
# https://github.com/iynaix/dotfiles/blob/main/repl.nix
let
  inherit (builtins) attrNames getFlake listToAttrs;
  flake = getFlake (toString ./.);

  hosts = attrNames flake.nixosConfigurations;

  # Split and get the host since I always use my `name@` in the format
  homes =
    map (
      x: builtins.elemAt (builtins.split "@" x) 2
    )
    (attrNames flake.homeConfigurations);
in
  rec {
    inherit (flake) inputs lib self;
    inherit (flake.inputs) nixpkgs;
    inherit flake;

    # Aliases to quickly get the configs of my defined systems
    c = listToAttrs (map (name: {
        inherit name;
        value = flake.nixosConfigurations.${name}.config;
      })
      hosts);

    # Aliases to quickly get my personal hjem configs on my hosts
    ch = listToAttrs (map (name: {
        inherit name;
        value = flake.nixosConfigurations.${name}.config.hjem.users.michael;
      })
      hosts);

    hm = listToAttrs (map (name: {
        inherit name;
        value = flake.homeConfigurations."michael@${name}".config;
      })
      homes);

    # Aliases for impermance
    cip = listToAttrs (map (name: {
        inherit name;
        value = flake.nixosConfigurations.${name}.config.environment.persistence."/persist";
      })
      hosts);
    cic = listToAttrs (map (name: {
        inherit name;
        value = flake.nixosConfigurations.${name}.config.environment.persistence."/cache";
      })
      hosts);
  }
  // flake
