{inputs, ...}: {
  imports = [
    inputs.vscode-server.nixosModules.default
    ./graphical
    ./gaming
    # ./hardware
    ./network
    ./packages
    ./programs
    ./services
    ./storage
    ./system
    ./virtualization
  ];
}
