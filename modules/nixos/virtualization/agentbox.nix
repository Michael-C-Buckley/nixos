{ inputs, ... }: {
  imports = [ inputs.agentbox.nixosModules.default ];

  programs.agentbox.enable = true;
}
