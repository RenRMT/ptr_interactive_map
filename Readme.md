# PTR Interactive Map

An interactive, deep-zoomable web version of the [Project Tamriel gridmap](https://www.nexusmods.com/morrowind/mods/46821). View it online at https://renrmt.github.io/ptr_interactive_map

Built on [OpenSeadragon](https://openseadragon.github.io/), the map streams Deep Zoom (DZI) tiles instead of loading one enormous PNG, and layers annotations (roads, borders, settlements, regions, grid) on top of the basemap as independently toggleable overlays.

## Features

- **Deep zoom** over the full 26721 × 9241 px basemap, tiled and served on demand.
- **Toggleable layers** — roads, borders, settlements, settlement extents, locations, regions and the cell grid, stacked in a fixed draw order above the basemap.
- **Cell lookup** — enter in-game cell coordinates to pan to that cell and highlight it.

## Requirements

- [libvips](https://www.libvips.org/) (for `vips.exe`) — only needed to regenerate tiles.
- Any static web server. Tiles must be served over HTTP; opening `index.html` from `file://` will not work.

## Quick start

The pre-tiled layers in `layers/` are ready to serve:

```bash
python -m http.server 8000
```

Then open <http://localhost:8000>.

## Regenerating tiles

The source PNGs are not kept in this repo. The tiler converts each layer PNG into a `.dzi` + `_files/` pair in `layers/`.

1. Edit the three paths at the top of `tile_layers.bat` (`VIPS`, `INPUT_DIR`, `OUTPUT_DIR`).
2. Place the layer PNGs (`basemap.png`, `roads.png`, `borders.png`, …) in `INPUT_DIR`.
3. Run the script — double-click it, or run it from `cmd`.

It loops over every `.png` in `INPUT_DIR`, runs `vips dzsave` on each (256 px tiles, no overlap), names the output after the source file (`basemap.png` → `basemap.dzi` + `basemap_files/`), and reports success/failure per layer plus a summary at the end.

**Note:** Every layer PNG must share the basemap's exact pixel dimensions and origin. The overlays are stacked without per-layer offsets, so any misalignment in the source images carries straight through.

## Configuration

Layers are declared in the `LAYERS` array in `index.html`, in draw order (bottom to top), above the always-on basemap:

```js
{ id: "roads", name: "Roads", url: "layers/roads.dzi", enabled: true, opacity: 1.0 }
```
Note that opacity works, but if any of the source layers have opacity set as well, setting it here might make things more transparent than you want. Adding a layer means tiling its PNG and appending an entry here — the sidebar toggles are generated from this array.

## Coordinate system

In-game coordinates are mapped to basemap pixels with a single uniform scale, fitted from four known corner points (least-squares confirmed, zero residual):

```
pixelX = (mapX - BX) / SCALE      SCALE = 204.8
pixelY = (BY - mapY) / SCALE      BX = -2736128, BY = 548864
```

One cell is 8192 map units. If the basemap is ever re-exported at a different resolution or crop, these constants must be re-fitted.

## Credits

As per the original file — I made none of the assets.

**Gridmap custodians**

- Atrayonis (2016–2021)
- Taniquetil (2021–)

**Other credits**

- **Arthmodeus** — Creator of the earliest fanon Tamriel world maps.
- **c0dacan0n** — Contributions to Summerset Isles map.
- **Infragris** — Contributions to Cyrodiil, Hammerfell maps.
- **Jani** — Landmass exports and contributions to all project maps.
- **Klime65536** — Landmass exports and contributions to all project maps.
- **LadyNerevar** — Creator of detailed Yokuda shape.
- **Moorkh** — Creator of early inspiration map for mainland Morrowind shape.
- **Phenoix12** — Contributions to Padomaic Isles map.
- **Prometheus** — Creator of early planning maps for mainland Morrowind and Skyrim.
- **roerich** — Contributions to Skyrim map.
- **Swiftoak** — Creator of the first incarnation of the gridmap for Tamriel Rebuilt.
- **ThomasRuz** — Contributions to High Rock map.
- **Wolli** — Contributions to Morrowind map.
- **Vality7** — Contributions to all provinces.
- **Violet** — Contributions to Valenwood and Elsweyr maps.
- the Tamriel Rebuilt team
- the Project Tamriel team
- the Abecean Isles team
- the Padomaic Isles team
