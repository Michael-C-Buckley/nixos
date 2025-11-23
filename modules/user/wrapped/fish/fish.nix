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
    extraRuntimeInputs ? [],
    extraFlags ? {"--init-command" = "source ${import ./_config.nix {inherit pkgs;}}";},
    extraWrapperArgs ? {},
  }:
    inputs.wrappers.lib.wrapPackage (pkgs.lib.recursiveUpdate {
        inherit pkgs env;
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
            "--init-command" = "source ${import ./_config.nix {inherit pkgs;}}";
          }
          // extraFlags;
        passthru = {shellPath = "/bin/fish";};
      }
      extraWrapperArgs);
}
