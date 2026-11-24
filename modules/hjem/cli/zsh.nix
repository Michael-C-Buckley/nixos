{
  config,
  configPaths,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.environment) loadEnv profileDirectory genericLinux;
  zshenv = ''
    if [[ "''${_NIXOS_HJEM_ENV:-}" != ${loadEnv} ]]; then
      . ${loadEnv}
      export _NIXOS_HJEM_ENV=${loadEnv}
    fi
    source ${configPaths.zsh + "/zshenv"}
  '';
in
{
  imports = [ ./starship.nix ];

  packages = [ pkgs.zsh ];
  files.".zshenv".text = zshenv;
  xdg.config.files = {
    "zsh/.zshenv".text = zshenv;
    "zsh/.zshrc".text = ''
      : ''${ZSH_PLUGIN_DIR=${pkgs.localZsh.plugins}}
      : ''${SHELL_COMMON_DIR=${configPaths.shell}}
      fpath=(${profileDirectory}/share/zsh/site-functions $fpath)
    ''
    + lib.optionalString genericLinux ''
      # Nix's Zsh does not search the distribution's completion directories.
      fpath+=(/usr/share/zsh/site-functions(/-N) /usr/share/zsh/functions/**/*(/-N) /usr/share/zsh/vendor-completions(/-N) /usr/share/zsh/vendor-functions(/-N))
    ''
    + ''
      source ${configPaths.zsh + "/zshrc"}
    '';
    "zsh/.zprofile".source = configPaths.zsh + "/zprofile";
  };
}
