# The ArtCraft / storytold suite registry — one entry per app.
#
# Everything a build needs is pinned here: source rev, tarball hash, commit
# date (for the metainfo @DATE@ substitution upstream's packaging does).
# Adding an app = adding an entry; the builder (builders/rust-app.nix) is
# suite-generic and carries no per-app logic.
#
# `features` mirrors each app's official build (photocraft: heif).
# `outputHashes` must be filled for repos with git deps — currently only
# effectcraft (26 git deps in its Cargo.lock at pin time); leave its entry
# disabled (commented) or add the hashes from the first build error.
pkgs:
{
  photocraft = {
    pname = "photocraft";
    version = "0.3.0";
    rev = "f7be9fbe2ce7054236d5ae895e5270d8398ab43d";
    hash = "sha256-Bqun3T+djis+qXQnysVeHO6czM2x3sJCWrpKiJku2zM=";
    date = "2026-10-07";
    features = [ "heif" ]; # official builds: cargo build --features heif
    description = "PhotoCraft — open-source, clean-room reimplementation of Adobe Photoshop in pure Rust";
  };

  cadcraft = {
    pname = "cadcraft";
    version = "0.1.0";
    rev = "14e143bfdd55fe9063ba7d87dbbc692e5c901063";
    hash = "sha256-dabOb5PAXnH6nJYsI62wcyhBGT3smjmmo1t2YrXq+Qo=";
    date = "2026-10-07";
    description = "CADCraft — open-source, clean-room AutoCAD-style CAD app in pure Rust";
  };

  deckcraft = {
    pname = "deckcraft";
    version = "0.1.0";
    rev = "efb03b90a863e57f97ed07a7d28267adf82494d6";
    hash = "sha256-K0BgvIdRRxAvUFNUqpbBhmGYNuUwb3u6MGO34zy2w9U=";
    date = "2026-10-07";
    # alsa-sys in the dep tree (audio playback for slide shows)
    extraBuildInputs = with pkgs; [ alsa-lib ];
    description = "DeckCraft — open-source, clean-room reimplementation of PowerPoint in pure Rust";
  };

  effectcraft = {
    pname = "effectcraft";
    version = "0.4.0";
    rev = "e38a92e792c07f1c57c5dcfcab37d91932b9e2b8";
    hash = "sha256-yOA5ugrf1qrGUgPlxz1TlmWL05pS9ZG1ejsNZuvvLWo=";
    date = "2026-10-07";
    # alsa-sys in the dep tree (VFX timeline audio) + the 26 filmcraft git
    # workspace deps (see outputHashes below)
    extraBuildInputs = with pkgs; [ alsa-lib ];
    outputHashes = {
      "filmcraft-aac-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-ac3-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-av1-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-bitstream-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-cfb-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-codecs-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-color-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-dnx-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-frame-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-geom-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-h264-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-h264enc-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-hevc-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-interchange-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-isobmff-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-matroska-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-media-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-mpeg2v-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-mpegts-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-mxf-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-ogg-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-opus-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-project-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-prores-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-time-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
      "filmcraft-vp9-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
    };
    description = "EffectCraft — VFX/compositing app of the ArtCraft suite, pure Rust";
  };

  filmcraft = {
    pname = "filmcraft";
    version = "0.2.1";
    rev = "a4536bcfedf588cbef9ea24df149c70bf99a037d";
    hash = "sha256-0rrpBr9oIjC899u53XAgGgAPmrM17uDbJsVvTnBj0cw=";
    date = "2026-10-07";
    # gtk-sys/glib-sys/etc in the dep tree (video pipeline uses gtk for some
    # dialogs/codecs) + alsa-sys (timeline audio)
    extraBuildInputs = with pkgs; [ gtk3 alsa-lib ];
    extraNativeBuildInputs = with pkgs; [ wrapGAppsHook3 glib ];
    description = "FilmCraft — open-source, clean-room reimplementation of Adobe Premiere Pro in pure Rust";
  };

  gridcraft = {
    pname = "gridcraft";
    version = "0.1.0";
    rev = "a60bd2f40edae13197965ded9433dcf276caca45";
    hash = "sha256-UorwvAcwn7NsAyYoXdgzxaAj1Ve0Rk0u02Sd1vH4fPs=";
    date = "2026-10-07";
    description = "GridCraft — open-source, clean-room spreadsheet (Excel-style) in pure Rust";
  };

  lightcraft = {
    pname = "lightcraft";
    version = "0.2.1";
    rev = "7aab3fd97fed00ffcebdd3cca7fede12f7672194";
    hash = "sha256-1ZSxmspwLY3iTjjjRz8O/30ufuFuoA562ywF4xMc0II=";
    date = "2026-10-07";
    # ships no packaging/linux/ dir yet: builds fine, installs no desktop entry
    description = "LightCraft — open-source, clean-room reimplementation of Adobe Lightroom in pure Rust";
  };

  pdfcraft = {
    pname = "pdfcraft";
    version = "0.2.1";
    rev = "d3db99818f533a531dbcd469b2ac71ba35c0d3ec";
    hash = "sha256-LqIwIZ0WTMat8dOtME0GLjOtS48F4Lo2C06esKqqqMY=";
    date = "2026-10-07";
    # aws-lc-sys in the dep tree (PDF network fetches): needs cmake + perl
    # to build its C parts
    extraNativeBuildInputs = with pkgs; [ cmake perl ];
    description = "PDFCraft — open-source, clean-room reimplementation of Adobe Acrobat in pure Rust";
  };

  soundcraft = {
    pname = "soundcraft";
    version = "0.1.0";
    rev = "3597f895cc49ad795650839c1eeeeac0f88e2aa9";
    hash = "sha256-SHjork83z117k+xIxScNq2tLSjIWkUwMZx5SgEMJLpY=";
    date = "2026-10-07";
    # alsa-sys + clap-sys in the dep tree (audio engine + plugin hosting)
    extraBuildInputs = with pkgs; [ alsa-lib ];
    description = "SoundCraft — open-source, clean-room reimplementation of Avid Pro Tools in pure Rust";
  };

  vectorcraft = {
    pname = "vectorcraft";
    version = "0.4.0";
    rev = "ce12b4b0f58678cb8fe752a9c0f8c36fe767544a";
    hash = "sha256-OSmu5YhS3K20zPXlswZTl3Nx4jkhNwgMfqlXiDjWnm8=";
    date = "2026-10-07";
    description = "VectorCraft — open-source, clean-room reimplementation of Adobe Illustrator in pure Rust";
  };

  wordcraft = {
    pname = "wordcraft";
    version = "0.1.0";
    rev = "05d0b41b7e52dcd3cdade9c38e3d475bd7644b04";
    hash = "sha256-3btcdxy2oYG7PhYDeCSHrzvbx0PEhYbteKrESCZJvfg=";
    date = "2026-10-07";
    description = "WordCraft — open-source, clean-room reimplementation of Microsoft Word in pure Rust";
  };

  designcraft = {
    pname = "designcraft";
    version = "0.2.1";
    rev = "f17397c305ecda9d644105f7a4e9b9d65d34bb60";
    hash = "sha256-piZftSa3Nbwp9YKdmGKBRhP+NAxUrB95xzfTW32WjsA=";
    date = "2026-10-07";
    # ships no packaging/linux/ dir yet: builds fine, installs no desktop entry
    description = "DesignCraft — design app of the ArtCraft suite, pure Rust";
  };
}
