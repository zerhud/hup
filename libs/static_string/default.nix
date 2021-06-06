{
    stdenv
  , boost
  , cmake
  , ninja
  , pkgs
  , rev ? "e905ac7928"
  , rev_sha256 ? "1g6ykymchildpff0g8l0nk5wz50xad4mrbl2nm0kniim24dh9vfi"
}:
stdenv.mkDerivation rec {
  name = "cppauth";
  version = "alpha";
  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ ];
  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/static_string/tarball/${rev}/static_string-${rev}.tar.gz";
    sha256 = "${rev_sha256}";
  };
}


