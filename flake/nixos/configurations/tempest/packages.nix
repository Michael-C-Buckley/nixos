{pkgs}:
with pkgs; [
  brightnessctl
  nixos-anywhere

  # Storage tools
  parted
  gptfdisk
  nvme-cli

  # Security
  sops
  ssh-to-age
]
