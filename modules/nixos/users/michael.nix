{
  pkgs,
  ...
}:
{
  users.users.michael = {
    shell = pkgs.zsh;
    uid = 2000;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$aQHYzxKJC/yStH4U$1kAsuU3GW9gn2ANJ5GzRgAVnExqlb3OfBjKGddjnScI05DuttGE6WmuUyhT7CVBJmNliyE4mquEovPbOxRyev0";
    isNormalUser = true;
  };
}
