{
  perSystem = {pkgs, ...}: {
    packages.attic = pkgs.dockerTools.buildImage {
      name = "attic";
      tag = "latest";

      copyToRoot = pkgs.buildEnv {
        name = "attic-image-root";
        paths = [
          pkgs.attic-server
          pkgs.postgresql # For psql client
          pkgs.coreutils
          pkgs.bash
        ];
        pathsToLink = ["/bin"];
      };

      config = {
        Cmd = ["${pkgs.attic-server}/bin/atticd"];
        ExposedPorts = {
          "8080/tcp" = {};
        };
        Env = [
          "PATH=/bin"
        ];
      };
    };
  };
}
