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
    modegen = callPackage ./tools/modegen {
      boost = boost_stable;
      stdenv = pkgs.llvmPackages_7.stdenv;
    };

    cppjinja = callPackage ./libs/cppjinja {
      boost_shared=boost_stable;
    };

    # libraries and tools
    helpers = callPackage ./helpers.nix {};
    boost_stable = pkgs.boost169;
    boost_orig = pkgs.boost17x.override{ enableShared = true; enableStatic = true; };
    boost = boost_orig.overrideDerivation(
      old:{
        version="1.71.0";
        src = pkgs.fetchurl {
          url = "http://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.gz";
          sha256 = "1ggmjp647n6bsykpdkvyg6wxzwx2y49vivr0c0gi8spjd1s4zcwn";
        };
      } );
    boost_shared = boost.override{ enableShared = true; enableStatic = false; };
    boost_static = boost.override{ enableShared = false; enableStatic = true; };
    boost_all = boost.override{ enableShared = true; enableStatic = true; };
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
  inherit stdenv modegen cppjinja fossil;
}

