# WSL

```
Notice: This configuration is currently suspended
```

My WSL config I occasionally use. It largely contains most of my standard configs I pass around and is just a familiar environment to use tooling I need while relegated to Windows.

## suspended

This host is not currently being used. A severe problem with the WSL architecture is the lack of control boot. This precludes any types of rollbacks or other system management.

As such, I am attempting other means with WSL, meaning I defected to Alpine. That home-manager config will be coming soon, as being truly free from Nix is now impossible for me.

In the end, I want to manage the userspace and not so much the system, due to the above limitations anyway. Therefore, an easy to deploy (and replace) system like Alpine seems reasonable.
