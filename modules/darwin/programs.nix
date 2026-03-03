{
  flake.modules.darwin.default = {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true; # Just for the default shell
      };
    };
  };
}
