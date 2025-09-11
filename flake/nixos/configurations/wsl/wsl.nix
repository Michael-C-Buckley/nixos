{
  # Suppresses warnings since WSL does not use impermanence
  environment.persistence."/cache".enableWarnings = false;

  # WSL handles its own bootloading
  features.boot = "none";

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
