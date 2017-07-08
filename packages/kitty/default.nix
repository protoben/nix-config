# vim: set expandtab tabstop=2 softtabstop=2 shiftwidth=2 autoindent:

{ fetchgit
, fontconfig
, gcc
, glew
, glfw
, ncurses
, pkgconfig
, python35
, xrdb
, xsel
, stdenv
, pkgs
}:

stdenv.mkDerivation {
  name = "kitty-0.2.6";

  src = fetchgit {
    url = "https://github.com/kovidgoyal/kitty.git";
    rev = "b4d4ed718f7a864e1af67698e594c288ab9a2b80";
    sha256 = "15ai252qciw2gm0vdiv07jl4zkwvhniv7i3rhj8afp0vgyjrpwb0";
    fetchSubmodules = true;
  };

  buildInputs = [python35 glfw glew fontconfig xrdb xsel ncurses];

  nativeBuildInputs = [gcc pkgconfig];

  license = "GPL3";

  buildPhase = ''
    python3 setup.py linux-package
  '';

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/lib/
    mkdir -p $out/share/
    cp -r linux-package/bin/* $out/bin/
    cp -r linux-package/lib/* $out/lib/
    cp -r linux-package/share/* $out/share/
  '';
}
