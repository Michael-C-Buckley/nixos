{
  config,
  configPaths,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.environment) loadEnv;
  inherit (configPaths) fish;
  # Older setups may already have a symlink at fish/functions.
  functionDirectory = "hjem-functions";
  prompts =
    builtins.readDir fish
    |> lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix "_prompt.fish" name)
    |> lib.mapAttrs' (
      name: _:
      lib.nameValuePair "fish/prompts/${lib.removeSuffix "_prompt.fish" name}.fish" {
        source = fish + "/${name}";
      }
    );
  functions = lib.mapAttrs' (
    name: body: lib.nameValuePair "fish/${functionDirectory}/${name}.fish" { text = body; }
  ) (import (fish + "/functions.nix"));
in
{
  imports = [ ../runtime.nix ];

  packages = [ pkgs.fish ];
  xdg.config.files = {
    "fish/config.fish".source = fish + "/config.fish";
    "fish/conf.d/10-hjem.fish".text = ''
      # Hjem's environment script uses POSIX shell syntax.
      if test "$_NIXOS_HJEM_ENV" != ${loadEnv}
        set -l inherited_ssh_auth_sock "$SSH_AUTH_SOCK"
        set -gp fish_function_path ${pkgs.fishPlugins.foreign-env}/share/fish/vendor_functions.d
        fenv source ${loadEnv} >/dev/null
        and set -gx _NIXOS_HJEM_ENV ${loadEnv}
        set -eg fish_function_path[1]
        if test -S "$inherited_ssh_auth_sock"
          set -gx SSH_AUTH_SOCK "$inherited_ssh_auth_sock"
        end
      end

      set -gp fish_function_path "$__fish_config_dir/${functionDirectory}"
      set -g __prompt_dir "$__fish_config_dir/prompts"
      set -q SHELL_COMMON_DIR; or set -g SHELL_COMMON_DIR ${configPaths.shell}
    '';
  }
  // prompts
  // functions;
}
