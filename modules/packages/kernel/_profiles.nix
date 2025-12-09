# Kernel profile configurations
# Reusable across different kernel versions and builds
#
# Profiles approximate the workload they'll be experiencing:
# - Server: throughput and efficiency focused
# - Balanced: mix of responsiveness and throughput
# - Performance: maximum responsiveness
{
  server = {
    cpuGovernor = "schedutil";
    preemptModel = "voluntary"; # Lower overhead, better throughput
    hz = 300; # Good balance for server workloads
  };

  balanced = {
    cpuGovernor = "schedutil";
    preemptModel = "dynamic"; # Runtime tunable preemption
    hz = 500; # Good compromise
  };

  performance = {
    cpuGovernor = "performance"; # Maximum frequency always
    preemptModel = "full"; # Full preemption for low latency
    hz = 1000; # Maximum timer frequency
  };
}
