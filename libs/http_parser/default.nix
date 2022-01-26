{
    stdenv
  , cmake
  , ninja
  , boost
  , pkgs
  , commit ? "1498e59b170634befa7938e7d31abe6f87d82819"
  , commit_sha256 ? "sha256-IxsK2yamAUJf2EzLfbgLNwRgomWtQRWd1NgvoDLaZQM="
  , build_number ? 0
}:
stdenv.mkDerivation rec {
  name = "http_parser";
  inherit build_number;

  meta = {
    description = "http parser without dependencies. uses c++20.";
    site = "https://github.com/zerhud/http_parser";
  };

  buildInputs = [ boost ];
  nativeBuildInputs = [ cmake ninja ];
  src = pkgs.fetchFromGitHub {
    owner = "zerhud";
    repo = "${name}";
    rev = commit;
    sha256 = commit_sha256;
  };
}
