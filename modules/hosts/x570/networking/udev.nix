# Statically rename all NICs to prevent issues
{
  flake.modules.nixos.x570 = {config, ...}: {
    environment.etc."udev/rules.d/10-rename-nics.rules" = config.sops.templates.udev-rename.path;
    sops.templates.udev-rename.content = ''
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.eno1}", NAME="eno1"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.eno2}", NAME="eno2"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.enx3}", NAME="enx3"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.enx4}", NAME="enx4"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.sops.placeholder.nic.wlan1}", NAME="wlan1"
    '';
  };
}
