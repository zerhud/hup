{
    stdenv
  , boost
  , cmake
  , ninja
  , pkgs
  , cogen
  , zero_queue
  , cppcache
  , cppdb
  , cppoms
  , static_string
  , cmake_helpers
  , rev ? "8646479b30"
  , rev_sha256 ? "1h48i3dl3ihmfiy0khrflm642il0r0yi5q7sm2gm3dpkwyymv1kb"
}:
stdenv.mkDerivation rec {
  name = "cppauth";
  build_version = 0;
  version = "0.1.0.${builtins.toString build_version}";
  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [
    boost pkgs.sqlite
    static_string
    cogen zero_queue cppcache cppdb cppoms cmake_helpers ];
  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cppauth/tarball/${rev}/cppauth-${rev}.tar.gz";
    sha256 = "${rev_sha256}";
  };
}

