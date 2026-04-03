{config, ...}: {
  flake.modules.darwin.nix = {pkgs, ...}: {
    imports = [config.flake.modules.generic.nix];
    nix = {
      package = pkgs.nixVersions.latest;
      settings = {
        trusted-users = ["root" "@admin"];
        allowed-users = ["root" "@admin"];
      };
    };
  };
}
