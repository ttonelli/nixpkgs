{ stdenv, fetchurl, buildPythonPackage, pythonPackages, python }:

let
  i3-py = buildPythonPackage rec {
    version = "0.6.4";
    name = "i3-py-${version}";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/i/i3-py/i3-py-${version}.tar.gz";
      sha256 = "1sgl438jrb4cdyl7hbc3ymwsf7y3zy09g1gh7ynilxpllp37jc8y";
    };

    # no tests in tarball
    doCheck = false;
  };
in buildPythonPackage rec {
  name = "i3minator-${version}";
  version = "0.0.3";

  src = fetchurl {
    url = "https://github.com/carlesso/i3minator/archive/v${version}.tar.gz";
    sha256 = "0ksb0frrhq10k5rjzk72kj5rjzak1irr9q4x4f22w2vylxq19xxa";
  };

  propagatedBuildInputs = [ pythonPackages.pyyaml i3-py ];

  meta = with stdenv.lib; {
    description = "i3 project manager similar to tmuxinator";
    longDescription = ''
      A simple "workspace manager" for i3. It allows to quickly
      manage workspaces defining windows and their layout. The
      project is inspired by tmuxinator and uses i3-py.
    '';
    homepage = https://github.com/carlesso/i3minator;
    license = "WTFPL"; # http://sam.zoy.org/wtfpl/
    maintainers = with maintainers; [ iElectric ];
    platforms = stdenv.lib.platforms.linux;
  };

}
