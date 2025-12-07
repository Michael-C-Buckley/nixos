# Statically rename all NICs to prevent issues
{
  flake.modules.nixos.b550 = {config, ...}: {
    environment.etc."udev/rules.d/10-rename-nics.rules" = config.sops.templates.udev-rename.path;
    sops.templates.udev-rename.content = ''
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.eno1}", NAME="eno1"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.enp2}", NAME="enp2"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.enp3}", NAME="enp3"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.enp4}", NAME="enp4"
    '';
  };
}
