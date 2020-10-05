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
    url = "http://cpphttpx.org/repos/cppjinja/tarball/331a2b4fcc/cppjinja_-331a2b4fcc.tar.gz";
    sha256 = "0vcvwzkrgxkgd7r6wdmzlqpdr7i7m2k4b0hb0gxnjq9axqgpzkwy";
  };
}
