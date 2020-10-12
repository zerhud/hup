{  pkgs ? import <nixpkgs> {}
 , stdenv ? pkgs.stdenv
 , cmake
 , ninja
 , boost
}:
stdenv.mkDerivation rec {
  name = "turtle";
  meta = { description = "Boost like mock framework."; website = "https://github.com/mat007/turtle"; };
  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ boost ];
  src = builtins.fetchGit {
    url = "https://github.com/mat007/turtle.git";
    name = "turtle.git";
    rev = "bfd1701fcbbb77258ce82dec5a755ff969cbadd3";
  };
}
