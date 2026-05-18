# Home-Manager for my WSL Alpine Instance
{
  flake.modules.homeManager.alpine = {pkgs, ...}: {
    home.packages = with pkgs; [
      bash # Ensure that bash is available
      iproute2 # better than busybox's limited ip tool
      unixtools.whereis
    ];
  };
}
