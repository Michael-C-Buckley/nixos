# Statically rename all NICs to prevent issues
{
  flake.modules.nixos.p520 = {config, ...}: {
    environment.etc."udev/rules.d/10-rename-nics.rules" = config.sops.templates.udev-rename.path;
    sops.templates.udev-rename.content = ''
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.eno1}", NAME="eno1"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.enx2}", NAME="enx2"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.enx3}", NAME="enx3"
    '';
  };
}
