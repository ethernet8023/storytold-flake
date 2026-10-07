# Nix packaging for the ArtCraft / storytold "Craft" app suite.
#
# One registry (suite.nix) describes every app; one generic builder
# (builders/rust-app.nix) turns an entry into a package. Every suite repo
# has the same shape (cargo workspace, apps/<name> GUI + apps/<name>-cli),
# so adding an app is one registry entry, not new packaging.
#
#   nix build .#photocraft        # the GUI + photocraft-cli
#   nix run   .#photocraft       # launch the app
#   nix develop                 # cargo/rustc for hacking on a checkout
{
  description = "ArtCraft / storytold Crafting Apps (photocraft, cadcraft, …) — pure-Rust, nix-packaged";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        mkCraftApp = import ./builders/rust-app.nix { inherit pkgs; };
        packages = builtins.mapAttrs (_: mkCraftApp) (import ./suite.nix pkgs);
      in
      {
        inherit packages;

        apps = builtins.mapAttrs (name: _: {
          type = "app";
          program = "${packages.${name}}/bin/${name}";
        }) packages;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ cargo rustc rustfmt clippy rust-analyzer ];
        };

        formatter = pkgs.nixfmt-rfc-style;
      });
}
