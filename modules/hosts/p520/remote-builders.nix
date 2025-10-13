{
  flake.modules.nixos.p520 = {
    nix.buildMachines = [
      {
        hostName = "localhost";
        system = "x86_64-linux";
        maxJobs = 8;
        speedFactor = 1;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }

      # ARM Builder on Oracle Cloud
      {
        hostName = "o1.groovyreserve.com";
        system = "aarch64-linux";
        maxJobs = 2;
        speedFactor = 1;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel"];
        mandatoryFeatures = [];
        sshUser = "builder";
        sshKey = "/var/lib/hydra/.ssh/id_ed25519";
      }

      # WIP: Coming soon, after I set this up
      # {
      #   hostName = "m1";
      #   system = "aarch64-darwin";
      #   maxJobs = 4;
      #   speedFactor = 1;
      #   supportedFeatures = ["benchmark" "big-parallel"];
      #   mandatoryFeatures = [ ];
      #   sshUser = "builder";
      #   sshKey = "/var/lib/hydra/.ssh/id_ed25519";
      # }
    ];
  };
}
