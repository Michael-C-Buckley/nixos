# Some things I am reminding myself I want to work on

* Setup up caching/remote building
* Module import structure
* Finish style consistency of pointers and themes
* Nebula networking
* Secrets integration & Migration

## In Progress

* Nix Cache

This was started but paused due to time constraints.

Still needs:

* TLS
* Push mechanism

## Disko Usage

Something for myself as I learn this process.  YMMV on the store path of OVMF, it's valid only at time of writing on my machine.

* Create build script:
`nix build .#nixosConfigurations.o3.config.system.build.diskoImagesScript`

* Build it:
`sudo ./result --build-memory 16384`

* Run the VM
```
qemu-system-x86_64
  -m 16G \
  -machine type=q35,accel=kvm \
  -smp 8 \
  -drive format=raw,file=main.raw \
  -cpu host \
  -display default \
  -vga virtio \
  -bios /nix/store/ypfbsa465m41zyxkcdgqhlgc7j9411di-OVMF-202411-fd/FV/OVMF.fd
```
