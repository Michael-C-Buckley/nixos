{ pkgs, ... }:
{
  packages = [ (pkgs.callPackage ../../../packages/zed { }) ];
}
