#!/usr/bin/boron -s
; Convert Ultima 4 maps to/from Tiled .TMX files.
; Version 0.1

file: first args

tmx-header: {{
<?xml version="1.0" encoding="UTF-8"?>
<map version="1.5" tiledversion="1.6.0" orientation="orthogonal"
 renderorder="right-down" width="256" height="256"
 tilewidth="16" tileheight="16" infinite="0" nextlayerid="2" nextobjectid="1">
 <tileset firstgid="1" source="tiles.tsx"/>
 <layer id="1" name="World" width="256" height="256">
  <data encoding="csv">
}}

tmx-footer: "  </data>^/ </layer>^/</map>"

print-tmx-data: func [chunks chunk-dim tile-per-chunk] [
    chunk-size: mul tile-per-chunk tile-per-chunk
    last-row: mul chunk-dim tile-per-chunk
    total-rows: 0
    row: make string! 4069

    loop chunk-dim [
        y: 0
        loop tile-per-chunk [
            in-row: skip chunks mul ++ y tile-per-chunk
            clear row
            loop chunk-dim [
                x: 1
                loop tile-per-chunk [
                    append append row add 1 pick in-row ++ x ','
                ]
                in-row: skip in-row chunk-size
            ]

            ; Remove final comma.
            ++ total-rows
            if eq? total-rows last-row [row: slice row -1]

            print row
        ]
        chunks: skip chunks mul chunk-dim chunk-size
    ]
]

write-map: func [file-handle data chunk-dim tile-per-chunk] [
    chunk-size: mul tile-per-chunk tile-per-chunk
    chunk: make binary! chunk-size
    tile-dim: mul chunk-dim tile-per-chunk
    loop chunk-dim [
        x: 0
        loop chunk-dim [
            in-row: skip data mul ++ x tile-per-chunk
            clear chunk
            loop tile-per-chunk [
                append chunk slice in-row tile-per-chunk
                in-row: skip in-row tile-dim
            ]
            write file-handle chunk
        ]
        data: skip data mul tile-per-chunk tile-dim
    ]
]

fatal: func [msg] [
    print msg
    quit/return 1
]

switch skip tail file -4 [
    %.map [
        chunks: read file   ;%ultima4/WORLD.MAP
        prin  tmx-header
        print-tmx-data chunks 8 32
        print tmx-footer
    ]

    %.tmx [
        w: csv: none
        parse read/text file [
            thru "<map "
            thru "<layer " thru {width="} w: thru {height="} h:
            thru "<data " thru {encoding="} enc: thru '>'
            csv: to "</data" :csv (
                w: to-int w
                h: to-int h
                enc: slice enc 3
            )
        ]
        case [
            none? w         [fatal "No map layer found"]
            none? csv       [fatal "No map data found"]
            ne? w 256       [fatal "Width is not 256"]
            ne? h 256       [fatal "Height is not 256"]
            ne? enc "csv"   [fatal "Data encoding is not CSV"]
        ]

        nums: to-block construct csv [',' ' ']
        map it nums [sub it 1]

        fh: open 1
        write-map fh nums 8 32
        close fh
    ]
]
