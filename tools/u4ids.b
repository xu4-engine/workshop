#!/usr/bin/boron
; Convert configuration tilemaps to simple C lookup tables.

cfg: load either args [first args] [%conf/config.b]

emit-tmap: func [tmap tname] [
    uid: 0
    mid: 0
    count: div size? tmap 2
    mid-vec: reserve make vector! 'u16 256

    print rejoin ["static const uint8_t ultima4Id_" tname "[" count "] = {"]
    foreach [mapping paren] tmap [
        ifn frames: paren/frames [
            frames: 1
        ]
        print format ["    " -3 ",  // " 1] [uid paren/tile]
        loop frames [
            append mid-vec mid
        ]
        uid: add uid frames
        ++ mid;
    ]
    print "};"

    print rejoin [
        "static const uint8_t moduleId_" tname "[" size? mid-vec "] = {"
    ]
    foreach [a b c d] mid-vec [
        print format ["    " -3 ',' -3 ',' -3 ',' -3 ','] [a b c d]
    ]
    print "};"
]

parse cfg/3/tilesets [some[
    tok:
    'tilemap paren! block! (
        emit-tmap tok/3 tok/2/name
    )
  | 'tileset paren! into [
      (tn: 0 print "module-ids:") some [
        'tile set attr paren! (print [' ' ++ tn attr/name])
      ]
    ]
]]
