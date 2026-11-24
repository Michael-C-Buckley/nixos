{ pkgs, ... }:
{
  packages = [ (pkgs.callPackage ../../../packages/gram { }) ];
}
