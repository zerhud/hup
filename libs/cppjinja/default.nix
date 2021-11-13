{
    stdenv
  , boost_shared
  , cmake
  , ninja
  , helpers
  , clang_tools
  , cmake_helpers
  , commit ? "36f80239a1"
  , commit_sha256 ? "1xidjv07l7hj89i2qmh64q4s60q077g3wjmdff30czwz478fpmhp"
  , build_number ? 1
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
