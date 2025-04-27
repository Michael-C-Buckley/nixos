{self}: {
  "x86_64-linux".default = self.outputs.nixosConfigurations.vm.config.system.build.diskoImagesScript;
}
