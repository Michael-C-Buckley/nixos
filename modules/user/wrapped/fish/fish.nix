{
  config,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    # Default package with baseline config
    packages.fish = config.flake.wrappers.mkFish {
      inherit pkgs;
      env = {NH_FLAKE = "/home/michael/nixos";};
    };
  };

  flake.wrappers.mkFish = {
    pkgs,
    env,
    extraConfig ? "",
    extraAliases ? {},
    extraRuntimeInputs ? [],
    extraFlags ? {},
    extraWrapperArgs ? {},
  }:
    inputs.wrappers.lib.wrapPackage (pkgs.lib.recursiveUpdate {
        inherit pkgs;
        package = pkgs.fish;
        flagSeparator = "=";
        runtimeInputs = with pkgs;
          [
            bat
            eza
            fd
            fzf
            jq
            starship
            ripgrep
          ]
          ++ extraRuntimeInputs;
        flags =
          {
            "--init-command" = "source ${import ./_config.nix {inherit pkgs env extraConfig extraAliases;}}";
          }
          // extraFlags;
        passthru = {
          shellPath = "/bin/fish";
          # Make NixOS recognize this as a valid shell
          meta = pkgs.fish.meta or {};
        };
      }
      extraWrapperArgs);
}
