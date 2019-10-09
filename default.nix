{   pkgs ? import <nixpkgs> {}
  , stdenv ? pkgs.gcc9Stdenv
  , enable_clcov ? false
}:
let
  #stdenv = pkgs.gcc9Stdenv;
  callPackage = stdenv.lib.callPackageWith self;
  self = rec {
    inherit stdenv enable_clcov pkgs callPackage;

    # compilers utils
    cmake = pkgs.cmake;
    ninja = pkgs.ninja; 
    clang = pkgs.llvmPackages_8.clang;
    llvm = pkgs.llvm_8;

    # own projects
    modegen = callPackage ./tools/modegen { };
    cppjinja = callPackage ./libs/cppjinja {};

    # libraries and tools
    helpers = callPackage ./helpers.nix {};
    boost = pkgs.boost169;
    py_jinja = pkgs.python3Packages.jinja2;
    fossil = callPackage ./tools/fossil.nix {} ;

    # patched libraries
    python3 = pkgs.python3.overrideAttrs( old : {
        postPatch = old.postPatch + ''
        sed -i '55d' Modules/_decimal/libmpdec/context.c
        '';
    });
    pybind11 =
        (pkgs.pybind11.override { python = python3; })
        .overrideAttrs( old : {
            doCheck = true;
            cmakeFlags = old.cmakeFlags ++ ["-DPYBIND11_TEST=OFF"];
        }) ;
  };
in with self; rec {
  inherit modegen cppjinja fossil;
}

