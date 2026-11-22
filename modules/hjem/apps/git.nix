{ configPaths, pkgs, ... }:
let
  helper = pkgs.callPackage ../../../packages/git/git-credential-sops.nix { inherit configPaths; };
in
{
  imports = [ ../runtime.nix ];

  packages = [ helper ];
  files.".local/bin/git-credential-sops".source = "${helper}/bin/git-credential-sops";
  xdg.config.files = {
    "git/config".source = configPaths.git + "/config";
    "git/ignore".source = configPaths.git + "/ignore";
  };
}
