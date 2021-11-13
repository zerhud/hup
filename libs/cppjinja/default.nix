{
    stdenv
  , boost_shared
  , cmake
  , ninja
  , helpers
  , clang_tools
  , cmake_helpers
  , commit ? "3d3bd1dd916bfb5"
  , commit_sha256 ? "0nw1qw4ivshgq6gd1rmrx7j95rzdalabk14a8ps1a450pidijsk5"
  , build_number ? 2
}:
stdenv.mkDerivation {
  name = "cppjinja-alpha";
  inherit build_number;

  meta = {
    description = "jinja parser and generator with boost.spirit";
    site = "https://cpphttpx.org/repos/cppjinja";
  };

  nlohman_json_header = helpers.nlohman_json_header;

  nativeBuildInputs = [ cmake ninja clang_tools cmake_helpers ];
  buildInputs = [ boost_shared helpers.turtle ];

  cmakeFlags = ["-DENABLE_TESTS=OFF"];
  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cppjinja/tarball/${commit}/cppjinja-${commit}.tar.gz";
    sha256 = commit_sha256;
  };
}
