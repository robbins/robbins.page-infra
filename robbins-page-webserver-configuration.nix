{ config, lib, pkgs, inputs, ... }: {
  #age.secrets.cloudflare-api-token.file = ./secrets/cloudflare-api-token.age;

  services.openssh.hostKeys = [
    {
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.05";
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "nejrobbins_gmail_com" ];
      trusted-public-keys = [ "robbins-page-deploy:w0blTbOHTQkwfbYRNCB1pv+63HeAcFcnjAFdfmAZv4o=" ];
    };
    gc.automatic = true;
  };

  services.nginx = {
    enable = true;
    virtualHosts."robbins.page" = {
      root = "${inputs.website-src.packages.x86_64-linux.default}";
      forceSSL = true;
      sslCertificate = "/var/keys/robbins.page.pem";
      sslCertificateKey = "/var/keys/robbins.page.key";
      extraConfig = ''
        ssl_client_certificate /etc/ssh/authenticated_origin_pull_ca.pem;
        ssl_verify_client on;
      '';
    };
  };
  environment.systemPackages = [ inputs.website-src.packages.x86_64-linux.default ];
  environment.etc."ssh/authenticated_origin_pull_ca.pem".text = builtins.readFile ./authenticated_origin_pull_ca.pem;
  users.users.nginx.extraGroups = [ "keys" ];

  services.cloudflare-dyndns = {
    enable = false;
    domains = [ "robbins.page" "www.robbins.page" ];
    #apiTokenFile = config.age.secrets.cloudflare-api-token.path;
  };

  services.nscd.enableNsncd = false;
}
