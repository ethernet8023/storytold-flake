# Generic builder for one ArtCraft "Craft" app (see suite.nix for entries).
#
# Follows the suite's own conventions so every repo builds the way its own
# packaging does:
#   - cargo workspace; build the GUI `apps/<name>` + headless `apps/<name>-cli`
#     binaries, release profile, locked deps — same invocation as
#     packaging/linux/package.sh: `cargo build --release --locked -p X -p X-cli`
#   - desktop entry / metainfo / mime xml / hicolor icons are reused VERBATIM
#     from the repo's own packaging/linux/ and assets/app-icon/hicolor when
#     present (repos without them — lightcraft, designcraft — simply skip
#     that block; add their files upstream and they appear here)
#   - `features` (photocraft's `heif`) mirrors the app's official builds
#
# Generic on purpose: all 12 suite repos share this workspace shape, so
# adding an app is one registry entry, not a new builder.
{ pkgs }:
entry:
let
  inherit (pkgs) lib;
  inherit (entry) pname version rev hash date;
  appId = entry.appId or "ai.storyteller.${pname}";

  repo = pkgs.fetchzip {
    url = "https://github.com/storytold/${pname}/archive/${rev}.tar.gz";
    inherit hash;
  };
in
pkgs.rustPlatform.buildRustPackage {
  inherit pname version;
  src = repo;

  buildFeatures = entry.features or [ ];
  # both suite binaries, like their package.sh
  cargoBuildFlags = [ "-p" pname "-p" "${pname}-cli" ];

  cargoLock.lockFile = "${repo}/Cargo.lock";
  # Repos with git deps (effectcraft at time of writing) also need
  # cargoLock.outputHashes — add them from the build error when first built.
  cargoLock.outputHashes = entry.outputHashes or { };

  # GUI runtime libs (wgpu → vulkan loader; eframe/egui → wayland/x11/xkb,
  # fontconfig). The wrapped binary gets the dlopen search path in postFixup.
  # Apps with audio (alsa-sys), gtk (filmcraft) or aws-lc-sys (pdfcraft) add
  # their native deps via the registry entry's extra*BuildInputs.
  buildInputs = with pkgs; [
    vulkan-loader
    wayland
    libxkbcommon
    fontconfig
    freetype
  ] ++ entry.extraBuildInputs or [ ];
  nativeBuildInputs = with pkgs; [
    pkg-config
    makeWrapper
  ] ++ entry.extraNativeBuildInputs or [ ];

  # upstream runs the full test suite in CI; a GUI build here just packages
  doCheck = entry.doCheck or false;

  postInstall = ''
    if [ -f ${repo}/packaging/linux/${appId}.desktop ]; then
      install -Dm644 ${repo}/packaging/linux/${appId}.desktop \
        $out/share/applications/${appId}.desktop
    fi
    if [ -f ${repo}/packaging/linux/${appId}.metainfo.xml.in ]; then
      mkdir -p $out/share/metainfo
      sed -e "s/@VERSION@/${version}/g" -e "s/@DATE@/${date}/g" \
        ${repo}/packaging/linux/${appId}.metainfo.xml.in \
        > $out/share/metainfo/${appId}.metainfo.xml
    fi
    if [ -f ${repo}/packaging/linux/${appId}.mime.xml ]; then
      install -Dm644 ${repo}/packaging/linux/${appId}.mime.xml \
        $out/share/mime/packages/${appId}.xml
    fi
    if [ -d ${repo}/assets/app-icon/hicolor ]; then
      mkdir -p $out/share/icons
      cp -R ${repo}/assets/app-icon/hicolor $out/share/icons/
    fi
  '';

  postFixup = lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath (with pkgs; [ vulkan-loader wayland libxkbcommon ])}
  '';

  meta = {
    description = entry.description;
    homepage = "https://github.com/storytold/${pname}";
    license = lib.licenses.mit; # MIT OR Apache-2.0
    mainProgram = pname;
    platforms = lib.platforms.unix;
  };
}
