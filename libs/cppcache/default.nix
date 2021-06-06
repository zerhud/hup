{
    stdenv
  , boost
  , cmake
  , ninja
  , zero_queue
  , rev ? "1df2c74476"
  , rev_sha256 ? "1k094n7hl83zfrrry4pc71r36lalc60z2mrn1rd9ff81wgg8wha4"
}:
stdenv.mkDerivation rec {
  name = "cppcache";
  version = "alpha";
  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ boost ];
  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cppcache/tarball/${rev}/cppcache-${rev}.tar.gz";
    sha256 = "${rev_sha256}";
  };
}

