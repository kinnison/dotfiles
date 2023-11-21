{ pkgs, dotroot, ... }: {
  home.file.".ssh" = {
    source = "${dotroot}/ssh";
    recursive = true;
    onChange = ''
      _setup_sshauthkeys () {
          echo "Trying to configure SSH authorized_keys..."
          local confroot
          confroot="$HOME"/.ssh
          $DRY_RUN_CMD cat "''${confroot}/authorized_keys.store" > "''${confroot}/authorized_keys"
      }
      _setup_sshauthkeys
      unset _setup_sshauthkeys
    '';
  };
}
