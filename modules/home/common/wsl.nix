{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.wsl = {
    config,
    pkgs,
    lib,
    ...
  }: let
    # WSL uses a different signing key standard
    git = flake.wrappers.mkGit {inherit pkgs;};
  in {
    home.packages = [
      pkgs.wsl2-ssh-agent
      (lib.hiPrio git)
    ];

    systemd.user.services = lib.mkIf config.custom.systemd.use {
      ssh-agent = {
        unit = {
          Description = "SSH Agent Socket";
          After = "network.target";
          ConditionUser = "!root";
        };
        Service = {
          ExecStart = "${pkgs.openssh}/bin/ssh-agent -a /home/michael/.ssh/ssh-agent.sock";
          Type = "oneshot";
          RemainAfterExit = true;
        };
        Install.WantedBy = ["default.target"];
      };
      wsl2-ssh-agent = {
        unit = {
          Description = "WSL2 SSH Agent Bridge";
          After = "network.target";
          ConditionUser = "!root";
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.wsl2-ssh-agent} --verbose --foreground --socket=/home/michael/.ssh/wsl2-ssh-agent.sock";
          Restart = "on-failure";
        };
        Install.WantedBy = ["default.target"];
      };
    };
  };
}
