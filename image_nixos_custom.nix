{ modulesPath, ... }:
{
  imports = [
    # Make sure to have this in all your configurations
    "${toString modulesPath}/virtualisation/google-compute-image.nix"
  ];
  nix.settings = {
    trusted-users = [ "nejrobbins_gmail_com" ];
    trusted-public-keys = [ "robbins-page-deploy:w0blTbOHTQkwfbYRNCB1pv+63HeAcFcnjAFdfmAZv4o=" ];
    require-sigs = false;
    auto-optimise-store = true;
  };
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.11";
}
