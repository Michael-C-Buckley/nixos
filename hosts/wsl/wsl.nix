_: {
  # Disable the default boot module
  disabledModules = [
    ../../system/boot.nix
  ];
  
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