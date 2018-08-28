{ pkgs }:

let
  buildEnv = args: pkgs.buildEnv (args // {
    extraOutputsToInstall = [ "man" "doc" ];
  });

in
  {
    allowUnfree = true;
  
    packageOverrides = pkgs: rec {
      protovim = import packages/protovim/default.nix { inherit pkgs; };
  
      protoenv = buildEnv {
        name = "protoenv";
        paths = [
          pkgs.mlterm
          pkgs.firefox-bin
          pkgs.tig
          pkgs.termite
          pkgs.gitAndTools.hub
          pkgs.megatools
          pkgs.mplayer
          pkgs.shutter
          pkgs.mupdf

          protovim
        ];
      };
  
      latex-dev = buildEnv {
        name = "latex-dev";
        paths = [ pkgs.texlive.combined.scheme-full ];
      };
  
      haskell-dev = buildEnv {
        name = "hsdev";
        paths = with pkgs.haskellPackages; [ stack hoogle ];
      };
    };
  }
