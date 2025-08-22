{pkgs, ...}: {
  # Disable the default boot options, as WSL has its own
  features.boot = "none";

  # Include Btrfs
  boot.initrd.availableKernelModules = ["btrfs"];

  nixpkgs.hostPlatform = "x86_64-linux";

  environment.systemPackages = with pkgs; [
    kmod
    btrfs-progs
  ];

  wsl = {
    enable = true;
    defaultUser = "michael";
    wslConf.network = {
      generateResolvConf = false;
      generateHosts = false;
    };

    # Windows path and binary execution compat
    interop = {
      includePath = true;
      register = true;
    };

    # Use OpenGL driver from host
    useWindowsDriver = true;
  };
}
