{
  boot = {
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    lanzaboote = {
      enable = true;
      # Both installations mount @sbctl-keys here; do not generate new keys.
      pkiBundle = "/var/lib/sbctl";
      # Each installer keeps a "<ns>-latest.conf" entry on the shared ESP
      # pointing at its current generation; generations sink as z<ns>.
      latestEntry.enable = true;
      # Either installer writes loader.conf on the shared ESP.
      settings = {
        timeout = 10;
        console-mode = "max";
        editor = false;
        default = "@saved";
      };
    };
  };
}
