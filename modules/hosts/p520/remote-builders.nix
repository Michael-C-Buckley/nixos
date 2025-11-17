# Speed factor is the single-core speed from CPU Benchmark
{
  flake.modules.nixos.p520 = {
    nix.buildMachines = [
      {
        hostName = "localhost";
        system = "x86_64-linux";
        maxJobs = 8;
        speedFactor = 2436;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
      {
        # M1 Mini on Nix-Darwin with Determinate
        # Can natively build both aarch64-darwin and aarch64-linux
        hostName = "m1";
        protocol = "ssh-ng";
        system = "aarch64-darwin";
        systems = ["aarch64-darwin" "aarch64-linux"];
        maxJobs = 2;
        speedFactor = 3678;
        supportedFeatures = ["benchmark" "big-parallel"];
        mandatoryFeatures = [];
        sshUser = "builder";
        sshKey = "/etc/ssh/builder_key";
      }
      {
        hostName = "x570";
        protocol = "ssh-ng";
        system = "x86_64-linux";
        maxJobs = 4;
        speedFactor = 3473;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
        sshUser = "builder";
        sshKey = "/etc/ssh/builder_key";
      }
    ];
  };
}
