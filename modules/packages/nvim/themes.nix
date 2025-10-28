# Some additional themes for Nvim I like
{
  perSystem = {pkgs, ...}: {
    packages = {
      thorn-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "thorn-nvim";
        version = "28eef8c";

        src = pkgs.fetchFromGitHub {
          owner = "jpwol";
          repo = "thorn.nvim";
          rev = "28eef8c6a70237175968811327dacf9b7535eb7a";
          hash = "sha256-ykLOE7mLoU8OpYLZoIIdXHvNvKFvl8ai0EGSzzocgFY=";
        };
      };

      kanso-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "kanso-nvim";
        version = "c2525eb";

        src = pkgs.fetchFromGitHub {
          owner = "webhooked";
          repo = "kanso.nvim";
          rev = "c2525ebafa73c1860301716d9a17e3f07f5038b8";
          hash = "sha256-p2XUgHsmm+iCBM4sJHxVJvCbwXyHMT3RZ9GTXd32uPo=";
        };
      };
    };
  };
}
