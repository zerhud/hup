{
    stdenv
  , boost
  , cmake
  , ninja
  , helpers
  , pytest
  , pyreq
  , pkgs
  , rev ? "d529875a8a"
  , rev_sha256 ? "1mqy4vbd28hjvwyn2ic9cqjc3n3s0j2yrfwbrl8x0qy4idxs0xfk"
  , sockjs_ver ? "1.5.1"
  , sockjs_sha256 ? "0s6bwlmr24xv3mdb4p96q41h2pjkh31qq91kbq3mj2l8pbybmcmy"
}:
let
  #curl = pkgs.curl.override { stdenv=stdenv; };
  #curlcpp = pkgs.curlcpp.override { stdenv=stdenv; };
  curl = stdenv.mkDerivation rec {
    name = "curl";
    buildInputs = [ cmake pkgs.openssl ];
    src = pkgs.fetchFromGitHub {
      owner = "curl";
      repo = "curl";
      rev = "c6e213e";
      sha256 = "0sg7l934h1rk8jc54h350mj22lml7r1g5gkvw62z32m7zsf3k63g";
    };
  };
  curlcpp = stdenv.mkDerivation rec { 
    name = "curlcpp";
    revision = "749c17f";
    meta = with pkgs.lib; {
      homepage = "https://josephp91.github.io/curlcpp/";
      description = "Object oriented C++ wrapper for CURL";
      platforms = platforms.unix;
      license = licenses.mit;
      #maintainers = with maintainers; [ rszibele ];
    };
    src = pkgs.fetchFromGitHub {
      owner = "JosephP91";
      repo = "curlcpp";
      rev = revision;
      sha256 = "1nn8fcpnd9cwr94p03006awz78mfzg6ich65cg9wiidkzph01yrf";
    };
    buildInputs = [ cmake pkgs.curl ];
  };
  libh2o = stdenv.mkDerivation rec {
    name = "libh2o";
    src = pkgs.fetchFromGitHub {
      owner = "h2o";
      repo = "h2o";
      rev = "2c5b415";
      sha256 = "01hkhmnp5msgnqzksp6vzyw2imkcg0vcffafvck6j31dw6km5nzb";
    };
  };
in stdenv.mkDerivation {
  name = "cpphttpx_srv";

  meta = {
    description = "abstract web server using cpp";
    site = "https://cpphttpx.org/repos/cpp_httpx_server";
  };

  nativeBuildInputs = [
    pkgs.pkgconfig cmake ninja
    helpers.cmake
    pytest pyreq
  ];
  buildInputs = [
    boost helpers.turtle
    (pkgs.h2o.overrideAttrs (old: rec{enableDebugging=true;separateDebugInfo=true;}))
    (pkgs.libuv.overrideAttrs (old: rec{enableDebugging=true;separateDebugInfo=true;}))
    pkgs.icu
    curl curlcpp pkgs.http-parser
    pkgs.openssl pkgs.hiredis pkgs.zlib
    pkgs.python3 pkgs.python3Packages.tornado
  ];

  uvRequest = builtins.fetchurl {
    url = "https://github.com/ivere27/SimpleHttpRequest/raw/master/SimpleHttpRequest.hpp";
    sha256 = "0q0ny2bfyxaj82nxsifnl7hcllhjpkhn731yyc33fj0nrbxlid2c";
  };
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

