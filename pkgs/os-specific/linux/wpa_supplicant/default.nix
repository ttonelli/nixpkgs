{ stdenv, fetchurl, lib, openssl, dbus_libs, pkgconfig, libnl
, readlineSupport ? true, readline
}:

assert readlineSupport -> readline != null;

stdenv.mkDerivation rec {
  version = "2.0";

  name = "wpa_supplicant-${version}";

  src = fetchurl {
    url = "http://hostap.epitest.fi/releases/${name}.tar.gz";
    sha256 = "02cy6wrs4nzm7wbq9mc1vby8lnj58k4sb10h718ks8mmzc4mc49c";
  };

  extraConfig =
    ''
      CONFIG_DEBUG_SYSLOG=y
      CONFIG_CTRL_IFACE_DBUS=y
      CONFIG_CTRL_IFACE_DBUS_NEW=y
      CONFIG_CTRL_IFACE_DBUS_INTRO=y
      CONFIG_DRIVER_NL80211=y
      CONFIG_LIBNL32=y
      ${stdenv.lib.optionalString readlineSupport "CONFIG_READLINE=y"}
    '';

  preBuild = ''
    cd wpa_supplicant
    cp -v defconfig .config
    echo "$extraConfig" >> .config
    cat .config
    substituteInPlace Makefile --replace /usr/local $out
  '';

  buildInputs = [ openssl dbus_libs libnl ]
    ++ lib.optional readlineSupport readline;

  nativeBuildInputs = [ pkgconfig ];

  patches = [ ./libnl.patch ];

  postInstall = ''
    mkdir -p $out/share/man/man5 $out/share/man/man8
    cp -v doc/docbook/*.5 $out/share/man/man5/
    cp -v doc/docbook/*.8 $out/share/man/man8/
    mkdir -p $out/etc/dbus-1/system.d $out/share/dbus-1/system-services $out/etc/systemd/system
    cp -v dbus/*service $out/share/dbus-1/system-services
    sed -e "s@/sbin/wpa_supplicant@$out&@" -i $out/share/dbus-1/system-services/*
    cp -v dbus/dbus-wpa_supplicant.conf $out/etc/dbus-1/system.d
    cp -v systemd/*.service $out/etc/systemd/system
  ''; # */

  meta = {
    homepage = http://hostap.epitest.fi/wpa_supplicant/;
    description = "A tool for connecting to WPA and WPA2-protected wireless networks";
    maintainers = with stdenv.lib.maintainers; [marcweber urkud];
    platforms = stdenv.lib.platforms.linux;
  };
}
