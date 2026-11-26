{
  config,
  inputs,
  lib,
  modules,
  pkgs,
  ...
}:
let
  guestClosure = pkgs.closureInfo {
    rootPaths = [
      config.environment.path
      config.finit.tasks.hjem-activate-michael.command
      # Hjem's linker references managed files but not the user's packages.
      # Register those too, so the guest daemon recognizes its installed tools.
      config.environment.etc."profiles/per-user/michael".source
    ];
  };
in
{
  imports = [
    "${inputs.finix}/modules/virtualisation/qemu.nix"
    ../../modules/finix/presets/base.nix
    ../../modules/nixos/packages/base.nix
    ../../modules/nixos/packages/dev.nix
    ../../modules/nixos/packages/network.nix
    modules.ifupdown-ng
  ];

  boot = {
    kernelParams = [ "console=ttyS0,115200n8" ];
    initrd.kernelModules = [ "rtc_cmos" ];
  };
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=755" ];
  };

  virtualisation = {
    cores = 2;
    memorySize = 4096;
    qemu = {
      extraArgs = [ "-nographic" ];
      nics.user.args = [
        "user"
        "model=virtio-net-pci"
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      btop
      iproute2
      kubectl
      nushell
      rsync
      strace
      talosctl
      yq
    ];
    etc = {
      sudoers.text = lib.mkAfter ''
        michael ALL=(ALL:ALL) NOPASSWD: ALL
      '';
      "resolv.conf".text = ''
        nameserver 10.0.2.3
      '';
    };
  };

  programs.ifupdown-ng = {
    enable = true;
    auto = [
      "lo"
      "eth0"
    ];
    iface = {
      lo.address = "127.0.0.1/8";
      eth0 = {
        address = "10.0.2.15/24";
        gateway = "10.0.2.2";
      };
    };
  };

  services.getty = {
    package = pkgs.util-linux // {
      meta = pkgs.util-linux.meta // {
        mainProgram = "agetty";
      };
    };
    ttys = [ "ttyS0" ];
    extraArgs = [
      "--autologin"
      "michael"
      "--noclear"
      "--keep-baud"
      "115200"
    ];
  };

  # Register the packages and activation command from the shared host store
  # in the guest's own Nix database before home activation runs.
  finit = {
    # Finix's default tmpfiles rule sets /tmp to 0755 during boot.
    tmpfiles.rules = lib.mkAfter [ "d /tmp 1777 root root" ];
    tasks.register-hjem = {
      description = "register system packages and Hjem in the VM";
      conditions = [ "service/nix-daemon/ready" ];
      command = pkgs.writeShellScript "register-hjem" ''
        set -eu
        NIX_REMOTE=local ${config.services.nix-daemon.package}/bin/nix-store \
          --load-db < ${guestClosure}/registration
      '';
    };
    tasks.hjem-activate-michael = {
      conditions = [ "task/register-hjem/success" ];
      log.file = "/dev/console";
    };
    ttys.ttyS0.conditions = [
      "task/hjem-copy-michael/success"
      "task/ifupdown-ng/success"
    ];
  };

  system.build.vm = pkgs.writeShellApplication {
    name = "run-finix-vm";
    text = ''
      exec ${lib.escapeShellArgs config.virtualisation.qemu.argv} "$@"
    '';
  };
}
