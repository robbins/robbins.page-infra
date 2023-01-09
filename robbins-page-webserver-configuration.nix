{ config, lib, pkgs, inputs, ... }: {
  imports = [ "${inputs.nixpkgs-unstable}/nixos/modules/virtualisation/google-compute-image.nix" ];
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.05";
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "nejrobbins_gmail_com" ];
    };
    optimise.automatic = true;
    gc.automatic = true;
  };
}
