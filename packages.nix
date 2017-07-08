# vim: set expandtab tabstop=2 softtabstop=2 shiftwidth=2 autoindent:

lib: pkgs:

with pkgs;

rec {
  inherit pkgs;

  kitty = callPackage ./packages/kitty {};
}
