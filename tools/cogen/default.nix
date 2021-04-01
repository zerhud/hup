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
  , vscode
  , clion ? null
  , jq
}:

let
  clcov_deps = if enable_clcov then [clang clang_tools] else [];

in
stdenv.mkDerivation rec {
  pname = "cogen-alfa";
  version = "0.2.0";

  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cogen/tarball/5729bba065/modegen-5729bba065.tar.gz";
    sha256 = "1k5qp64mc6xxcqrip0sndccazj3iw8w0ic738yxfp81b4lb6969p";
  };

  CTEST_OUTPUT_ON_FAILURE=1;
  PYTHONDONTWRITEBYTECODE=1;
  nativeBuildInputs = [ cmake ninja vscode clion jq ] ++ clcov_deps;
  buildInputs = [
    # for generation
    python3 py_jinja pytest
    cppjinja
    # for build excutable file
    boost helpers.turtle pybind11
  ];
}
	
