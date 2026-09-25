{
  self,
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  hjem.users.michael = {
    enable = true;
    xdg.config.files = {
      "rush/config.rush".source = "${self}/packages/rush/config.rush";
      "git/config".source = self.packages.${system}.git-config;
    };
  };
  users.users.michael = {
    shell = inputs.rush.packages.${system}.rush-shell;
    uid = 2000;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$aQHYzxKJC/yStH4U$1kAsuU3GW9gn2ANJ5GzRgAVnExqlb3OfBjKGddjnScI05DuttGE6WmuUyhT7CVBJmNliyE4mquEovPbOxRyev0";
    isNormalUser = true;
  };
}
