{
    stdenv
  , boost
  , cmake
  , ninja
  , pkgs
  , zero_queue
  , cppcache
  , cppdb
  , static_string
  , rev ? "02595b7843"
  , rev_sha256 ? "1c2vs63aj1mr91kihpnc5y1346n2k1f59hvd7ah7v61haw8insk6"
}:
stdenv.mkDerivation rec {
  name = "cppdb";
  version = "alpha";
  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ boost static_string zero_queue cppcache cppdb pkgs.sqlite ];
  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cppoms/tarball/${rev}/cppoms-${rev}.tar.gz";
    sha256 = "${rev_sha256}";
  };
}



