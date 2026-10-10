{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib)
    genAttrs
    recursiveUpdate
    optionalAttrs
    ;
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
  sharedKernel = import ../kernel { inherit inputs; };
in
recursiveUpdate
  (forLinux (
    system:
    let
      pkgs = nixpkgsFor.${system};
    in
    {
      zed = pkgs.callPackage ../packages/zed.nix { };
    }
    // optionalAttrs (system == "x86_64-linux") {
      linux-cachyos-shared = sharedKernel.kernel;
      linux-cachyos-shared-config = sharedKernel.trimmedConfig;
      zfs-cachyos-shared = sharedKernel.kernelPackages.zfs_cachyos;
    }
  ))
  (
    forAll (
      system:
      let
        pkgs = nixpkgsFor.${system};
      in
      {
        ns = pkgs.callPackage ../packages/ns.nix { };
        nvim = pkgs.callPackage ../packages/nvim.nix { };
        git-credential-sops = pkgs.callPackage ../packages/git-credential-sops.nix { };
      }
    )
  )
