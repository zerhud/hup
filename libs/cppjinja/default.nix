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
    url = "http://cpphttpx.org/repos/cppjinja/tarball/8a95b391fe/cppjinja-8a95b391fe.tar.gz";
    sha256 = "17fi3sjfr01vayv0smsd1f2yz4agyj8cv11ql90ycddwp6sff3hd";
  };
}
