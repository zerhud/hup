{
    stdenv
  , boost
  , cmake
  , ninja
  , helpers
  , pkgs
  , rev ? "0163945f50"
  , rev_sha256 ? "0wn492fccgssw1kjr811b0dk954l5chpbfx69h2f3p92id1faa9j"
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
    url = "http://cpphttpx.org/repos/cpp_httpx_server/tarball/${rev}/cpphttpxsrv-${rev}.tar.gz";
    sha256 = "${rev_sha256}";
  };
}

