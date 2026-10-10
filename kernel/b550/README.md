# B550 kernel profile

This directory contains locally observed kernel requirements for the B550 host.
It is input to a later composite `localmodconfig` process; it is not itself a
kernel configuration.

The initial snapshot was taken over SSH from an active host. It must be
supplemented with snapshots for hardware and workloads not active at capture
time before generating a kernel configuration.

Data is limited to module names, PCI IDs, driver bindings, filesystem types,
and a sanitized USB driver tree. It contains no disk UUIDs, serial numbers,
MAC addresses, or IP addresses.
