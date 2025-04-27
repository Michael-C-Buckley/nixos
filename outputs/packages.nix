{self}: {
  "x86_64-linux".default = self.outputs.nixosConfigurations.vm.config.system.build.diskoImagesScript;
  "x86_64-linux".o3 = self.outputs.nixosConfigurations.o3.config.system.build.diskoImagesScript;
}
