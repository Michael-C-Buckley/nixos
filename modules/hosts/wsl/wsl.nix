{config, ...}: {
  flake.modules.nixos.wsl = {
    imports = ["${config.flake.npins.nixos-wsl}/modules"];

    boot = {
      initrd.systemd.enable = false;
    };

    wsl = {
      enable = true;
      defaultUser = "michael";
      wslConf.network = {
        generateResolvConf = false;
        generateHosts = false;
      };

      version.rev = config.flake.npins.nixos-wsl.revision;

      # Windows path and binary execution compat
      interop = {
        includePath = true;
        register = true;
      };

      # Use OpenGL driver from host
      useWindowsDriver = true;
    };
  };
}
