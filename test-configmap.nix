with import <nixpkgs> {}; let
  configYaml = builtins.readFile ./modules/hosts/o1/k3s/headscale/config.yaml;
in
  writeTextFile {
    name = "headscale-configmap.yaml";
    text = ''
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: headscale-config
      data:
        config.yaml: |
      ${lib.strings.indent "    " configYaml}
    '';
  }
