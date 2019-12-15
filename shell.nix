{ 
    system ? builtins.currentSystem
  , pkgs ? import<nixos-unstable> { inherit system; }
  , enable_clcov ? true
  , stdenv ? pkgs.llvmPackages_latest.stdenv
}:
import ./default.nix {
  inherit pkgs stdenv enable_clcov;
  }

