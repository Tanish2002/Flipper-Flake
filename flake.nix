{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  description = "Flake for Flipper";

  outputs = { self, nixpkgs, }:
    let pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in {
      packages.x86_64-linux.flipper = pkgs.callPackage ./default.nix { };
      packages.x86_64-linux.default = self.packages.x86_64-linux.flipper;
    };
}
