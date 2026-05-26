{inputs, ...}: {
  # Immediately available
  network = import ./network/base.nix {inherit inputs;};
  disko = import ./disko.nix;

  # Require currying with imported pkgs to be made available
  # I generally handle this when then nixos config is declared
  # and pass as a special arg
  functions = {pkgs, ...}: {
    wireguard = import ./network/wireguard.nix {inherit pkgs;};
    kube.buildManifest = import ./kube/build_manifest.nix {inherit pkgs;};
    yaml = import ./kube/yaml.nix {inherit pkgs;};
  };
}
