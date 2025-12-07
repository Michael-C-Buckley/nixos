# Hosts

These consists of individual non-groups NixOS hosts. The naming is generally based on model/chassis/etc.

## B550

2U racked-mounted general-purpose server. Currently the main host for my kube instance and various other self-host/homelab things.

## O1

Oracle Cloud free-tier ARM server.

- CPU: 4x vCPU (ARM)
- RAM: 24G

## p520

This is a Lenovo P520 workstation I use as a virtualization and build server. I use it with Cisco Modeling Labs, ContainerLab, and other tools.

- CPU: Xeon W-2195
- RAM: 256G
- GPU: Nvidia GTX-970

## t14

Lenovo T14 Gen2 AMD, my personal laptop.

- CPU: AMD Ryzen 5850U
- RAM: 32G

## tempest

This is a persistently installed USB drive with NixOS for live boots and bootstrapping. It is massively convenient since it contains the flake and store so can locally bootstrap most things without needing to download anything.

I like it better than a live ISO since I can update it more easily and not have to constantly swap ISOs on a thumb disk.

## x570

My desktop, which I use often when at home and sometimes game with. I do some virtualization workloads on it too and often rebuild other hosts with it.

- CPU: AMD Ryzen 5950X
- RAM: 64G
- GPU: Intel B570
