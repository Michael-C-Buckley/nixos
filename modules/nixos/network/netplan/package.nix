{
  runCommand,
  python3,
  yamllint,
  configuration,
  name ? "netplan.yaml",
}:
runCommand name
  {
    nativeBuildInputs = [
      python3
      yamllint
    ];
    configurationJSON = builtins.toJSON configuration;
    passAsFile = [ "configurationJSON" ];
  }
  ''
    python3 -m json.tool --indent 2 "$configurationJSONPath" "$out"
    yamllint --strict -d '{extends: default, rules: {document-start: disable, line-length: disable}}' "$out"
    python3 ${./validate.py} "$out"
  ''
