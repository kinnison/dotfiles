# Daniel's dotfiles

These are the dotfiles deployed as part of Daniel's NixOS host setup.

To use this usefully, you will need to be on a NixOS host deployed using
[my NixOS Host config](https://github.com/kinnison/nixos-hosts) and then
you can simply run "make rebuild-switch"

# Bootstrapping

Once a system has been built, you need to do the following to bootstrap
effectively:

1. Clone the password-store into ~/.local/share/password-store

# General maintenance

## Neomutt

Neomutt doesn't clean its header caches, so from time you time you'll want
to clear them yourself with `rm -rf ~/.cache/neomutt/headers`

## Mu

Mu can't be reinitialised with new addresses so you _may_ need to clear the mu
cache out `rm -rf ~/.cache/mu`
