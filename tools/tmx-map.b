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

tmx-head: func [name dim] [
    construct tmx-header ["World" name "256" dim ]
]

tmx-next-layer: func [id name dim] [
    rejoin [
        construct { <layer id="#" name="$" width="!" height="!">^/}
            ['#' id '$' name '!' dim ]
        {  <data encoding="csv">}
    ]
]

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

print-tmx-obj: func [id tile x y /type tval] [
    ++ tile
    x: mul 16 x
    y: mul 16 add 1 y
    other: either type [rejoin [{ type="} tval '"']] ""
    print construct
        {  <object id="#" gid="$" x="!" y="@" width="16" height="16"%/>}
        ['#' id '$' tile '!' x '@' y '%' other]
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

basename: func [path] [
    if pos: find/last path charset "/\" [
        path: next pos
    ]
    slice path find/last path '.'
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

    %.dat [
        chunks: read file   ;%ultima5/BRIT.DAT

        water-chunk: make binary! 256
        append/repeat water-chunk 1 256

        path: slice file find file %BRIT.DAT
        fp: open join to-file path %DATA.OVL
        ovl: read/part skip fp 0x3886 0x100
        close fp

        ; Insert water chunks into chunk list.
        expanded: make binary! mul 256 256
        foreach it ovl [
            append expanded either eq? it 255 [
                water-chunk
            ][
                slice skip chunks mul 256 it 256
            ]
        ]
        prin  tmx-header
        print-tmx-data expanded 16 16
        print tmx-footer
    ]

    %.dng [
        rooms: skip read file 0x200     ;%ultima4/DECEIT.DNG
        id: 1
        layer-name: join basename file '-'
        prin tmx-head join layer-name id 11
        while [not tail? rooms] [
            if gt? id 1 [
                print tmx-next-layer id join layer-name id 11
            ]

            base: slice rooms 128,121   ; 11x11 map
            print-tmx-data base 1 11
            print "  </data>^/ </layer>"

            mon: skip rooms 0x10
            ifn zero? pick mon 16 [
                print construct { <objectgroup id="#" name="objects-#">}
                    ['#' id]
                obj-id: 1
                loop 16 [
                    ifn zero? gid: first mon [
                        print-tmx-obj ++ obj-id gid pick mon 0x11 pick mon 0x21
                    ]
                    ++ mon
                ]
                print " </objectgroup>"
            ]

            rooms: skip rooms 256
            ++ id
        ]
        print "</map>"
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

    %.ult [
        umap: read file         ;%ultima4/COVE.ULT
        npcs: skip umap 1024

        prin tmx-head basename file 32
        print-tmx-data umap 1 32
        print "  </data>^/ </layer>"
        print { <objectgroup id="1" name="npcs">}
        obj-id: 1
        loop 32 [
            ifn zero? gid: first npcs [
                print-tmx-obj/type ++ obj-id gid pick npcs 0x21 pick npcs 0x41
                    rejoin [
                        select [0 'S' 1 'W' 0x80 'F' 0xFF 'A'] pick npcs 0xC1 
                        ' ' pick npcs 0xE1
                    ]
            ]
            ++ npcs
        ]
        print " </objectgroup>"
        print "</map>"
    ]
]
