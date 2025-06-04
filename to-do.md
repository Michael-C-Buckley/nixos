# Some things I am reminding myself I want to work on

- Setup up caching/remote building
- Module import structure
- Finish style consistency of pointers and themes
- Nebula networking
- Secrets integration & Migration

## Restructuring

- Impermanence Preset
- Disko Preset
- Oracle nodes

## In Progress

- Nix Cache (Attic)

This was started but paused due to time constraints.

Still needs:

- TLS
- Push mechanism

## Disko Usage

Something for myself as I learn this process. YMMV on the store path of OVMF, it's valid only at time of writing on my machine.

- Create build script:
  `nix build .#nixosConfigurations.o3.config.system.build.diskoImagesScript`

- Build it:
  `sudo ./result --build-memory 16384`

- Run the VM (Oracle appears to have settings similar to these)

```
qemu-system-x86_64 \
  -m 1G \
  -machine type=pc-i440fx-7.2,accel=kvm \
  -smp 2 \
  -drive format=raw,file=main.raw \
  -cpu host \
  -display default \
  -vga virtio -bios /nix/store/ypfbsa465m41zyxkcdgqhlgc7j9411di-OVMF-202411-fd/FV/OVMF.fd
```
