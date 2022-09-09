{
  description = "Daniel's dot files, and other home-manager based config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    let
      nixpkgs = inputs.nixpkgs;
      unstable = inputs.nixpkgs-unstable;
      overlays = [
        (final: prev: {
          unstable = import unstable {
            system = prev.system;
            config.allowUnfree = true;
          };
        })
        (final: prev: { local = import ./pkgs { pkgs = prev; }; })
      ];
      make-home = { username ? "dsilvers", homeDirectory ? "/home/${username}"
        , modules ? [ ] }:
        systemConfig: {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = overlays;

          nix.registry.nixpkgs = {
            from = {
              id = "nixpkgs";
              type = "indirect";
            };
            flake = unstable;
          };

          imports = [
            ({ ... }: {
              _module.args.systemConfig = systemConfig;
              _module.args.username = username;
              _module.args.homeDirectory = homeDirectory;
            })
            ./configurations
          ] ++ modules;
        };
    in {
      homeConfigurations = {
        test = make-home {
          modules = [
            ./configurations/shared
            ./configurations/mail
            ./configurations/mail/test.nix
            ./configurations/mail/personal.nix
          ];
        };
        parasomnix = make-home {
          modules = [
            ./configurations/shared
            ./configurations/mail
            ./configurations/mail/personal.nix
          ];
        };
        indolence = make-home {
          modules = [
            ./configurations/shared
            ./configurations/mail
            ./configurations/mail/personal.nix
            ./configurations/sudoku.nix
            ./configurations/streaming.nix
          ];
        };
        cataplexy = make-home {
          modules = [
            ./configurations/shared
            ./configurations/mail
            ./configurations/mail/personal.nix
            ./configurations/sudoku.nix
          ];
        };
      };
    }
    # Set up a "dev shell" that will work on all architectures
    // (inputs.flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit overlays system; };
      in {
        packages = import ./pkgs { inherit pkgs; };
        devShell = pkgs.mkShell { buildInputs = with pkgs; [ nixfmt ]; };
      }));
}
