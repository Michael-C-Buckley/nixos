{config, ...}: let
  inherit (config) flake;

  # for Git
  extraConfig.user.signingkey = "/home/michael/.ssh/id_ed25519_sk";
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
      files.".config/git/config".source = flake.wrappers.mkGitConfig {inherit pkgs extraConfig;};
      packages = [
        pkgs.wsl2-ssh-agent
        (lib.hiPrio git)
      ];
    };

    systemd.user.services = lib.mkIf config.custom.systemd.use {
      wsl2-ssh-agent = {
        unit = {
          Description = "WSL2 SSH Agent Bridge";
          After = "network.target";
          ConditionUser = "!root";
        };
        Service = {
          ExecStart = "{lib.getExe pkgs.wsl2-ssh-agent} --verbose --foreground --socket=%t/wsl2-ssh-agent.sock";
          Restart = "on-failure";
        };
        Install.WantedBy = "default.target";
      };
    };
  };
}
