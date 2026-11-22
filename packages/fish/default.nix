# My Fish is a full basic CLI setup that I use, including configs, functions
# and a few common tools
#
# I use this quite regularly anywhere I am in a shell, which includes hosts,
# VMs, Mac, Linux, WSL, etc
{
  pkgs,
  lib,
  configPaths,
  extraRuntimeInputs ? [ ],
}:
let
  runtimeEnv = pkgs.buildEnv {
    name = "fish-runtime-env";
    pathsToLink = [ "/bin" ];
    paths =
      with pkgs;
      [
        bat
        direnv
        eza
        fd
        fzf
        jq
        nix-direnv
        starship
        git
        ripgrep
        delta
        tig
        lazygit
      ]
      ++ extraRuntimeInputs;
  };

  # Every <name>_prompt.fish becomes prompts/<name>.fish for the `prompt`
  # switcher, so adding a prompt is just adding a file
  prompts =
    builtins.readDir configPaths.fish
    |> lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix "_prompt.fish" name)
    |> lib.mapAttrs' (
      name: _:
      lib.nameValuePair "prompts/${lib.removeSuffix "_prompt.fish" name}.fish" (
        configPaths.fish + "/${name}"
      )
    );

  # One store directory laid out like ~/.config/fish. Each attribute of
  # functions.nix becomes functions/<name>.fish so Fish can autoload it.
  fishConfig = pkgs.linkFarm "fish-config" (
    {
      "config.fish" = configPaths.fish + "/config.fish";
    }
    // prompts
    // lib.mapAttrs' (
      name: body: lib.nameValuePair "functions/${name}.fish" (pkgs.writeText "${name}.fish" body)
    ) (import (configPaths.fish + "/functions.nix"))
  );
in
pkgs.symlinkJoin {
  name = "fish";
  paths = [ pkgs.fish ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  postBuild = ''
    wrapProgram $out/bin/fish \
      --add-flag --init-command \
      --add-flag "set -g __prompt_dir ${fishConfig}/prompts; set -p fish_function_path ${fishConfig}/functions; source ${fishConfig}/config.fish" \
      --prefix PATH : ${runtimeEnv}/bin
  '';
  meta.mainProgram = "fish";
  passthru = {
    inherit fishConfig;
    inherit (pkgs.fish) shellPath;
  };
}
