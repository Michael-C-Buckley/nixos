{
  lib,
  pkgs,
  git,
  neovim,
  delta,
  git-credential-sops,
  settings ? { },
}:
let
  escapeValue =
    value:
    lib.escapeShellArg (
      if builtins.isPath value then "${value}" else lib.generators.mkValueStringDefault { } value
    );
  applySetting =
    key: value:
    let
      name = lib.escapeShellArg key;
      values = if value == null then [ ] else value;
    in
    if value == null || builtins.isList value then
      ''
        git config --file "$out/defaults" --unset-all -- ${name} || [ "$?" -eq 5 ]
        ${lib.concatMapStringsSep "\n" (entry: ''
          git config --file "$out/defaults" --add -- ${name} ${escapeValue entry}
        '') values}
      ''
    else
      ''
        git config --file "$out/defaults" --replace-all -- ${name} ${escapeValue value}
      '';

  config = pkgs.runCommand "git-config" { nativeBuildInputs = [ git ]; } ''
    install -Dm644 ${./configs/config} "$out/defaults"
    ${applySetting "core.excludesfile" ./configs/ignore}
    # Only the portable user config can find local.inc beside itself.
    git config --file "$out/defaults" --fixed-value --unset-all include.path local.inc || [ "$?" -eq 5 ]
    ${lib.concatStrings (lib.mapAttrsToList applySetting settings)}

    # Keep Git's platform system config ahead of the package defaults.
    git config --file "$out/gitconfig" --add include.path "$(git var GIT_CONFIG_SYSTEM)"
    git config --file "$out/gitconfig" --add include.path defaults
  '';
in
pkgs.symlinkJoin {
  pname = "git";
  inherit (git) version;
  paths = [ git ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  postBuild = ''
    wrapProgram "$out/bin/git" \
      --set-default GIT_CONFIG_SYSTEM ${config}/gitconfig \
      --suffix PATH : ${
        lib.makeBinPath [
          delta
          neovim
          git-credential-sops
        ]
      }
  '';
  meta.mainProgram = "git";
}
