{
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
      # Standard SSH agent for normal activity when passing yubikey through USBIPD
      ssh-agent = {
        unit = {
          Description = "SSH Agent Socket";
          After = "network.target";
          ConditionUser = "!root";
        };
        Service = {
          ExecStartPre = "${pkgs.coreutils}/bin/rm -f /home/michael/.ssh/ssh-agent.sock";
          ExecStart = "${pkgs.openssh}/bin/ssh-agent -a /home/michael/.ssh/ssh-agent.sock";
          Type = "oneshot";
          RemainAfterExit = true;
        };
        Install.WantedBy = ["default.target"];
      };
      # WSL2 agent for when not passing a yubikey
      wsl2-ssh-agent = {
        unit = {
          Description = "WSL2 SSH Agent Bridge";
          After = "network.target";
          ConditionUser = "!root";
        };
        Service = {
          ExecStartPre = "${pkgs.coreutils}/bin/rm -f /home/michael/.ssh/wsl2-ssh-agent.sock";
          ExecStart = "${lib.getExe pkgs.wsl2-ssh-agent} --verbose --foreground --socket=/home/michael/.ssh/wsl2-ssh-agent.sock";
          Restart = "on-failure";
        };
        Install.WantedBy = ["default.target"];
      };
    };
  };
}
