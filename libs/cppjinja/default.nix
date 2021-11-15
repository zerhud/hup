{
    stdenv
  , boost_shared
  , cmake
  , ninja
  , helpers
  , clang_tools
  , cmake_helpers
  , commit ? "2d4435e57678f"
  , commit_sha256 ? "06q39sphdlxkbi3243bwdvlsizb040x1jndm4kpg5va8svn22wgl"
  , build_number ? 3
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
