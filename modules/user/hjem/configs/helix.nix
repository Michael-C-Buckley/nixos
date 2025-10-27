{
  flake.modules.nixos.hjem-helix = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [pkgs.evil-helix];
      rum.programs.helix = {
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
  };
}
