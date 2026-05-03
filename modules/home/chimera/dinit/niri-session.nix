{config, ...}: {
  flake.modules.homeManager.chimera-niri-session = {
    pkgs,
    lib,
    ...
  }: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) noctalia;

    session-vars = config.flake.custom.extraConfigs.session-vars {inherit pkgs;};

    sessionEnd = pkgs.writeShellScript "niri-session-end" ''
      if [ -p "$SESSION_PIPE" ]; then
        echo done > "$SESSION_PIPE"
      fi
    '';

    dinitSetenv = pkgs.writeShellScriptBin "dinit-setenv-session" (
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList
        (name: value: "dinitctl --user setenv ${name}=${value}")
        session-vars
      )
    );

    niri = config.flake.custom.wrappers.mkNiri {
      inherit pkgs;
      extraConfig = config.flake.custom.extraConfigs.t14-niri;
    };
  in {
    xdg.configFile = {
      "dinit.d/session-env".text = ''
        type = scripted
        command = ${lib.getExe dinitSetenv}
      '';

      "dinit.d/niri".text = ''
        type = process
        command = nixGL ${lib.getExe' niri "niri-session-wrapped"}
        smooth-recovery = true
        depends-on = session-env
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
