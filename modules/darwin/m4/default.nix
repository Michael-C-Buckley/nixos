{config, ...}: let
  flakeConfig = config;
in {
  flake.modules.darwin.m4 = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.custom.hjem) username;
  in {
    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";

    custom.hjem.username = "michabuc";

    hjem.users.${username} = {
      packages = builtins.attrValues {
        inherit
          (flakeConfig.flake.packages.${pkgs.stdenv.hostPlatform.system})
          ns
          helix
          ;

        nushell = flakeConfig.flake.custom.wrappers.mkNushell {
          inherit pkgs;
          env = config.hjem.users.${config.custom.hjem.username}.environment.sessionVariables;
          # Work has a long verbose hostname, I just call it M4 for simplicity
          extraAliases = {nhs = "nh darwin switch /Users/${username}/nixos#m4";};
        };
      };
    };
  };
}
