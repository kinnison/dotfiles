{ pkgs, lib, ... }: rec {
  ms-python.python-raw = pkgs.unstable.callPackage ./python {
    extractNuGet = pkgs.unstable.callPackage ./python/extract-nuget.nix { };
  };
  ms-toolsai.jupyter =
    pkgs.unstable.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "jupyter";
        publisher = "ms-toolsai";
        version = "2021.5.745244803";
        sha256 = "0gjpsp61l8daqa87mpmxcrvsvb0pc2vwg7xbkvwn0f13c1739w9p";
      };
      meta = with lib; {
        description = ''
          Jupyter notebook support, interactive programming and computing that supports Intellisense, debugging and more.
        '';
      };
    };
  ms-python.python = pkgs.buildEnv {
    name = "mspython-python-full";
    paths = [ ms-python.python-raw ms-toolsai.jupyter ];
  };
}
