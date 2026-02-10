{
  flake.functions.yaml = {pkgs}: {
    buildYAML = {
      attrs,
      name ? "built-yaml",
    }:
      pkgs.stdenv.mkDerivation {
        inherit name;
        src = pkgs.lib.generators.toJSON {} attrs;
        dontUnpack = true;
        nativeBuildInputs = with pkgs; [yq-go yamllint];
        buildPhase = ''
          echo "$src" > temp.json
          yq eval -P temp.json > temp.yaml
          yamllint temp.yaml
          cp temp.yaml $out
        '';
      };
    checkYAML = {
      yaml,
      name ? "checked-yaml",
    }:
      pkgs.stdenv.mkDerivation {
        inherit name;
        src = yaml;
        dontUnpack = true;
        nativeBuildInputs = [pkgs.yamllint];
        buildPhase = ''
          yamllint $src
          cp $src $out
        '';
      };
  };
}
