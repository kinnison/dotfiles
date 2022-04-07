{ pkgs, ... }:
let
  # Maybe change this later?
  base = pkgs.unstable;
  orig-ext = pkgs.vscode-extensions;
  package = base.vscode-with-extensions.override {
    vscodeExtensions = (with base.vscode-extensions; [
      #matklad.rust-analyzer
      #pkgs.local.vscode.ms-python.python
      orig-ext.ms-python.python
      ms-vscode.cpptools
      ms-vscode-remote.remote-ssh
      ms-azuretools.vscode-docker
      ms-vsliveshare.vsliveshare
      jnoortheen.nix-ide
      brettm12345.nixfmt-vscode
      eamodio.gitlens
      usernamehw.errorlens
      tamasfe.even-better-toml
      esbenp.prettier-vscode
      haskell.haskell
      justusadam.language-haskell
      zxh404.vscode-proto3
    ]) ++ base.vscode-utils.extensionsFromVscodeMarketplace [
      {
        publisher = "rubymaniac";
        name = "vscode-direnv";
        version = "0.0.2";
        sha256 = "sha256-TVvjKdKXeExpnyUh+fDPl+eSdlQzh7lt8xSfw1YgtL4=";
      }
      {
        publisher = "serayuzgur";
        name = "crates";
        version = "0.5.10";
        sha256 = "sha256-bY/dphiEPPgTg1zMjvxx4b0Ska2XggRucnZxtbppcLU=";
      }
      {
        publisher = "karunamurti";
        name = "tera";
        version = "0.0.9";
        sha256 = "sha256-e72lZXg//vCZwoggRrpJlYiNUMxID3rkDLLBtV1b098=";
      }
      {
        publisher = "matklad";
        name = "rust-analyzer";
        version = "0.3.1005";
        sha256 = "sha256-YG8WRxiNAI7R64rL1AsLRtaRODguWoCux5eKy1ZsVv4=";
      }
      {
        publisher = "ms-vscode-remote";
        name = "remote-containers";
        version = "0.217.4";
        sha256 = "sha256-YYoFdqrJLdq8uhx3cKA6nvxCa9Ac4jVxp9dOo4wF5cQ=";
      }
      {
        publisher = "dendron";
        name = "dendron";
        version = "0.89.0";
        sha256 = "sha256-mXbKHm0DBBcsTVMRLJkhs9zZ1r29/4xLN5FJbGzLtsI=";
      }
      {
        publisher = "dendron";
        name = "dendron-paste-image";
        version = "1.1.0";
        sha256 = "sha256-dhyTYsSVg3nXFdApTwRDC2ge5LYwVaX58uj5uJwoWqc=";
      }
      {
        publisher = "dendron";
        name = "dendron-markdown-shortcuts";
        version = "0.12.1";
        sha256 = "sha256-Kmjm1xQvrt228XNSRkLUu6Yu3Oec4csJhi74zjsh3HY=";
      }
      {
        publisher = "redhat";
        name = "vscode-yaml";
        version = "1.5.1";
        sha256 = "sha256-JXhmgBFZdKNjgX6K7U+M/T7HEmIOBQOzQEJ5957TUuM=";
      }
    ];
  };
  my-vscode-package = package // { pname = base.vscode.pname; };
in {
  programs.vscode = {
    enable = true;
    package = my-vscode-package;
    userSettings = {
      "update.mode" = "none";
      "rust-analyzer.checkOnSave.command" = "clippy";
      "rust-analyzer.lens.methodReferences" = true;
      "rust-analyzer.lens.references" = true;
      "window.menuBarVisibility" = "toggle";
      "editor.minimap.enabled" = false;
      "editor.fontFamily" =
        "'Fira Code Sans Mono', 'Droid Sans Mono', 'monospace', monospace, 'Droid Sans Fallback'";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "nix.enableLanguageServer" = true;
      "workbench.editorAssociations" = {
        "*.ipynb" = "jupyter.notebook.ipynb";
      };
      "redhat.telemetry.enabled" = false;
    };
    keybindings = [{
      key = "Enter";
      command = "rust-analyzer.onEnter";
      when = "editorTextFocus && !suggestWidgetVisible && editorLangId == rust";
    }];
  };
  home.packages = with pkgs; [ rustup nixfmt nodePackages.prettier ];
}
