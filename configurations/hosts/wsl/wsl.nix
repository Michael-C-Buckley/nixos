_: {
  # Disable the default boot options, as WSL has its own
  features.boot = "none";

  # Consistent problems are coming up with the non-FHS
  services.vscode-server.enableFHS = true;

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

    # Attaching USB, this one is my Yubikey
    usbip.autoAttach = ["2-1"];
  };
}
