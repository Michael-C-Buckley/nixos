{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) genAttrs recursiveUpdate;
  forAll = genAttrs [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];
  forLinux = genAttrs [
    "x86_64-linux"
    "aarch64-linux"
  ];
  nixpkgsFor = forAll (
    system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    }
  );
in
recursiveUpdate
  (forLinux (
    system:
    let
      pkgs = nixpkgsFor.${system};
    in
    {
      noctalia-config = pkgs.callPackage ../packages/noctalia.nix { };
      umbriel-config = pkgs.callPackage ../packages/umbriel { };
      zed = pkgs.callPackage ../packages/zed.nix { };
      kitty = pkgs.callPackage ../packages/kitty.nix { };
    }
  ))
  (
    forAll (
      system:
      let
        pkgs = nixpkgsFor.${system};
      in
      {
        helix = pkgs.callPackage ../packages/helix.nix { };
        ns = pkgs.callPackage ../packages/ns.nix { };
        git-config = pkgs.callPackage ../packages/git-config.nix { };
        git-credential-sops = pkgs.callPackage ../packages/git-credential-sops.nix { };
        rush = pkgs.callPackage ../packages/rush.nix { inherit inputs; };
      }
    )
  )
