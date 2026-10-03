# Nixos-container just for moderate containment of agents
# it is not as strong as a VM but a lot lighter and more convenient
# Mainly provides barriers on host system and filesystem access
# Allows bots to have "full access" and limit what they can actually touch
{
  self,
  inputs,
  config,
  ...
}:
let
  sshPort = 1122;
  host = "${self}/modules/nixos";

  m = "/home/michael";
in
{
  # The container will fail if the host doesn't have the directories.
  systemd.tmpfiles.rules = [
    "d /home/michael/Projects 0755 michael users -"
    "d /home/michael/.codex 0755 michael users"
  ];

  networking.firewall.allowedTCPPorts = [ sshPort ];

  containers.agentbox = {
    autoStart = true;
    ephemeral = false;

    # Sharing the host network keeps DNS, package downloads, and API access
    # simple. Use a private network plus NAT if stronger network isolation is
    # more important than convenience.
    privateNetwork = false;

    bindMounts = {
      # My general work directories
      "${m}/Projects" = {
        hostPath = "${m}/Projects";
        isReadOnly = false;
      };
      # Make my SSH pubkeys available
      "/etc/ssh/authorized_keys.d/michael" = {
        hostPath = "/etc/ssh/authorized_keys.d/michael";
        isReadOnly = true;
      };
      # Copy my configs from my host for zsh
      "${m}/.config/rootbeer" = {
        hostPath = "${m}/.config/rootbeer";
        isReadOnly = true;
      };
      "${m}/.config/zsh" = {
        hostPath = "${m}/.config/zsh";
        isReadOnly = true;
      };
      "${m}/.zshenv" = {
        hostPath = "${m}/.zshenv";
        isReadOnly = true;
      };
    };

    specialArgs = { inherit self inputs; };

    config = { pkgs, ... }: {
      # Reuse sections I want to mimic from my host
      imports = [
        "${host}/base.nix"
      ];
      networking.hostName = "agentbox";

      services.openssh = {
        startWhenNeeded = false;
        ports = [ sshPort ];
      };

      environment.systemPackages = with pkgs; [
        codex
        opencode
        pi-coding-agent
        bubblewrap
        herdr
        tmux
        uv
        wget
      ];

      system = {
        inherit (config.system) stateVersion;
      };
    };
  };
}
