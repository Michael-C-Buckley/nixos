{
  makeWrapper,
  nix-search-tv,
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  pname = "ns";
  version = "1.0";

  inherit (nix-search-tv) src;

  nativeBuildInputs = [makeWrapper];
  buildInputs = with pkgs; [
    fzf
    nix-search-tv
  ];
  unpackPhase = "true";

  installPhase = with pkgs; ''
    mkdir -p $out/bin
    cp ${src}/nixpkgs.sh $out/bin/ns
    chmod +x $out/bin/ns

    # Wrap the script so runtimeInputs are in PATH
    wrapProgram $out/bin/ns \
      --prefix PATH : ${pkgs.lib.makeBinPath [
      fzf
      nix-search-tv
    ]}
  '';

  # Skip tests as shell checks has false positives
  checkPhase = "true";
}
