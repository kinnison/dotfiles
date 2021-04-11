{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
    extensions = with pkgs.unstable.vscode-extensions; [
      matklad.rust-analyzer
      ms-python.python
      ms-vscode.cpptools
      ms-vscode-remote.remote-ssh
      ms-vsliveshare.vsliveshare
      jnoortheen.nix-ide
      brettm12345.nixfmt-vscode
      eamodio.gitlens
      usernamehw.errorlens
    ];
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
  };
  home.packages = with pkgs; [ rustup nixfmt ];
}
