{
    stdenv
  , boost
  , cmake
  , ninja
  , pkgs
  , rev ? "7ba843eefb"
  , rev_sha256 ? "05sjf0qfk41flpha40jds990mjg7m2zrmbig25j0pxfsfb9xaz9a"
}:
stdenv.mkDerivation rec {
  name = "cppdb";
  version = "alpha";
  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ boost pkgs.sqlite ];
  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cppdb/tarball/${rev}/cppdb-${rev}.tar.gz";
    sha256 = "${rev_sha256}";
  };
}


