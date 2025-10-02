{
  features.boot = "none";

  # WSL does not use impermanence, but the modules rely on the base module
  environment.persistence."/persist".enableWarnings = false;
  environment.persistence."/cache".enableWarnings = false;

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
