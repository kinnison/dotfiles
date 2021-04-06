{ pkgs, ... }:
let
  extensions = (
    with pkgs.vscode-extensions; [
      bbenoist.Nix
      ms-vscode-remote.remote-ssh
    ]
  ) ++ (pkgs.vscode-utils.extensionsFromVscodeMarketplace []) ++ (
    with pkgs.unstable.vscode-extensions; [
      matklad.rust-analyzer
    ]
  );
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
in
{
  home.packages = [
    vscode-with-extensions
  ];
}
