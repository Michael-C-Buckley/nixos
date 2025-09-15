{lib, ...}: {
  hjem.users.michael.rum.programs.git = {
    enable = true;
    integrations.difftastic = {
      enable = true;
    };
    settings = {
      user = {
        name = "Michael Buckley";
        email = "michaelcbuckley@proton.me";
        signingKey = lib.mkDefault "483864BF916E149C4F57E2371A0163427F977C33!";
      };
      commit.program = "gpg";
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
}
