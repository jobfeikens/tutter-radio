{
  description = "Flake for tutter-radio server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      fenix,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      rustToolchain = fenix.packages.${system}.stable.withComponents [
        "cargo"
        "rustc"
        "rust-src"
        "rust-analyzer"
      ];
    in
    {

      devShells.${system}.default =
        let
          serverDeps = with pkgs; [
            pkg-config
            libopus
            protobuf
          ];

          clientDeps = with pkgs; [
            nodejs
          ];

          devDeps = with pkgs; [
            rustToolchain
            nixd
            nixfmt-rfc-style
            typescript-language-server
            vscode-css-languageserver
          ];
        in
        pkgs.mkShell {
          buildInputs = serverDeps ++ clientDeps ++ devDeps;
        };
    };
}
