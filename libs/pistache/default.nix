{
    stdenv
  , cmake
  , ninja
  , pkgs
  , helpers

  , build_examples ? true
}:
stdenv.mkDerivation {
  name = "pistache";
  meta = {
    description = "http c++11 library, has no dependecy";
    site = "http://pistache.io/";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = if build_examples then [ pkgs.rapidjson ] else [] ;
  cmakeFlags = if build_examples then [ "-DPISTACHE_BUILD_EXAMPLES=OFF" ] else [] ;

  src = pkgs.fetchFromGitHub {
    owner = "oktal";
    repo = "pistache";
    rev = "ad197179366242c4c549cf8fd475ca5f82bb105f";
    sha256 = "1rssxiwn65g8i61hsps3591x2n9y7lsg8jqpqqdpnmk5l3vfrfss";
  };
}

