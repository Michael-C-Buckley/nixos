{
  inputs,
  pkgs,
  ...
}:
let
  shellEnv = import ../shellEnv.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "rush";
  paths = [ inputs.rush.packages.${pkgs.stdenv.hostPlatform.system}.rush-shell ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  postBuild = ''
    wrapProgram $out/bin/rush \
      --set ENV ${./config.rush} \
      --set GIT_CONFIG_GLOBAL ${pkgs.callPackage ../git-config.nix { }} \
      --prefix PATH : ${shellEnv}/bin
  '';
  passthru.shellPath = "/bin/rush";
}
