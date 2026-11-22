{
  config,
  configPaths,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  hjemZshenv =
    config:
    let
      home = config.hjem.users.michael or null;
    in
    lib.optionalString (home != null && home.enable) ''
      if (( EUID == ${toString config.users.users.michael.uid} )); then
        if [[ "''${_NIXOS_HJEM_ENV:-}" != ${home.environment.loadEnv} ]]; then
          . ${home.environment.loadEnv}
          export _NIXOS_HJEM_ENV=${home.environment.loadEnv}
        fi
        fpath=("${home.environment.profileDirectory}/share/zsh/site-functions" "''${fpath[@]}")
      fi
    '';
  zsh = pkgs.callPackage ../../../packages/zsh { inherit inputs configPaths; };
  shell = lib.getExe zsh;
in
{
  programs.zsh = {
    enable = true;
    shellInit = hjemZshenv config;
  };
  environment.shells = [ shell ];

  users.users.michael = {
    inherit shell;
    packages = [ zsh ];
    uid = lib.mkDefault 1000;
    extraGroups = [ "wheel" ];
    isNormalUser = true;
  };
}
