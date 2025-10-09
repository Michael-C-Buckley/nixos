{
  host = {
    impermanence.cache.directories = [
      "/var/lib/docker"
    ];
    graphicalPackages = with pkgs; [
      containerlab
    ];
  };

  flake.modules.nixosModules.containerlab = {pkgs, ...}: {
    # For now, use docker
    virtualisation.docker.enable = true;
    environment.systemPackages = [pkgs.containerlab];

    # This makes the hosts file writeable for containerlab to use
    systemd.services."relink-hosts" = {
      wantedBy = ["multi-user.target"];
      after = ["local-fs.target" "sysinit-reactivation.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        STORE_PATH=$(readlink /etc/hosts)
        echo "Converting hosts file: $STORE_PATH"
        rm /etc/hosts
        cat "$STORE_PATH" > /etc/hosts
        chmod 0644 /etc/hosts
      '';
    };
  };
}
