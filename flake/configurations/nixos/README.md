# Hosts

These consists of individual non-groups NixOS hosts. The naming is based on model/chassis/etc.

## O1

Oracle Cloud free-tier ARM server.

- CPU: 4x vCPU
- RAM: 24G

## p520

This is a Lenovo P520 workstation I use as a virtualization heavy server.

- CPU: Xeon W-2195
- RAM: 256G
- GPU: AMD Vega-56

## ssk

This is a persistently installed USB drive with NixOS for live boots and bootstrapping. It is massively convenient since it contains the flake and store so can locally bootstrap most things without needing to download anything.

I like it better than a live ISO since I can update it more easily and not have to constantly swap ISOs on a thumb disk.

## t14

Lenovo T14 Gen2 AMD, my personal laptop.

- CPU: AMD Ryzen 5850U
- RAM: 32G

## vm

This is a fairly generic VM I can built off the stock template my systems have.

## wsl

It is a WSL system I have for when I need to use a Windows machine.

## x570

My desktop, which I use often when at home and sometimes game with.

- CPU: AMD Ryzen 5950X
- RAM: 64G
- GPU: Intel A770
