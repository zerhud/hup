{  pkgs ? import <nixpkgs> {}
 , stdenv ? pkgs.stdenv
 , cmake
 , ninja
}:
stdenv.mkDerivation rec {
  name = "cmake_helpers";
  meta = { description = "CMake utils for simple package using."; };

  nativeBuildInputs = [cmake ninja];

  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cmake_helpers/tarball/9b79c7a6c3/cmake-helpers-9b79c7a6c3.tar.gz";
    sha256 = "0z99468i3avvidd3lgmqksxx13yqambxa4lslin15qc2xqfg49bs";
  };
}

