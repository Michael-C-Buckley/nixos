# CLANKED: see local README
{ writeShellApplication }:

writeShellApplication {
  name = "agentbox";
  text = builtins.readFile ./agentbox.sh;
  meta = {
    description = "Run a prepared container image with a chosen workspace";
    mainProgram = "agentbox";
  };
}
