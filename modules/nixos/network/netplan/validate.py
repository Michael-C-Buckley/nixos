"""Check address fields in a Netplan document serialized as JSON."""

import ipaddress
import json
import re
import sys

errors = []
mac_modes = {"permanent", "random", "stable", "stable-ssid", "preserve"}


def error(path, message):
    errors.append(f"{'.'.join(path)}: {message}")


def check_ip(value, path, kind):
    try:
        if not isinstance(value, str):
            raise TypeError("expected a string")
        if kind == "interface":
            if "/" not in value:
                raise ValueError("interface addresses require a prefix length")
            ipaddress.ip_interface(value)
        elif kind == "network":
            ipaddress.ip_network(value, strict=False)
        else:
            address = ipaddress.ip_address(value)
            if kind in ("gateway4", "gateway6") and address.version != int(kind[-1]):
                raise ValueError(f"expected IPv{kind[-1]}")
    except (ValueError, TypeError) as exc:
        error(path, f"invalid IP address {value!r}: {exc}")


def walk(node, path=()):
    if isinstance(node, list):
        for index, item in enumerate(node):
            walk(item, (*path, str(index)))
    elif isinstance(node, dict):
        for key, value in node.items():
            here = (*path, key)
            if key == "macaddress":
                mode = value in mac_modes if isinstance(value, str) else False
                valid_mac = isinstance(value, str) and (
                    len(value.split(":")) in (6, 20)
                    and re.fullmatch(r"[0-9a-fA-F]{2}(?::[0-9a-fA-F]{2})+", value)
                )
                if not valid_mac and not (mode and path[-1:] != ("match",)):
                    error(here, f"invalid MAC address {value!r}")
            elif key == "addresses":
                if not isinstance(value, list):
                    error(here, "expected an address list")
                else:
                    dns = path[-1:] == ("nameservers",)
                    for index, address in enumerate(value):
                        location = (*here, str(index))
                        # Netplan also accepts {"address/prefix": {options}}.
                        if isinstance(address, dict) and not dns:
                            for cidr in address:
                                check_ip(cidr, (*location, cidr), "interface")
                        else:
                            check_ip(
                                address, location, "address" if dns else "interface"
                            )
            elif key in ("gateway4", "gateway6"):
                check_ip(value, here, key)
            elif key == "via" and "routes" in path:
                check_ip(value, here, "address")
            elif key in ("to", "from") and any(
                section in path for section in ("routes", "routing-policy")
            ):
                if not (key == "to" and "routes" in path and value == "default"):
                    check_ip(value, here, "network")
            walk(value, here)


if __name__ == "__main__":
    with open(sys.argv[1], encoding="utf-8") as source:
        configuration = json.load(source)
    if not isinstance(configuration, dict) or not isinstance(
        configuration.get("network"), dict
    ):
        errors.append("network: expected a Netplan network mapping")
    else:
        walk(configuration)
    if errors:
        print(
            "Netplan address validation failed:\n" + "\n".join(errors), file=sys.stderr
        )
        sys.exit(1)
