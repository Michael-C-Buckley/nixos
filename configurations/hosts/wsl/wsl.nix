{pkgs, ...}: let
  vscodeExtensions = with pkgs.vscode-extensions; [
    ms-pyright.pyright
    ms-python.vscode-pylance
    ms-python.python
    ms-python.debugpy
  ];
in {
  # Disable the default boot options, as WSL has its own
  features.boot = "none";

  nixpkgs.hostPlatform = "x86_64-linux";

  services = {
    # Consistent problems are coming up with the non-FHS
    # Make sure that the WSL settings is also NAT mode
    vscode-server = {
      enableFHS = true;
      extraRuntimeDependencies = vscodeExtensions;
    };
  };

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
