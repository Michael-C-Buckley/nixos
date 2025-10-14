{
  flake.modules.nixos.hjem-helix = {
    hjem.users.michael.rum.programs.helix = {
      enable = true;
      settings = {
        theme = "ayu-dark";
        editor.cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };
}
