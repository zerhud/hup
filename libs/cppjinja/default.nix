{
    stdenv
  , boost_shared
  , cmake
  , ninja
  , helpers
  , clang_tools
  , cmake_helpers
}:
let
  commit = "7f98b4a7b1";
  commit_sha256 = "1zacgpf6n3fvxyws9ihdpd5v5drhhkvjvnig4n5ra8bhrii6fdi7";
in stdenv.mkDerivation {
  name = "cppjinja-alpha";

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
