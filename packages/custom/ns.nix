{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "ns";
  version = "1.0";

  inherit (pkgs.nix-search-tv) src;

  nativeBuildInputs = [pkgs.makeWrapper];
  buildInputs = with pkgs; [
    fzf
    nix-search-tv
  ];
  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp ${pkgs.nix-search-tv.src}/nixpkgs.sh $out/bin/ns
    chmod +x $out/bin/ns

    # Wrap the script so runtimeInputs are in PATH
    wrapProgram $out/bin/ns \
      --prefix PATH : ${pkgs.lib.makeBinPath [
      pkgs.fzf
      pkgs.nix-search-tv
    ]}
  '';

  # Skip tests as shell checks has false positives
  checkPhase = "true";
}
