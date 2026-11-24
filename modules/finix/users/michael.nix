{
  config,
  lib,
  pkgs,
  ...
}:
let
  home = config.hjem.users.michael;
  inherit (home.environment) loadEnv profileDirectory;
  shell = pkgs.localZsh;
in
{
  users.users.michael = {
    inherit shell;
    uid = lib.mkDefault 2000;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = map (package: package.man) (builtins.filter (package: package ? man) home.packages);
  };

  hjem.users.michael = {
    imports = [
      ../../hjem/presets/base-common.nix
      ../../hjem/michael.nix
    ];
    packages = [
      pkgs.man
      pkgs.shared-mime-info
    ];
    environment.sessionVariables = {
      MANPATH = lib.mkDefault "${profileDirectory}/share/man:\${MANPATH:-}";
      INFOPATH = lib.mkDefault "${profileDirectory}/share/info:\${INFOPATH:-}";
      XDG_DATA_DIRS = lib.mkDefault "${profileDirectory}/share:/run/current-system/sw/share:\${XDG_DATA_DIRS:-/usr/local/share:/usr/share}";
    };
  };

  environment = {
    shells = [ shell ];
    systemPackages = [ shell ];
    etc = {
      zshenv.text = ''
        export PATH="$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/run/wrappers/bin:/run/current-system/sw/bin''${PATH:+:$PATH}"
        ${lib.optionalString home.enable ''
          if (( EUID == ${toString config.users.users.michael.uid} )); then
            if [[ "''${_NIXOS_HJEM_ENV:-}" != ${loadEnv} ]]; then
              . ${loadEnv}
              export _NIXOS_HJEM_ENV=${loadEnv}
            fi
            fpath=("${profileDirectory}/share/zsh/site-functions" "''${fpath[@]}")
          fi
        ''}
      '';
      zprofile.text = ''
        . /etc/profile
      '';
    };
  };
}
