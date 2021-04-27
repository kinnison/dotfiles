{ pkgs, ... }: {
  python = pkgs.unstable.callPackage ./python {
    extractNuGet = pkgs.unstable.callPackage ./python/extract-nuget.nix { };
  };
}
