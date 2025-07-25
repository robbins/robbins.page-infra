{
  inputs = {
    nixpkgs.url = "github:robbins/nixpkgs/nixpkgs-unstable";
    website-src = {
      url = "github:robbins/robbins.page-site";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
      pkgs = import nixpkgs { 
        inherit system;
        config = {
          allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
            "terraform"
          ];
        };
      };
  in
  {
    devShells."${system}".default = pkgs.mkShell {
      buildInputs = [
        (pkgs.terraform.withPlugins (p: [ p.null p.external p.google p.random ]))
        inputs.agenix.packages."${system}".agenix
        pkgs.google-cloud-sdk
        pkgs.jq
      ];
    };
    nixosConfigurations = {
      robbins-page-webserver = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
          modules = [ 
            ./robbins-page-webserver-configuration.nix
            inputs.agenix.nixosModules.default
            inputs.disko.nixosModules.disko
            "${nixpkgs}/nixos/modules/virtualisation/google-compute-image.nix"
          ];
      };
    };
  };
}
