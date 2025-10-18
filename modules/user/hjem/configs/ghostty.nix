{
  flake.modules.nixos.hjem-ghostty = {
    hjem.users.michael.rum.programs.ghostty = {
      enable = true;
      settings = {
        theme = "wombat";
        background = "#000000";
        font-size = "11";
        font-family = "Cascadia Code NF";

        background-opacity = "0.5";
        cursor-opacity = "0.6";
        cursor-color = "#44A3A3";

        window-theme = "system";
        window-decoration = "false";
      };
    };
  };
}
