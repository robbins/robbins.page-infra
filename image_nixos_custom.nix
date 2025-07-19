{ modulesPath, ... }:
{
  imports = [
    # Make sure to have this in all your configurations
    "${toString modulesPath}/virtualisation/google-compute-image.nix"
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.11";
}
