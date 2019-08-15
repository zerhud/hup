{ 
    system ? builtins.currentSystem
  , pkgs ? import<nixos-unstable> { inherit system; }
  , enable_clcov ? true
  , stdenv ? pkgs.clangStdenv
}:
import ./default.nix {
  inherit pkgs stdenv enable_clcov;
  }

