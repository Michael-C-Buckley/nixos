# The base I gave to all linux hosts
# CITATIONS:
# 1 - https://github.com/iynaix/dotfiles/blob/bd2f8aaea20abf76dc1dcd54071b8037e3bfa088/modules/shell/nix/settings.nix#L69
# execute shebangs that assume hardcoded shell paths
{
  self,
  inputs,
  config,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.linuxPreset = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = with flake.modules.nixos;
      [
        michael
        programs
        security
        nix
        options
        users
      ]
      ++ (with inputs; [
        sops-nix.nixosModules.sops
        nvf.nixosModules.default
      ]);

    services = {
      envfs.enable = true; # Citation 1
      timesyncd.enable = false;
      chrony.enable = true;
    };

    systemd.tmpfiles.rules = lib.mkAfter [
      "z ${config.services.chrony.directory}/chrony.keys 0640 root chrony - -"
    ];

    system = {
      # Citation 1 - envfs sets usrbinenv activation script to "" with mkForce
      activationScripts.usrbinenv = lib.mkOverride (50 - 1) ''
        if [ ! -d "/usr/bin" ]; then
          mkdir -p /usr/bin
          chmod 0755 /usr/bin
        fi
      '';

      # make a symlink of flake within the generation (e.g. /run/current-system/src)
      systemBuilderCommands = "ln -s ${self.sourceInfo.outPath} $out/src";
    };

    environment = {
      enableAllTerminfo = false;
      # Selective terminfo only for what I actually use
      systemPackages = map (x: x.terminfo) (with pkgs; [
        alacritty # Zed's built-in uses alacritty
        kitty
        ghostty
        tmux
      ]);
    };

    # Lets impure paths be used
    sops.validateSopsFiles = false;

    programs = {
      nvf = {
        enable = true;
        defaultEditor = true;
      };
    };
    time.timeZone = lib.mkDefault "America/New_York";
    networking.nftables.enable = lib.mkDefault true;
  };
}
