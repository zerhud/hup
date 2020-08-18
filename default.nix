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
    clang_tools = pkgs.llvmPackages_latest.tools.llvm;

    # own projects
    cmake_helpers=helpers.cmake;
    modegen = callPackage ./tools/modegen {
      boost = boost_stable;
      stdenv = pkgs.llvmPackages_7.stdenv;
    };

    cpphttpx_srv = callPackage ./libs/cpphttpx_srv { boost=boost_cmakebug; } ;
    cppjinja = callPackage ./libs/cppjinja {
      #boost_shared=boost_stable;
      boost_shared=boost_shared;
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
    boost_cmakebug = boost_orig.overrideAttrs( attrs: {
      postInstall = ''
        echo "''${!outputDev}/lib/cmake/"*/*.cmake > $out/foo
        echo "''${!outputLib}/lib/cmake/"*/*.cmake >> $out/foo

        for file in "''${!outputLib}/lib/cmake/"*/*.cmake; do
          substituteInPlace $file \
            --replace "get_filename_component(_BOOST_CMAKEDIR" "get_filename_component(_BOOST_CMAKEDIR "''${!outputDev}/lib/cmake/" ABSOLUTE)#"   \
            --replace "get_filename_component(_BOOST_INCLUDEDIR" "get_filename_component(_BOOST_INCLUDEDIR "''${!outputDev}/include/" ABSOLUTE)#" \
            --replace "get_filename_component(_BOOST_LIBDIR" "get_filename_component(_BOOST_LIBDIR "''${!outputLib}/lib/" ABSOLUTE)#"
        done
      '';
    });
    py_jinja = pkgs.python3Packages.jinja2;
    fossil = callPackage ./tools/fossil.nix {} ;
    pistache = callPackage ./libs/pistache {} ;

    # patched libraries
    python3_clean = pkgs.python38.overrideAttrs( old : {
        postPatch = old.postPatch + ''
        sed -i '55d' Modules/_decimal/libmpdec/context.c
        '';
    });
	python_packages = pp: with pp; [ jinja2 ];
	python3 = python3_clean.withPackages python_packages;
    pybind11 =
        python3_clean.pkgs.pybind11
        #.overrideAttrs( old : {
        #	doInstallCheck = true;
		#	installCheckTarget = "install";
        #	cmakeFlags = old.cmakeFlags ++ ["-DPYBIND11_TEST=OFF"];
        #})
		;
  };
in with self; rec {
  inherit
  stdenv
  modegen cppjinja
  cpphttpx_srv
  fossil pistache
  ;
}

