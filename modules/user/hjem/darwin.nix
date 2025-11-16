{
  config,
  inputs,
  ...
}: {
  flake.hjemConfig.darwin = {pkgs, ...}: {
    imports = [
      inputs.hjem.darwinModules.default
      config.flake.hjemConfig.default
    ];

    hjem.users.michael = {
      directory = "/Users/michael";
      gnupg.pinentryPackage = pkgs.pinentry-mac;
    };
  };
}
