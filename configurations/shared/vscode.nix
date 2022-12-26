{ pkgs, ... }:
let
  #r-a-package = pkgs.local.rust-analyzer-unwrapped;
  r-a-package = pkgs.unstable.rust-analyzer-unwrapped;
  rustup-package = pkgs.unstable.rustup;
  # Maybe change this later?
  base = pkgs;
  orig-ext = pkgs.vscode-extensions;
  package = base.vscode-with-extensions.override {
    vscodeExtensions = (with base.vscode-extensions; [
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
      vadimcn.vscode-lldb
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
        publisher = "rust-lang";
        name = "rust-analyzer";
        version = "0.4.1332";
        sha256 = "sha256-kutMZfbIdoR1gBc/NOgd3jfJpIZ9iaBbAD3zNjGlP6E=";
      }
      {
        publisher = "ms-vscode-remote";
        name = "remote-containers";
        version = "0.242.0";
        sha256 = "sha256-cLHa0E0izNu2QYQBQ0qUlCIXsJmvc7Q6kgR6F3hnMX8=";
      }
      # {
      #   publisher = "dendron";
      #   name = "dendron";
      #   version = "0.115.1";
      #   sha256 = "sha256-4fQRb2ubSrUtVFD2mVdrP/1dWTdYJ6anmXDKtCKglOc=";
      # }
      # {
      #   publisher = "dendron";
      #   name = "dendron-paste-image";
      #   version = "1.1.1";
      #   sha256 = "sha256-SlW8MEWBgf8cJsdSzeegqPiAlEvlnrxuvrJJdhHwq2E=";
      # }
      # {
      #   publisher = "dendron";
      #   name = "dendron-markdown-shortcuts";
      #   version = "0.12.1";
      #   sha256 = "sha256-Kmjm1xQvrt228XNSRkLUu6Yu3Oec4csJhi74zjsh3HY=";
      # }
      {
        publisher = "redhat";
        name = "vscode-yaml";
        version = "1.11.10112022";
        sha256 = "sha256-/ZD3LOf6d5dJJW7eGZgkrf4hj1CXZJNI0u06Bnmyo0Q=";
      }
      # {
      #   publisher = "vadimcn";
      #   name = "vscode-lldb";
      #   version = "1.7.0";
      #   sha256 = "sha256-DuYweIri8NpBHcIG37WyUUc+p4/TaBBHcI6x6YIRvmk=";
      # }
    ];
  };
  my-vscode-package = package // { pname = base.vscode.pname; };
in {
  programs.vscode = {
    enable = true;
    package = my-vscode-package;
    userSettings = {
      "update.mode" = "none";
      "rust-analyzer.server.path" = "${r-a-package}/bin/rust-analyzer";
      "rust-analyzer.checkOnSave.command" = "clippy";
      "rust-analyzer.hover.actions.references.enable" = true;
      "rust-analyzer.inlayHints.closureReturnTypeHints.enable" = "with_block";
      "rust-analyzer.inlayHints.lifetimeElisionHints.enable" = "skip_trivial";
      "rust-analyzer.lens.references.adt.enable" = true;
      "rust-analyzer.lens.references.method.enable" = true;
      "rust-analyzer.lens.references.trait.enable" = true;
      "rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames" = true;
      "rust-analyzer.inlayHints.typeHints.hideClosureInitialization" = true;
      "rust-analyzer.inlayHints.typeHints.hideNamedConstructor" = true;
      "rust-analyzer.lru.capacity" = 512;
      "rust-analyzer.typing.autoClosingAngleBrackets.enable" = true;
      "window.menuBarVisibility" = "toggle";
      "editor.minimap.enabled" = false;
      "editor.fontFamily" =
        "'Fira Code Sans Mono', 'Droid Sans Mono', 'monospace', monospace, 'Droid Sans Fallback'";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "nix.enableLanguageServer" = true;
      "workbench.editorAssociations" = { "*.ipynb" = "jupyter-notebook"; };
      "redhat.telemetry.enabled" = false;
    };
    keybindings = [{
      key = "Enter";
      command = "rust-analyzer.onEnter";
      when = "editorTextFocus && !suggestWidgetVisible && editorLangId == rust";
    }];
  };
  home.packages = with pkgs;
    [ rustup-package nixfmt nodePackages.prettier ] ++ [ r-a-package ];
}
