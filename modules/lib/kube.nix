{
  flake.lib.functions-kube = {pkgs}: {
    # Build a single manifest file from a kustomize directory
    buildManifest = path:
      pkgs.runCommand "${path}-manifests" {} ''
        ${pkgs.kustomize}/bin/kustomize build ${path} > $out
      '';

    # Build an OCI image for k3s with the correct localhost/ prefix
    # This ensures k3s imports it with the expected name
    buildK3sImage = {
      name,
      tag ? "latest",
      contents ? [],
      config ? {},
    }:
      pkgs.dockerTools.buildImage {
        name = "localhost/${name}";
        inherit tag config;
        copyToRoot = pkgs.buildEnv {
          name = "${name}-image-root";
          paths = contents;
          pathsToLink = ["/bin"];
        };
      };
  };
}
