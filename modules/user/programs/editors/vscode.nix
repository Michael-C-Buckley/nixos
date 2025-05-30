{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf optionals;
  inherit (lib.types) listOf str package;
  cfg = config.programs.vscode;

  imperm = config.system.impermanence.enable;
  impermDir = if (cfg.package == pkgs.vscodium) then [
        ".config/VScodium"
      ] else [];

  # Only run the helper if there's actually something to give it
  outOfStoreExt =
    if (cfg.nonNixExtensions != [])
    then pkgs.nix4vscode.forVscode cfg.nonNixExtensions
    else [];

  msExtensionList =
    if (cfg.package == pkgs.vscode)
    then cfg.msExtensions
    else [];

  remoteExtension =
    if (cfg.package == pkgs.vscode)
    # Use the relevant ones
    then
      with pkgs.vscode-extensions.ms-vscode-remote; [
        remote-ssh
        remote-ssh-edit
        remote-containers
      ]
    else
      #
      with pkgs.open-vsx; [
        jeanp413.open-remote-ssh
      ];
in {
  options.programs.vscode = {
    enable = mkEnableOption "Enable VScode";
    enableRemote = mkEnableOption "Enable remote development.";
    package = mkOption {
      type = package;
      default = pkgs.vscode;
      description = "The package to use (and potentially swap for alt client).";
    };
    extensions = mkOption {
      type = listOf package;
      description = "Extensions from Nixpkgs.";
      default = [];
    };
    nonNixExtensions = mkOption {
      type = listOf str;
      description = "Extensions by name found in the vscode store via nix4vscode overlay.";
      default = [];
    };
    msExtensions = mkOption {
      type = listOf package;
      default = [];
      description = "Microsoft Official extensions to not include with alt clients.";
    };
  };

  config = {system.impermanence = mkIf (cfg.enable && imperm) {
      userPersistDirs = impermDir;
    };
    packageList = mkIf cfg.enable [



    (pkgs.vscode-with-extensions.override {
      vscode = cfg.package;
      vscodeExtensions = cfg.extensions ++ outOfStoreExt ++ msExtensionList ++ optionals cfg.enableRemote remoteExtension;
    })
  ];
  };
}
