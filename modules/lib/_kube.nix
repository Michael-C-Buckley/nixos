{
  # Build a single manifest file from a kustomize directory
  buildManifest = pkgs: path:
    pkgs.runCommand "${path}-manifests" {} ''
      ${pkgs.kustomize}/bin/kustomize build ${path} > $out
    '';
}
