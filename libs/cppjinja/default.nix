{
    stdenv
  , boost_shared
  , cmake
  , ninja
  , helpers
}:
stdenv.mkDerivation {
  name = "cppjinja-alfa";

  meta = {
    description = "jinja parser and generator with boost.spirit";
    site = "https://cpphttpx.org/repos/cppjinja";
  };

  nlohman_json_header = helpers.nlohman_json_header;

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ boost_shared helpers.turtle ];

  src = builtins.fetchurl {
    url = "http://cpphttpx.org/repos/cppjinja/tarball/e8f0c81bfc/cppjinja_-e8f0c81bfc.tar.gz";
    sha256 = "1v71xg8zk4kqkxsv3ps50npxmv2ql7v59pvx2jx484v9lilkmscq";
  };
}
