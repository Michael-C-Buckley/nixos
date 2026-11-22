# Nushell with my interactive config. The config is the autoload set from
# configs/nushell/autoload, handed to Nushell through NU_VENDOR_AUTOLOAD_DIR,
# so it loads for interactive shells only and scripts run without it.
#
# The extra* arguments are the override points, so another instance is just
# an override, and each extra lands in the file for its stage:
#
#   nushell.override {
#     extraEnv.KUBECONFIG = "/etc/kube/config"; # end of 00-env.nu
#     extraConfig = ''$env.config.edit_mode = "vi"''; # end of 10-config.nu
#     extraAbbreviations.kx = "kubectx"; # end of 20-abbreviations.nu
#     extraRuntimeInputs = [ pkgs.kubectl ]; # the wrapper's PATH
#     extraAutoload."80-work.nu" = ./work.nu; # a new file, or a replacement
#   }
{
  pkgs,
  lib,
  configPaths,
  extraRuntimeInputs ? [ ],
  # NAME = value. Paths are copied to the store, lists join with ":", and
  # null removes one of the defaults below.
  extraEnv ? { },
  # Nushell source
  extraConfig ? "",
  # NAME = expansion, over the shared ones
  extraAbbreviations ? { },
  # "NN-name.nu" = file. Replacing a stage's file drops that stage's extras.
  extraAutoload ? { },
}:
let
  runtimeEnv = pkgs.buildEnv {
    name = "nushell-runtime-env";
    pathsToLink = [ "/bin" ];
    paths =
      with pkgs;
      [
        bat
        carapace
        delta
        direnv
        eza
        fd
        fzf
        git
        nix-direnv
        ripgrep
        starship
        tig
        zoxide
      ]
      ++ extraRuntimeInputs;
  };

  # Set in 00-env.nu rather than on the wrapper, so the hjem module gets them
  # too and extraEnv can replace them
  env = lib.filterAttrs (_: value: value != null) (
    {
      SHELL_COMMON_DIR = configPaths.shell;
      STARSHIP_CONFIG = configPaths.starship + "/default.toml";
      # A plain fish, so completing doesn't load the wrapped fish's config
      NU_FISH_COMPLETER = lib.getExe pkgs.fish;
    }
    // extraEnv
  );

  toEnvString =
    value:
    if builtins.isList value then
      lib.concatMapStringsSep ":" toEnvString value
    else if builtins.isPath value then
      "${value}"
    else
      toString value;

  # JSON is valid Nushell here: JSON strings are Nushell strings, and JSON
  # objects are Nushell records
  toNu = builtins.toJSON;

  # Text appended to the autoload file for each stage
  appends = lib.filterAttrs (_: text: text != "") {
    "00-env.nu" = lib.concatLines (
      lib.mapAttrsToList (name: value: "$env.${toNu name} = ${toNu (toEnvString value)}") env
    );
    "10-config.nu" = extraConfig;
    "20-abbreviations.nu" = lib.optionalString (extraAbbreviations != { }) ''
      $env.config.abbreviations = ($env.config.abbreviations | merge ${toNu extraAbbreviations})
    '';
  };

  autoloadDir = configPaths.nushell + "/autoload";
  repoFiles =
    builtins.readDir autoloadDir
    |> lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nu" name)
    |> lib.mapAttrs (name: _: autoloadDir + "/${name}");

  withAppend =
    name: path:
    if appends ? ${name} then
      pkgs.writeText name ''
        ${builtins.readFile path}
        # ── Added by packages/nushell ────────────────────────────────────────────────
        ${appends.${name}}
      ''
    else
      path;

  missing = lib.filter (name: !(repoFiles ? ${name})) (lib.attrNames appends);

  # Every file is its own symlink, which is why autoload files must not `use`
  # each other by relative path
  autoload =
    assert lib.assertMsg (
      missing == [ ]
    ) "packages/nushell: no autoload file for ${lib.concatStringsSep ", " missing}";
    pkgs.linkFarm "nushell-autoload" (lib.mapAttrs withAppend repoFiles // extraAutoload);
in
pkgs.symlinkJoin {
  name = "nushell";
  paths = [ pkgs.nushell ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nu \
      --set NU_VENDOR_AUTOLOAD_DIR ${autoload} \
      --prefix PATH : ${runtimeEnv}/bin
  '';
  meta.mainProgram = "nu";
  passthru = {
    inherit autoload;
    inherit (pkgs.nushell) shellPath;
  };
}
