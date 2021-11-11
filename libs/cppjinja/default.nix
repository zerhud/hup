{
    stdenv
  , boost_shared
  , cmake
  , ninja
  , helpers
  , clang_tools
  , cmake_helpers
  , commit ? "37a68764f4"
  , commit_sha256 ? "1gvd6hxr3xfd2zn7r17j6xis3jl0m6qagl4v0hr3pl47valjv28q"
  , build_number ? 4
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
