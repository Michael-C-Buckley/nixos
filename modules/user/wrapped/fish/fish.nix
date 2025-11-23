{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    config = import ./_config.nix {inherit pkgs lib;};
  in {
    packages.fish = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.fish;
      runtimeInputs = with pkgs; [
        bat
        eza
        fd
        fzf
        jq
        starship
      ];
      flagSeparator = "=";
      flags = {
        "--init-command" = "source ${config}";
      };
      env = {
        NH_FLAKE = "/home/michael/nixos";
      };
      passthru = {
        shellPath = "/bin/fish";
      };
    };
  };
}
