{
    stdenv
  , boost_shared
  , cmake
  , ninja
  , helpers
  , clang_tools
  , cmake_helpers
}:
stdenv.mkDerivation {
  name = "cppjinja-alfa";

  meta = {
    description = "jinja parser and generator with boost.spirit";
    site = "https://cpphttpx.org/repos/cppjinja";
  };

  nlohman_json_header = helpers.nlohman_json_header;

  nativeBuildInputs = [ cmake ninja clang_tools cmake_helpers ];
  buildInputs = [ boost_shared helpers.turtle ];

  cmakeFlags = ["-DENABLE_TESTS=OFF"];
  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cppjinja/tarball/7a5c9ea8b1/cppjinja_-7a5c9ea8b1.tar.gz";
    sha256 = "1q328ckwax9i979q1fi2ry14z8gbws3d4r9dhhvsgknjqmfqsz20";
  };
}
