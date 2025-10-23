{config, ...}: {
  flake.modules.nixos.containerlab = {pkgs, ...}: {
    # Automatically pull in Docker
    imports = [config.flake.modules.nixos.docker];
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
