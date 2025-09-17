{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
  inherit (pkgs) fd fzf fishPlugins;
in {
  hjem.users.michael.rum.programs.fish = {
    enable = true;
    config = ''
      set -U fish_greeting
      source ~/.config/shells/environment.sh
    '';

    plugins = {
      inherit (fishPlugins) fzf-fish forgit;
    };

    functions = {
      # Use FZF to navigate to a folder matching folders or filenames
      fcd = ''
        set -l selected_path (${getExe fd} . | ${getExe fzf} --height 40% --reverse)

        if test -n "$selected_path"
            if test -d "$selected_path"
                cd "$selected_path"
            else
                cd (dirname "$selected_path")
            end
        end
      '';
      # Passthrough of FRR show command
      show = ''
        sudo vtysh -c "show $argv"
      '';
    };
  };
}
