{
    stdenv
  , enable_clcov
  , python3
  , py_jinja
  , boost
  , cmake
  , ninja
  , clang
  , llvm
  , pybind11
  , helpers
  , cppjinja
}:

let
  clcov_deps = if enable_clcov then [clang llvm] else [];

in
stdenv.mkDerivation rec {
  name = "modegen-alfa";
  version = "0.2.0";

  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/modegen/tarball/c20624c608/modegen-c20624c608.tar.gz";
    sha256 = "10cnzhmin8m42icdwp8w8vy98z94dlq6cydpqkr91vn28h55zz88";
  };

  nlohman_json_header = helpers.nlohman_json_header;

  nativeBuildInputs = [ cmake ninja ] ++ clcov_deps;
  buildInputs = [
    # for generation
    python3 py_jinja cppjinja
    # for build excutable file
    boost helpers.turtle pybind11
  ];
}
	
