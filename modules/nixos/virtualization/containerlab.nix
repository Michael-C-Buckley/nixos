{config, ...}: {
  flake.modules.nixos.containerlab = {
    pkgs,
    lib,
    ...
  }: {
    # Automatically pull in Docker
    imports = [config.flake.modules.nixos.docker];
    environment.systemPackages = [pkgs.containerlab];

    users = {
      groups.clab_admins = {};
      users.michael.extraGroups = ["clab_admins"];
    };

    # To allow vscode remote to connect, to be able to use the extension
    programs.nix-ld.enable = true;

    # Set SUID bit on containerlab so it runs as root without sudo
    # Useful for restricting new privileges such as using vscode sandboxed
    security.wrappers.containerlab = {
      owner = "root";
      group = "root";
      setuid = true;
      source = lib.getExe pkgs.containerlab;
    };

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
