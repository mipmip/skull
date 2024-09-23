{
  description = "Nix development dependencies for crystal";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-22.11;
    crystal-flake.url = github:manveru/crystal-flake;
  };

  outputs = inputs@{self, nixpkgs, crystal-flake}:
  let
    supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
  in
    {

    packages = forAllSystems (system:
      let
        pkgs = nixpkgsFor.${system};
      in
        {
        skull = pkgs.callPackage ./package.nix { };
      });

    defaultPackage = forAllSystems (system: self.packages.${system}.skull);
    devShells = forAllSystems (system:
      let
        pkgs = nixpkgsFor.${system};
      in
        {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            crystal
            shards
          ];
          buildInputs = with pkgs; [
            crystal
            crystal2nix
            shards
            gnumake
          ];
        };
      });

  };
}
