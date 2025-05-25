# Globally available Nixpkgs Overlays
{self}: {
  default = self.overlays.global;
  global = with self.inputs; [
    nix4vscode.overlays.forVscode
  ];
  localPkgs = import ./localPkgs.nix {inherit self;};
}
