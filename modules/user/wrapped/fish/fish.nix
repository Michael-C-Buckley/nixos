{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.fish = config.flake.wrappers.mkFish {
      inherit pkgs;
      env = {NH_FLAKE = "/home/michael/nixos";};
    };
  };
  flake.wrappers.mkFish = {
    pkgs,
    env ? {},
    extraConfig ? "",
    extraAliases ? {},
    extraRuntimeInputs ? [],
  }: let
    buildInputs = with pkgs;
      [
        bat
        direnv
        eza
        fd
        fzf
        jq
        nix-direnv
        starship
        ripgrep
      ]
      ++ extraRuntimeInputs;
  in
    pkgs.symlinkJoin {
      name = "fish";
      paths = [pkgs.fish];
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/fish \
          --add-flags "--init-command 'source ${import ./_config.nix {inherit pkgs env extraConfig extraAliases;}}'" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
      passthru.shellPath = "/bin/fish";
    };
}
