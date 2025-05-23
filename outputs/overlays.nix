# Globally available Nixpkgs Overlays
{self}: {
  default = self.overlay.global;
  global = with self.inputs; [
    nix4vscode.overlays.forVscode
  ];
}
