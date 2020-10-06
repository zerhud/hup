{   pkgs ? import <nixpkgs> {}
  , stdenv ? pkgs.gcc10Stdenv
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
    clang = pkgs.llvmPackages_latest.clang;
    clang_tools = pkgs.llvmPackages_latest.tools.llvm;

    # own projects
    cmake_helpers=helpers.cmake;
    modegen = callPackage ./tools/modegen {
      boost = boost_shared;
      stdenv = pkgs.gcc10Stdenv;
    };

    cpphttpx_srv = callPackage ./libs/cpphttpx_srv { boost=boost_cmakebug; } ;
    cppjinja = callPackage ./libs/cppjinja {
      #boost_shared=boost_stable;
      boost_shared=boost_shared;
      stdenv = pkgs.gcc10Stdenv;
    };

    # libraries and tools
    helpers = callPackage ./helpers.nix {};
    boost_stable = pkgs.boost169;
    boost_orig = pkgs.boost17x.override{ enableShared = true; enableStatic = true; };
    boost = boost_orig.overrideDerivation(
      old:{
        patches = [];
        version="1.74.0";
        postInstall = ''
          mkdir $dev/lib
          ln -st $dev/lib $out/lib/lib*
          '';
        src = pkgs.fetchurl {
          url = "http://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.gz";
          sha256 = "19clvfjazc2im8rp5m631rrzgxnifz0li487mjy20lc8jb9kdzxg"; # 1.74
          #sha256 = "1kvsdjpji8kql8xy3iak582z68k4xgwifab9alvpja45ws9f35cr"; # 1.73
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

