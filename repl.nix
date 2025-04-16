{src ? ./.}: let
  inherit (builtins) getFlake;
  flake = getFlake (toString src);
in
  flake // {inherit flake;}
