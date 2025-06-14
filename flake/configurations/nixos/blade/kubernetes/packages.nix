{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cfssl
    openssl
    cudaPackages.cudatoolkit
    linuxPackages.nvidia_x11
    nvidia-container-toolkit
    libnvidia-container
    kubernetes
    kubernetes-helm
    kubectl
    kompose
  ];
}
