{
    stdenv
  , enable_clcov
  , python3
  , py_jinja
  , pytest
  , boost
  , cmake
  , ninja
  , clang
  , clang_tools
  , pybind11
  , helpers
  , cppjinja
  , boost_json
  , vscode
  , clion ? null
  , jq
}:

let
  clcov_deps = if enable_clcov then [clang clang_tools] else [];

in
stdenv.mkDerivation rec {
  pname = "modegen-alfa";
  version = "0.2.0";

  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/modegen/tarball/c20624c608/modegen-c20624c608.tar.gz";
    sha256 = "10cnzhmin8m42icdwp8w8vy98z94dlq6cydpqkr91vn28h55zz88";
  };

  CTEST_OUTPUT_ON_FAILURE=1;
  PYTHONDONTWRITEBYTECODE=1;
  nativeBuildInputs = [ cmake ninja vscode clion jq ] ++ clcov_deps;
  buildInputs = [ boost_json
    # for generation
    python3 py_jinja pytest
    cppjinja
    # for build excutable file
    boost helpers.turtle pybind11
  ];
}
	
