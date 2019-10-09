{ pkgs }:
pkgs.fossil.overrideDerivation ( oldAttrs: {

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.sedutil ];
  postPatch = ''
      sed -i '238i#define MARKUP_INPUT              62' src/wikiformat.c
      sed -i '253i#define MUTYPE_TRICK       0x0800   /* css3 tricks: <input> */' src/wikiformat.c
      sed -i '376i\ { "input",         MARKUP_INPUT,        MUTYPE_TRICK,       AMSK_STYLE|AMSK_NAME|AMSK_TYPE },' src/wikiformat.c
      sed -i '58s/owner FROM/owner, mtime FROM/' src/report.c
      sed -i '58s/ORDER BY title/ORDER BY mtime DESC, title/'  src/report.c
    '';

} )

