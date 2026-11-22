{ pkgs }:
pkgs.writeShellApplication {
  name = "git-credential-sops";
  runtimeInputs =
    with pkgs;
    [
      coreutils
      jq
      sops
      age
      age-plugin-yubikey
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ age-plugin-tpm ];
  text = builtins.readFile ./git-credential-sops.sh;
}
