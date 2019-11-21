{  pkgs ? import <nixpkgs> {}
 , stdenv ? pkgs.stdenv
}:
stdenv.mkDerivation rec {
  name = "turtle";
  meta = { description = "Boost like mock framework."; website = "https://github.com/mat007/turtle"; };
  buildCommand = "mkdir -p $out; cp -rt $out $src/include/*;";
  src = builtins.fetchGit {
    url = "https://github.com/mat007/turtle.git";
    name = "turtle.git";
    rev = "44e8509d6f79833251bd7dc04655109ec6dc407c";
  };
}
