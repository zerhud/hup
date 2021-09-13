{
    stdenv
  , enable_clcov
  , python3
  , python3Packages
  , boost
  , cmake
  , ninja
  , clang
  , clang_tools
  , pybind11
  , helpers
  , cppjinja
  , vscode
  , jq
  , rev ? "f634fc9537"
  , sha256_rev ? "1lz697ik43v9hci55yrfbm49yg3a8y9dqlzaxv27hw5q845bzkxg"
  , build_version ? 1
}:

let
  clcov_deps = if enable_clcov then [clang clang_tools] else [];
  python_pkgs = ppkgs : with ppkgs; [ jinja2 pytest ];
  python = python3.withPackages python_pkgs;

in
stdenv.mkDerivation rec {
  pname = "cogen-alpha";
  version = "0.3.0.${builtins.toString build_version}";
  inherit build_version;

  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cogen/tarball/${rev}/cogen-${rev}.tar.gz";
    sha256 = sha256_rev;
  };

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  CTEST_OUTPUT_ON_FAILURE=1;
  PYTHONDONTWRITEBYTECODE=1;
  nativeBuildInputs = [ cmake ninja vscode jq ] ++ clcov_deps;
  buildInputs = [
    # for generation
    python cppjinja
    # for build excutable file
    boost helpers.turtle pybind11
  ];
}

