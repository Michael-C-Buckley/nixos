# Manifests TBA
let
  name = "home-assistant";
in {
  services.postgresql = {
    authentication = ''
      host  ${name}   ${name} 10.42.0.0/16    scram-sha-256
    '';
    ensureUsers = [
      {
        inherit name;
        ensureDBOwnership = true;
        ensureClauses.created = true;
      }
    ];
  };
}
