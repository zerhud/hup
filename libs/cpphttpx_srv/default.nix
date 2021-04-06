{
    stdenv
  , boost
  , cmake
  , ninja
  , helpers
  , pkgs
  , rev ? "d529875a8a"
  , rev_sha256 ? "1mqy4vbd28hjvwyn2ic9cqjc3n3s0j2yrfwbrl8x0qy4idxs0xfk"
  , sockjs_ver ? "1.5.1"
  , sockjs_sha256 ? "0s6bwlmr24xv3mdb4p96q41h2pjkh31qq91kbq3mj2l8pbybmcmy"
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
    pkgs.h2o pkgs.libuv pkgs.icu
    pkgs.openssl pkgs.hiredis pkgs.zlib
  ];

  sockjs_ver = sockjs_ver;
  sockjs_file = builtins.fetchurl {
    url = "https://github.com/sockjs/sockjs-client/archive/refs/tags/v${sockjs_ver}.tar.gz";
    sha256 = "${sockjs_sha256}";
  };

  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cpp_httpx_server/tarball/${rev}/cpphttpxsrv-${rev}.tar.gz";
    sha256 = "${rev_sha256}";
  };
}

