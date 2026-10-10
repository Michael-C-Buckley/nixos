# Shared kernel profile. This evaluates without realizing the generated config.
{ inputs }:
let
  cachyos = inputs.cachyos-kernel;
  # Use the input's own build environment, unaffected by the system nixpkgs pin.
  pkgs = cachyos.inputs.nixpkgs.legacyPackages.x86_64-linux;
  inherit (pkgs) lib;
  base = cachyos.legacyPackages.x86_64-linux.linuxPackages-cachyos-latest;

  snapshots = [
    ./b550/snapshots/2026-07-12-active-host.modules
    ./t14g2/snapshots/2026-07-12-active-laptop.modules
    ./t14g5/snapshots/2026-07-12-active-laptop.modules
    ./x570/snapshots/2026-07-12-active-desktop.modules
  ];
  snapshotModules = lib.concatMap (
    snapshot: lib.splitString "\n" (builtins.readFile snapshot)
  ) snapshots;
  moduleNames = lib.sort builtins.lessThan (
    lib.unique (
      map (lib.replaceStrings [ "-" ] [ "_" ]) (
        lib.filter (name: name != "" && !lib.hasPrefix "#" name) (
          snapshotModules ++ import ./required-modules.nix
        )
      )
    )
  );
  externalModules = [ "spl" "zfs" ];
  moduleManifest = pkgs.writeText "cachyos-shared.modules" (
    lib.concatStringsSep "\n" moduleNames + "\n"
  );
  # localmodconfig maps in-tree module names to Kconfig using kernel Makefiles.
  # ZFS/SPL have no entries in that source tree and are built separately.
  lsmod = pkgs.writeText "cachyos-shared.lsmod" (
    "Module Size Used by\n"
    + lib.concatMapStrings (name: "${name} 0 0\n") (
      lib.subtractLists externalModules moduleNames
    )
  );
  requiredConfig = import ./required-config.nix { inherit lib; };

  # First generate the full upstream config with our mandatory capabilities.
  # This preserves the input's NixOS and CachyOS settings before trimming.
  seed = base.kernel.override {
    structuredExtraConfig = requiredConfig;
  };
  trimmedConfig = seed.stdenv.mkDerivation {
    pname = "linux-cachyos-shared-config";
    inherit (seed) version src;
    outputs = [ "out" "report" ];
    nativeBuildInputs = seed.configfile.nativeBuildInputs ++ [ pkgs.gnumake ];
    inherit (seed.configfile) depsBuildBuild;
    env = seed.configfile.env or { };

    # Preserve modular filesystem and recovery-driver families conservatively.
    # B550 currently retains NixOS's broad default initrd module list.
    LMC_KEEP = lib.concatStringsSep ":" [
      "fs"
      "crypto"
      "drivers/ata"
      "drivers/scsi"
      "drivers/message"
      "drivers/md"
      "drivers/usb"
      "drivers/input"
      "drivers/hid"
      "drivers/mmc"
      "drivers/char/tpm"
    ];

    configurePhase = ''
      set -o pipefail
      runHook preConfigure
      kernelMakeFlags=( ${lib.escapeShellArgs seed.configfile.makeFlags} )
      cp ${seed.configfile} .config
      make "''${kernelMakeFlags[@]}" olddefconfig
      make "''${kernelMakeFlags[@]}" LSMOD=${lsmod} localmodconfig 2>&1 | tee localmodconfig.log
      make "''${kernelMakeFlags[@]}" olddefconfig
      runHook postConfigure
    '';
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      cp .config "$out"
      mkdir -p "$report"
      cp localmodconfig.log "$report/"
      cp ${moduleManifest} "$report/required.modules"
      runHook postInstall
    '';
  };

  configured = seed.override {
    cachyosConfigFile = trimmedConfig;
    autoModules = false;
    preferBuiltin = false;
    enableCommonConfig = true;
  };
  # Check the final config after the upstream builder reapplies its settings.
  # This is a build-time guard; evaluation never reads a derivation output.
  configChecks = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      name: setting:
      let
        value = setting.content.tristate;
        pattern =
          if value == "m" then "CONFIG_${name}=[ym]" else "CONFIG_${name}=${value}";
      in
      ''
        if ! grep -Eq ${lib.escapeShellArg "^${pattern}$"} "$buildRoot/.config"; then
          echo ${lib.escapeShellArg "Missing required kernel capability: CONFIG_${name}"} >&2
          exit 1
        fi
      ''
    ) requiredConfig
  );
  kernel = configured.overrideAttrs (old: {
    postConfigure = (old.postConfigure or "") + "\n" + configChecks;
    passthru = (old.passthru or { }) // {
      inherit moduleNames moduleManifest trimmedConfig snapshots;
    };
  });
  # Keep upstream external-module fixes and bind ZFS to this exact kernel.
  kernelPackages = base.extend (_final: _prev: { inherit kernel; });
in
{
  inherit kernel kernelPackages moduleNames moduleManifest trimmedConfig snapshots;
}
