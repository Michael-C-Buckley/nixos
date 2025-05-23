_: {
  # Disable the default boot options, as WSL has its own
  features.boot = "none";

  nixpkgs.hostPlatform = "x86_64-linux";

  wsl = {
    enable = true;
    defaultUser = "michael";
    wslConf.network.generateResolvConf = false;

    # Windows path and binary execution compat
    interop = {
      includePath = true;
      register = true;
    };

    # Use OpenGL driver from host
    useWindowsDriver = true;
  };
}
