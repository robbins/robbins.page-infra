{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    website-src = {
      url = "github:robbins/robbins.page-site";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-unstable, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs-unstable { inherit system; };
  in
  {
    devShells."${system}".default = pkgs.mkShell {
      buildInputs = with pkgs; [
        terraform
        inputs.agenix.defaultPackage."${system}"
      ];
    };
    nixosConfigurations = {
      robbins-page-webserver = nixpkgs-unstable.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./robbins-page-webserver-configuration.nix inputs.agenix.nixosModule ];
      };
    };
  };
}
