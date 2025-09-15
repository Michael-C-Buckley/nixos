{lib, ...}: let
  inherit (lib) mkForce;
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
    aliases = {
      # Bat replacements
      cat = mkForce "bat -p";
      # Eza replacements
      ls = mkForce "eza";
      ll = mkForce "eza -la -g --icons";
      lt = mkForce "eza --tree --level=2 --icons";
      tree = mkForce "eza --tree";
    };

    functions = {
      # Use FZF to navigate to a folder matching folders or filenames
      fcd = ''
        function fcd
            set -l selected_path (find . | fzf --height 40% --reverse)

            if test -n "$selected_path"
                if test -d "$selected_path"
                    cd "$selected_path"
                else
                    cd (dirname "$selected_path")
                end
            end
        end
      '';
      # Passthrough of FRR show command
      show = ''
        function show
            sudo vtysh -c "show $argv"
        end
      '';
    };
  };
}
