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
    url = "http://cpphttpx.org/repos/cppjinja/tarball/5dbe937587/cppjinja_-5dbe937587.tar.gz";
    sha256 = "0c7w4l01alr8zkkpdr1zs1kmnhbdl9dc3kskmpk0yvhhak0srpzk";
  };
}
