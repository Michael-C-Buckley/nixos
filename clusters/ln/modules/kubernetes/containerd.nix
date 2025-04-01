{pkgs, ...}: let
  nvidia-container-runtime-fhs = pkgs.buildFHSEnv {
    name = "nvidia-container-runtime-fhs";
    targetPkgs = pkgs:
      with pkgs; [
        cudaPackages.cudatoolkit
        linuxPackages.nvidia_x11
        libnvidia-container
        nvidia-container-toolkit
      ];
    runScript = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-runtime";
  };
in {
  environment.systemPackages = [nvidia-container-runtime-fhs];
  hardware.nvidia-container-toolkit.enable = true;

  systemd.services.containerd = {
    path = with pkgs; [
      containerd
      runc
      iptables
      libnvidia-container
      nvidia-container-runtime-fhs
      linuxPackages.nvidia_x11
      cudaPackages.cudatoolkit
    ];
  };

  virtualisation.containerd = {
    enable = true;
    settings = {
      plugins."io.containerd.grpc.v1.cri" = {
        default_runtime_name = "nvidia";
        enable_cdi = true;
        cdi_spec_dirs = ["/var/run/cdi"];
      };
      plugins."io.containerd.grpc.v1.cri".containerd = {
        default_runtime_name = "nvidia";
        snapshotter = "overlayfs";
      };
      plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia = {
        privileged_without_host_devices = false;
        runtime_type = "io.containerd.runc.v2";
        runtime_engine = "";
        runtime_root = "";
      };
      plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia.options = {
        BinaryName = "${nvidia-container-runtime-fhs}/bin/nvidia-container-runtime-fhs";
        SystemdCgroup = true;
      };
    };
  };
}
