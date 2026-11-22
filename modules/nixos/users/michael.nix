{
  config,
  configPaths,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  home = config.hjem.users.michael or null;
  useHjemEnv = home != null && home.enable;
  uid = toString config.users.users.michael.uid;
  inherit (home.environment) loadEnv profileDirectory;

  # Each shell loads hjem's session variables once per process tree, marking
  # that with _NIXOS_HJEM_ENV so nested shells of either kind skip it
  hjemZshenv = lib.optionalString useHjemEnv ''
    if (( EUID == ${uid} )); then
      if [[ "''${_NIXOS_HJEM_ENV:-}" != ${loadEnv} ]]; then
        . ${loadEnv}
        export _NIXOS_HJEM_ENV=${loadEnv}
      fi
      fpath=("${profileDirectory}/share/zsh/site-functions" "''${fpath[@]}")
    fi
  '';

  # loadEnv is POSIX sh with expansions such as ${PATH}, so Fish imports it
  # through foreign-env, as the NixOS fish module does for its own environment
  hjemFishInit = lib.optionalString useHjemEnv ''
    if test "$_NIXOS_HJEM_ENV" != ${loadEnv}; and test (id -u) -eq ${uid}
      set fish_function_path ${pkgs.fishPlugins.foreign-env}/share/fish/vendor_functions.d $fish_function_path
      fenv source ${loadEnv} >/dev/null
      set -e fish_function_path[1]
      set -gx _NIXOS_HJEM_ENV ${loadEnv}
    end
  '';

  zsh = pkgs.callPackage ../../../packages/zsh { inherit inputs configPaths; };
  fish = pkgs.callPackage ../../../packages/fish { inherit configPaths; };
in
{
  # Zsh stays installed and configured; Fish is the login shell
  programs = {
    zsh = {
      enable = true;
      shellInit = hjemZshenv;
    };
    fish = {
      enable = true;
      shellInit = hjemFishInit;
    };
  };
  environment.shells = map lib.getExe [
    zsh
    fish
  ];

  users.users.michael = {
    shell = lib.getExe fish;
    packages = [
      zsh
      fish
    ];
    uid = lib.mkDefault 1000;
    extraGroups = [ "wheel" ];
    isNormalUser = true;
  };
}
