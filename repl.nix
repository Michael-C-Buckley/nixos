# Preload the Repl with various aliases and functions, see for more info:
# https://bmcgee.ie/posts/2023/01/nix-and-its-slow-feedback-loop/#how-you-should-use-the-repl
# Special thanks to Iynaix for the inspiration:
# https://github.com/iynaix/dotfiles/blob/main/repl.nix
let
  inherit (builtins) attrNames getFlake listToAttrs map;
  flake = getFlake (toString ./.);

  hosts = attrNames flake.nixosConfigurations;

  # Pre-load the most commonly used pkgs I reference
  p = import flake.inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  # Split and get the host since I always use my `name@` in the format
  homes =
    map (x: builtins.elemAt (builtins.split "@" x) 2)
    (attrNames flake.homeConfigurations);

  # Helper to create an attrset from a list, mapping each name to a derived value
  mapToAttrs = list: f:
    listToAttrs (map (name: {
        inherit name;
        value = f name;
      })
      list);

  # Shorthand for accessing nixosConfigurations
  nixosCfg = name: flake.nixosConfigurations.${name}.config;
in
  rec {
    inherit (flake) inputs lib self;
    inherit (flake.inputs) nixpkgs;
    inherit flake p;

    # Aliases to quickly get the configs of my defined systems
    c = mapToAttrs hosts nixosCfg;

    # Aliases to quickly get my personal hjem configs on my hosts
    ch = mapToAttrs hosts (name: (nixosCfg name).hjem.users.michael);

    # Home aliases by just hostname for repl simplicity
    hm = mapToAttrs homes (name: flake.homeConfigurations."michael@${name}".config);

    # Aliases for impermanence
    cip = mapToAttrs hosts (name: (nixosCfg name).environment.persistence."/persist");
    cic = mapToAttrs hosts (name: (nixosCfg name).environment.persistence."/cache");
  }
  // flake
