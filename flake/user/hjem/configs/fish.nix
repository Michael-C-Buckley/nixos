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
      if status is-interactive
          # Remove the welcome/help greeting
          set -U fish_greeting

          # Starship
          function starship_transient_prompt_func
              starship module character
          end
          starship init fish | source
          enable_transience

          # Common other shell elements being reused
          source ~/.config/shells/environment.sh
      end
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
