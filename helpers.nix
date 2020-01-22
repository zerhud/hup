{ callPackage, pkgs }:

rec {
  nlohman_json_header = callPackage ./helpers/nlohman_json_header.nix {};
  turtle = callPackage ./helpers/turtle.nix {};
  cmake = callPackage ./helpers/cmake.nix {};
}

