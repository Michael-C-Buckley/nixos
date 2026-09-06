{ config, ... }:
let
  sshPort = 1122;
  inherit (config.users.users.michael.openssh.authorizedKeys) keys;
  extraKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHG8H6bGZzW1jggJ2PNFWHa+CCK4iTfqsEi4KeeewlB michael@x570"
  ];
in
{
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
      "/home/michael/Projects" = {
        hostPath = "/home/michael/Projects";
        isReadOnly = false;
      };
    };

    config = { pkgs, ... }: {
      networking.hostName = "agentbox";
      # Keep the same UID as the host so files created in the bind mount have
      # the right owner on both sides.
      users.users.michael = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        home = "/home/michael";
        createHome = true;
        openssh.authorizedKeys.keys = keys ++ extraKeys;
        inherit (config.users.users.michael) shell uid;
      };

      nix = {
        package = pkgs.nixVersions.latest;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "michael"
          ];
        };
      };

      services.openssh = {
        enable = true;
        startWhenNeeded = false;
        ports = [ sshPort ];
      };

      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        git.enable = true;
        nix-ld.enable = true;
      };

      environment.systemPackages = with pkgs; [
        codex
        opencode
        pi-coding-agent
        bubblewrap
        socat
        herdr

        # General project and inspection tools. Project-specific compilers and
        # SDKs should normally come from each project's devShell.
        curl
        fd
        gh
        git
        jq
        ripgrep
        tmux
        tree
        unzip
        uv
        wget
      ];

      system = {
        inherit (config.system) stateVersion;
      };
    };
  };
}
