{
  self,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  hjem.users.michael = {
    enable = true;
    files = {
      ".zshrc".source = "${self}/configs/zsh/zshrc";
    };
    xdg.config.files = {
      "git/config".source = self.packages.${system}.git-config;
      "rush/config.rush".source = "${self}/configs/rush/config.rush";
      "starship/config.toml".source = "${self}/configs/starship.toml";
    };
  };
  users.users.michael = {
    shell = pkgs.zsh;
    uid = 2000;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$aQHYzxKJC/yStH4U$1kAsuU3GW9gn2ANJ5GzRgAVnExqlb3OfBjKGddjnScI05DuttGE6WmuUyhT7CVBJmNliyE4mquEovPbOxRyev0";
    isNormalUser = true;
  };
}
