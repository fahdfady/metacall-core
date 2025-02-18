{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
        metacall = pkgs.callPackage ./nix/packages/metacall.nix { 
            inherit (pkgs) cacert;
        };
      in {
        packages = {
          default = metacall;
          inherit metacall;
        };
        
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            cmake
            ninja
            python3
            nodejs
            rustc
            cargo
            git
          ];
        };
      }
    ) // {
      nixosModules.default = import ./nix/modules/default.nix;
    };
}