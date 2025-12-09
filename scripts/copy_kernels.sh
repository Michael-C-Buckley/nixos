#!/usr/bin/env bash

kernels=(jet1 jet2 jet3)
hosts=(uff1 uff2 uff3 b550 p520 t14)

for kernel in "${kernels[@]}"; do
  nix build .#"$kernel"
  store_path=$(readlink -f result)
  for host in "${hosts[@]}"; do
    echo "Copying $kernel to $host"
    nix copy --to ssh://"$host" "$store_path"
  done
done
