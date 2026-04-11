{config, ...}: {
  flake.modules.darwin.m4 = {pkgs, ...}: {
    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";

    hjem.users.michael = {
      packages = builtins.attrValues {
        inherit
          (config.flake.packages.${pkgs.stdenv.hostPlatform.system})
          ns
          helix
          ;

        nushell = config.flake.custom.wrappers.mkNushell {
          inherit pkgs;
          # Work has a long verbose hostname, I just call it M4 for simplicity
          extraAliases = {nhs = "nh darwin switch /Users/michael/nixos#m4";};
        };
      };
    };
  };
}
