{flake, ...}: {
  imports =
    builtins.attrValues
    {
      inherit
        (flake.nixosModules)
        linux-preset
        network-base
        zfs
        shawn
        packages-base
        packages-network
        # Users
        hjem
        ;
    };
}
