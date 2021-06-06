{
    stdenv
  , boost
  , cmake
  , ninja
  , rev ? "b251aea1f8"
  , rev_sha256 ? "0p7mzia7li4y8a9xxpi9za4k5q60ac6rlq3cazqv7spccfhlkpda"
}:
stdenv.mkDerivation rec {
  name = "zero_queue";
  version = "alpha";
  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ boost ];
  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/zero_queue/tarball/${rev}/ZeroQueue-b251aea1f8.tar.gz";
    sha256 = "${rev_sha256}";
  };
}
