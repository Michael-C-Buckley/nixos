{ inputs, ... }:
let
  forAll = inputs.nixpkgs.lib.genAttrs [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];
  nixpkgsFor = forAll (
    system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    }
  );
in
forAll (
  system:
  let
    pkgs = nixpkgsFor.${system};
  in
  {
    default = import ../shell.nix { inherit pkgs; };
  }
)
