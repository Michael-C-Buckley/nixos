{
  flake.modules.nixos.o1 = {
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "michaelcbuckley@proton.me";
        dnsProvider = "cloudflare";
        environmentFile = "/run/secrets/groovyreserveToken";
        webroot = null;
      };
      certs."groovyreserve.com" = {
        dnsPropagationCheck = true;
        domain = "groovyreserve.com";
        extraDomainNames = ["attic.groovyreserve.com"];
        group = "nginx";
      };
    };
  };
}
