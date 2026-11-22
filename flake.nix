{
  description = "Michael's Personal Flake";

  outputs =
    { self, ... }@args:
    let
      inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
    in
    { };
}
