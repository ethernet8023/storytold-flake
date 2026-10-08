# storytold-flake

Nix packaging for the [ArtCraft / storytold](https://github.com/storytold)
"Craft" app suite — the pure-Rust, clean-room reimplementations of the
creative-suite staples:

| package | what it is |
|---|---|
| `photocraft` | Photoshop-style image editor |
| `vectorcraft` | Illustrator-style vector editor |
| `designcraft` | design/layout app |
| `cadcraft` | AutoCAD-style CAD |
| `gridcraft` | Excel-style spreadsheet |
| `wordcraft` | Word-style word processor |
| `deckcraft` | PowerPoint-style presentations |
| `pdfcraft` | Acrobat-style PDF tool |
| `effectcraft` | After Effects-style VFX/compositing |
| `filmcraft` | Premiere-style video editor |
| `lightcraft` | Lightroom-style photo manager |
| `soundcraft` | Pro Tools-style audio DAW |

Every repo has the same shape — a cargo workspace with `apps/<name>` (the
GUI) and `apps/<name>-cli` (headless) — so this flake is one generic builder
plus a pinned registry, not twelve packages.

```sh
nix run    github:ethernet8023/storytold-flake#photocraft    # launch the GUI
nix shell  github:ethernet8023/storytold-flake#photocraft    # both binaries
nix build  github:ethernet8023/storytold-flake#photocraft
```

## Layout

- `suite.nix` — the registry: one entry per app (upstream rev, unpacked
  tree hash, features, native-dep extras). Adding an app is one entry.
- `builders/rust-app.nix` — the generic `mkCraftApp`: mirrors upstream's
  own `packaging/linux/package.sh` (`cargo build --release --locked -p
  <name> -p <name>-cli`, official features like photocraft's `heif`) and
  reuses the repo's own desktop entry, metainfo, mime xml and hicolor
  icons verbatim when it ships them.

The GUI binary is wrapped with the dlopen search path wgpu/egui needs at
runtime (vulkan-loader, wayland, libxkbcommon).

## Conventions

- Pins are *unpacked* tree hashes (`nix store prefetch-file --unpack`) of
  the archive tarballs — `fetchzip` semantics, not raw-file hashes.
- `outputHashes` for git deps live in the registry entry that pulls them
  (effectcraft vendors 26 crates from filmcraft's tree).
- This is a user packaging layer: it pins upstream releases rather than
  building the working tree. An in-repo `flake.nix` for contributors would
  be a separate (smaller) thing.