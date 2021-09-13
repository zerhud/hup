{   pkgs
  , stdenv ? pkgs.gcc10Stdenv
  , enable_clcov ? false
}:
let
  callPackage = pkgs.lib.callPackageWith self;
  self = rec {
    inherit stdenv enable_clcov pkgs callPackage;

    # compilers utils
    cmake = pkgs.cmake;
    ninja = pkgs.ninja; 
    clang = pkgs.llvmPackages_latest.clang;
    clang_tools = pkgs.llvmPackages_latest.tools.llvm;
    vscode = pkgs.vscode;
    python3Packages = pkgs.python3Packages;

    # own projects
    cmake_helpers=helpers.cmake;
    cogen = callPackage ./tools/cogen {
      boost = boost_last;
      jq = pkgs.jq;
    };

    cpphttpx_srv = callPackage ./libs/cpphttpx_srv {
      boost=boost_all;
      h2o = pkgs.h2o;
    } ;
    cppjinja = callPackage ./libs/cppjinja {
      boost_shared=boost_shared;
    };

    zero_queue = callPackage ./libs/zero_queue {};
    cppoms = callPackage ./libs/cppoms {};
    cppcache = callPackage ./libs/cppcache {};
    static_string = callPackage ./libs/static_string {};
    cppauth = callPackage ./libs/cppauth {boost=boost_last;};

    # libraries and tools
    cppdb = callPackage ./libs/cppdb {};
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
    fossil = callPackage ./tools/fossil.nix {} ;
    pistache = callPackage ./libs/pistache {} ;
    libuv = pkgs.libuv.overrideAttrs ( old: rec{
      version = "1.40.0";
      src = pkgs.fetchFromGitHub {
        owner = old.pname;
        repo = old.pname;
        rev = "v${version}";
        sha256 = "1hd0x6i80ca3j0c3a7laygzab5qkgxjkz692jwzrsinsfhvbq0pg";
      };
    });
    h2o = pkgs.h2o.overrideAttrs ( old: rec{
      version = "2.3.0-beta3";
      nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.perl] ;
      buildInputs = [ pkgs.openssl libuv pkgs.zlib pkgs.brotli ];
      outputs = [ "out" ];
      src = pkgs.fetchFromGitHub {
        owner  = "h2o";
        repo   = "h2o";
        rev    = "2975e99433e37057daf2d7fb4f5eda387d932ef4";
        sha256 = "1dp7f06gb18gvywgc3m5xpwnx0ra61gsjxqnl28xiw8n2fbz9z1v";
      };
    });

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
  cogen cppjinja
  static_string
  zero_queue cppoms cppcache cppauth
  cpphttpx_srv
  h2o fossil pistache cppdb
  ;
}

