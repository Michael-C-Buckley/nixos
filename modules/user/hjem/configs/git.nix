{
  flake.modules.nixos.hjem-git = {
    self,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael.rum.programs.git = {
      enable = true;
      integrations.difftastic = {
        enable = true;
      };
      settings = {
        user = {
          name = "Michael Buckley";
          email = "michaelcbuckley@proton.me";
        };
        diff.sops.textconv = "${lib.getExe pkgs.sops} -d";
        advice.defaultBranchName = false;
        commit = {
          # This custom script dynamically detects and selects my signing keys
          program = lib.getExe self.packages.${pkgs.system}.gpg-custom;
          gpgsign = true;
        };
        core.editor = "nvim";
        color = {
          ui = true;
          diff = "auto";
          status = "auto";
          branch = "auto";
          interactive = "auto";
        };
        http.postBuffer = 157286400;
        merge.conflictstyle = "zdiff3";
      };
    };
  };
}
