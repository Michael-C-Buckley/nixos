{
  lib,
  modules,
  pkgs,
  ...
}:
{
  imports = [
    ../hjem
    ../users/michael.nix
    modules.bash
    modules.getty
    modules.nix-daemon
    modules.sudo
    modules.sysklogd
  ];

  time.timeZone = "America/New_York";

  programs = {
    bash.enable = true;
    sudo.enable = true;
  };

  services = {
    getty.enable = true;
    sysklogd.enable = true;
    nix-daemon = {
      enable = true;
      package = lib.mkDefault pkgs.nixVersions.latest;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        trusted-users = [ "@wheel" ];
      };
    };
  };

  finit.tasks.hjem-prepare.conditions = [ "service/nix-daemon/ready" ];
}
