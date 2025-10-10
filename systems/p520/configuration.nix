{
  virtualisation = {
    #containerlab.enable = true;
    libvirtd.enable = true;
    podman.enable = true;
  };

  system = {
    stateVersion = "25.11";
  };

  # Allows vscode remote connections to just work
  programs.nix-ld.enable = true;
}
