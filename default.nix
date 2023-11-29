{ stdenv, lib, fetchzip, atk, glib, pango, gdk-pixbuf, gtk3, cairo, dbus, libdrm
, libXdamage, libXrandr, libXcomposite, libXext, libXfixes, libX11, libxcb
, libxshmfence, libxkbcommon, mesa, nss, nspr, alsaLib, cups, expat, udev
, libpulseaudio, at-spi2-atk, at-spi2-core, makeWrapper, openssl, watchman, }:
let
  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    atk
    glib
    pango
    gdk-pixbuf
    gtk3
    cairo
    dbus
    libdrm
    libXdamage
    libXrandr
    libXcomposite
    libXext
    libXfixes
    libX11
    libxcb
    libxshmfence
    libxkbcommon
    mesa
    nss
    nspr
    alsaLib
    cups
    expat
    udev
    libpulseaudio
    at-spi2-atk
    at-spi2-core
  ];
in with lib;
stdenv.mkDerivation rec {
  pname = "flipper";
  version = "0.239.0";

  src = fetchzip {
    url =
      "https://github.com/facebook/flipper/releases/download/v${version}/Flipper-linux.zip";
    hash = "sha256-Flfmkm2L0bJadgUaM5H1kCEMcxaOlfLXjH6Nde9lP/Q=";
    stripRoot = false;
  };

  buildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out/bin $out/opt/Flipper
    mv * $out/opt/Flipper/
    ln -s $out/opt/Flipper/${pname} $out/bin/${pname}
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:$out/opt/Flipper:\$ORIGIN" "$out/opt/Flipper/${pname}"
  '';
  postFixup = ''
    wrapProgram $out/opt/Flipper/${pname} \
      --set PATH ${lib.makeBinPath [ openssl watchman ]}
  '';

  meta = {
    description = "Native Debugging tool for mobile apps";
    homepage = "https://fbflipper.com/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
