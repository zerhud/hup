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
  , rev ? "57575ea362"
  , sha256_rev ? "1v5wqxj37f0yc770rsf281wvqvyh4fddgd40maxzpkmv0531pp9w"
  , build_version ? 4
}:

let
  clcov_deps = if enable_clcov then [clang clang_tools] else [];

in
stdenv.mkDerivation rec {
  pname = "cogen-alpha";
  version = "0.2.0.${builtins.toString build_version}";
  inherit build_version;

  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cogen/tarball/${rev}/cogen-${rev}.tar.gz";
    sha256 = sha256_rev;
  };

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

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

