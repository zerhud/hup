{   pkgs ? import <nixpkgs> {}
  , stdenv ? pkgs.gcc10Stdenv
  , enable_clcov ? false
}:
let
  callPackage = stdenv.lib.callPackageWith self;
  self = rec {
    inherit stdenv enable_clcov pkgs callPackage;

    # compilers utils
    cmake = pkgs.cmake;
    ninja = pkgs.ninja; 
    clang = pkgs.llvmPackages_latest.clang;
    clang_tools = pkgs.llvmPackages_latest.tools.llvm;
    vscode = pkgs.vscode;
    clion = pkgs.jetbrains.clion;

    # own projects
    cmake_helpers=helpers.cmake;
    modegen = callPackage ./tools/modegen {
      boost = boost_last;
    };

    cpphttpx_srv = callPackage ./libs/cpphttpx_srv { boost=boost_cmakebug; } ;
    cppjinja = callPackage ./libs/cppjinja {
      boost_shared=boost_shared;
    };

    # libraries and tools
    boost_json = stdenv.mkDerivation {
      name = "boost_json";
      cmakeFlags = [ "-DBOOST_JSON_STANDALONE=ON" "-DBOOST_JSON_BUILD_TESTS=OFF" ];
      nativeBuildInputs = [ pkgs.cmake ];
      src = pkgs.fetchFromGitHub {
        owner = "boostorg";
        repo = "json";
        rev = "76ee8891d20167a2192aa594b7d2c702be2b9c20";
        sha256 = "0rag2cf9msvasxrk7kqh2avsivqn1w69zr584bxpfa41pjxi6rbb";
      };
    };
    helpers = callPackage ./helpers.nix {};
    boost = boost_shared;
    boost_orig = pkgs.boost17x.override{ enableShared = true; enableStatic = true; };
    boost_last = boost_orig;
    boost_shared = boost_last.override{ enableShared = true; enableStatic = false; };
    boost_static = boost_last.override{ enableShared = false; enableStatic = true; };
    boost_all = boost_last.override{ enableShared = true; enableStatic = true; };
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

