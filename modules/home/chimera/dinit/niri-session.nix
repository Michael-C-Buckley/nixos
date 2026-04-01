{config, ...}: {
  flake.modules.homeManager.chimera-niri-session = {
    pkgs,
    lib,
    ...
  }: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) noctalia;

    sessionEnd = pkgs.writeShellScript "niri-session-end" ''
      if [ -p "$SESSION_PIPE" ]; then
        echo
        done > "$SESSION_PIPE"
      fi
    '';

    niri = config.flake.wrappers.mkNiri {
      inherit pkgs;
      extraConfig = config.flake.extraConfigs.t14-niri;
      spawnNoctalia = false;
    };
  in {
    xdg.configFile = {
      "dinit.d/niri".text = ''
        type = process
        command = nixGL ${lib.getExe' niri "niri-wrapped"}
        smooth-recovery = true
        stop-command = ${sessionEnd}
      '';

      "dinit.d/noctalia".text = ''
        type = process
        command = ${lib.getExe noctalia}
        depends-on = niri
        restart = true
        restart-delay = 2
      '';
    };
  };
}
