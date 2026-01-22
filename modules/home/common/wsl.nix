{config, ...}: let
  inherit (config) flake;

  # for Git
  extraConfig.user.signingkey = "/home/michael/.ssh/id_ed25519_sk";

  # default location they spawn
  ssh_sock = "/home/michael/.ssh/wsl2-ssh-agent.sock";
in {
  flake.modules.homeManager.wsl = {
    config,
    pkgs,
    lib,
    ...
  }: let
    # WSL uses a different signing key standard
    git = flake.wrappers.mkGit {
      inherit pkgs extraConfig;
    };
  in {
    home = {
      file = {
        ".profile".text = ''
          eval $(wsl2-ssh-agent)
        '';
      };
      packages = [
        pkgs.wsl2-ssh-agent
        (lib.hiPrio git)
      ];
      sessionVariables = {
        SSH_AUTH_SOCK = ssh_sock;
      };
    };

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
