# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python31-docs-pdf-letter-3.1.5";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.1.5/python-3.1.5-docs-pdf-letter.tar.bz2;
    sha256 = "0s202vrjfa8dnp3vpfjb21bmqym9wyj8jn2glgwjzk63z6fwb60i";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python31
    cp -R ./ $out/share/doc/python31/pdf-letter
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
