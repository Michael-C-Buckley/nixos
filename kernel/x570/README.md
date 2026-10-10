# X570 kernel profile

This directory contains locally observed kernel requirements for the X570 host.
It is input to a later composite `localmodconfig` process; it is not itself a
kernel configuration.

The first snapshot is a normal active desktop session. It includes the devices
attached at capture time, so it must be supplemented with snapshots for less
common workloads and peripherals before a configuration is generated.

Data is deliberately limited to module names, PCI IDs, driver bindings,
filesystem types, and a sanitized USB driver tree. It contains no disk UUIDs,
serial numbers, MAC addresses, or IP addresses.
