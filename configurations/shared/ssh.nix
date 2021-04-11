{ pkgs, dotroot, ... }: {
  home.file.".ssh" = {
    source = "${dotroot}/ssh";
    recursive = true;
  };
}
