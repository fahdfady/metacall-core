{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, nodejs
, rustc
, cargo
, ninja
, openssl
, zlib
, git
}:

stdenv.mkDerivation rec {
  pname = "metacall";
  version = "0.8.7"; # Update to match repo's VERSION file

  src = fetchFromGitHub {
    owner = "metacall";
    repo = "core";
    rev = "v${version}";
    hash = "sha256-tU4ZBLAva2+NnaXJ7SvJZwhrG9Sn1DfZlCeWt966cw8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    python3
    nodejs
    rustc
    cargo
    git
  ];

  buildInputs = [
    openssl
    zlib
  ];

  configurePhase = ''
    cmake -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DOPTION_BUILD_SECURITY=OFF \
      -DOPTION_BUILD_PORTS=ON \
      -DOPTION_BUILD_SCRIPTS=ON
  '';

  buildPhase = ''
    cmake --build build --parallel $NIX_BUILD_CORES
  '';

  GIT_SSL_CAINFO = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

  installPhase = ''
    cmake --install build --prefix $out
    install -Dm755 build/metacall/cli/metacall $out/bin/metacall
  '';

  meta = with lib; {
    description = "MetaCall: Polyglot Runtime";
    homepage = "https://metacall.io";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}