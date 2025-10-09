{
  pkgs,
  lib,
  ...
}: let
  pname = "gpg-find-key";
in
  pkgs.buildGoModule {
    inherit pname;
    version = "0.1.0";
    src = ./.;

    vendorHash = null;

    buildPhase = ''
      go build -o ${pname} go/${pname}.go
    '';

    installPhase = ''
      install -Dm755 ${pname} $out/bin/${pname}
    '';

    meta = {
      mainProgram = pname;
      description = "A tool to dynamically find GPG signing keys";
      license = lib.licenses.mit;
      maintainers = ["Michael-C-Buckley"];
      platforms = lib.platforms.all;
    };
  }
