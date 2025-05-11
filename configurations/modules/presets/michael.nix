{
  nix.settings = {
    substituters = [
      #"http://x570.michael.lan:5000"

      # Not yet active
      # "http://p520.michael.lan:5000"
      # "http://uff1.michael.lan:5000"
      # "http://uff2.michael.lan:5000"
      # "http://uff3.micheal.lan:5000"
    ];
    trusted-public-keys = [
      #"x570.michael.lan:b3fLRrQyBeUbmpS+AGi68O1L2F1kSLEVX2ePAyDPNWk="
    ];
  };
  programs.nh = {
    flake = "/home/michael/nixos";
  };
}
