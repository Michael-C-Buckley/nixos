# These are a list of the modules that hosts are importing
# It lives here to slightly reduce the lists I have for each host
{
  x570 = [
    ./presets/desktop.nix
    ./system/limine.nix
  ];
  t14 = [
    ./presets/desktop.nix
    ./system/lanzaboote.nix
  ];
  b550 = [
    ./presets/server.nix
  ];
}
