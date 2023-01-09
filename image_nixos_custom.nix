{ modulesPath, ... }:
{
  imports = [
    # Make sure to have this in all your configurations
    "${toString modulesPath}/virtualisation/google-compute-image.nix"
  ];
  nix.settings.trusted-users = [ "nejrobbins_gmail_com" ];
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.05";
}
