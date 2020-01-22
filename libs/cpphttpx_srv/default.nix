{
    stdenv
  , boost
  , cmake
  , ninja
  , helpers
  , pkgs
}:
stdenv.mkDerivation {
  name = "cpphttpx_srv";

  meta = {
    description = "abstract web server using cpp";
    site = "https://cpphttpx.org/repos/cpp_httpx_server";
  };

  nativeBuildInputs = [ pkgs.pkgconfig cmake ninja helpers.cmake ];
  buildInputs = [
    boost helpers.turtle
    pkgs.h2o pkgs.libuv
    pkgs.openssl pkgs.hiredis pkgs.zlib
  ];

  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cpp_httpx_server/tarball/24dc7b77e6/cpphttpxsrv-24dc7b77e6.tar.gz";
    sha256 = "0wn492fccgssw1kjr811b0dk954l5chpbfx69h2f3p92id1faa8j";
  };
}

