{config, ...}: let
  inherit (config) flake;

  # for Git

  # default location they spawn
  ssh_sock = "/home/michael/.ssh/wsl2-ssh-agent.sock";
in {
  flake.modules.homeManager.wsl = {
    config,
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      wsl2-ssh-agent
      git
    ];

    systemd.user.services = lib.mkIf config.custom.systemd.use {
      wsl2-ssh-agent = {
        unit = {
          Description = "WSL2 SSH Agent Bridge";
          After = "network.target";
          ConditionUser = "!root";
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.wsl2-ssh-agent} --verbose --foreground --socket=${ssh_sock}";
          Restart = "on-failure";
        };
        Install.WantedBy = ["default.target"];
      };
    };
  };
}
