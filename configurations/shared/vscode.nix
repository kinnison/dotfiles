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
      ms-vsliveshare.vsliveshare
      jnoortheen.nix-ide
      brettm12345.nixfmt-vscode
      eamodio.gitlens
      usernamehw.errorlens
      tamasfe.even-better-toml
      esbenp.prettier-vscode
      haskell.haskell
      justusadam.language-haskell
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
        version = "0.2.853";
        sha256 = "sha256-HYq8PuzchMwx0wd3SInitGzhNQe2biw2Njl+xdNuWjk=";
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
    };
    keybindings = [{
      key = "Enter";
      command = "rust-analyzer.onEnter";
      when = "editorTextFocus && !suggestWidgetVisible && editorLangId == rust";
    }];
  };
  home.packages = with pkgs; [ rustup nixfmt nodePackages.prettier ];
}
