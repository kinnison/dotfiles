{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode-with-extensions.override {
      vscodeExtensions = (
        with pkgs.unstable.vscode-extensions; [
          matklad.rust-analyzer
          ms-python.python
          ms-vscode.cpptools
          ms-vscode-remote.remote-ssh
          ms-vsliveshare.vsliveshare
          jnoortheen.nix-ide
          brettm12345.nixfmt-vscode
          eamodio.gitlens
          usernamehw.errorlens
          tamasfe.even-better-toml
          esbenp.prettier-vscode
        ]
      ) ++ pkgs.unstable.vscode-utils.extensionsFromVscodeMarketplace [
        {
          publisher = "rubymaniac";
          name = "vscode-direnv";
          version = "0.0.2";
          sha256 =
            "4d5be329d297784c699f2521f9f0cf97e79276543387b96df3149fc35620b4be";
        }
        {
          publisher = "serayuzgur";
          name = "crates";
          version = "0.5.9";
          sha256 =
            "60721b9e5d91ee5ab02478bca94408982971f4c5a6fb93dcd76bd8c3b7bf4650";
        }
        {
          publisher = "karunamurti";
          name = "tera";
          version = "0.0.6";
          sha256 =
            "a25976987696ead8a700bf5c0da206369bad6b8b145e52ab4cb894a4b19dd208";
        }

      ];
    };
    userSettings = {
      "update.channel" = "none";
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

    };
    keybindings = [
      {
        key = "Enter";
        command = "rust-analyzer.onEnter";
        when = "editorTextFocus && !suggestWidgetVisible && editorLangId == rust";
      }
    ];
  };
  home.packages = with pkgs; [ rustup nixfmt ];
}
