#!/usr/bin/boron -s
; Dump MONSTERS.SAV

file: first args

coord: func [xind] [
    to-coord reduce [pick xind 1 pick xind 0x21]
]

coord3: func [xind] [
    to-coord reduce [pick xind 1 pick xind 0x21 pick xind 0x41]
]

gfx: func [id] [
    either name: select graphics id [name] [id]
]

graphics: [
     16 Ship-W
     17 Ship-N
     18 Ship-E
     19 Ship-S
     20 Horse-W
     21 Horse-E
     24 Balloon
     60 Chest
    128 Pirate-Ship-W
    129 Pirate-Ship-N
    130 Pirate-Ship-E
    131 Pirate-Ship-S
    132 Nixie
    134 Giant-Squid
    136 Sea-Serpent
    138 Seahorse
    140 Whirlpool
    142 Storm
    144 Rat
    148 Bat
    152 Giant-Spider
    156 Ghost
    160 Slime
    164 Troll
    168 Gremlin
    172 Mimic
    176 Reaper
    180 Insect-Swarm
    184 Gazer
    188 Phantom
    192 Orc
    196 Skeleton
    200 Rogue
    204 Python
    208 Ettin
    212 Headless
    216 Cyclops
    220 Wisp
    224 Evil-Mage
    228 Lich
    232 Lava-Lizard
    236 Zorn
    240 Daemon
    244 Hydra
    248 Dragon
    252 Balron
]

dump-monsters: func [file] [
    if ne? 256 second info? file [
        print "MONSTERS.SAV must be 256 bytes."
        quit/return 1
    ]

    dat: read file
    print "monsters: ["
    loop [i 0 31] [
        cid: pick dat 1
        pid: pick dat 0x61
        ifn zero? or cid pid [
            pcoord: either zero? cid [:coord3] [:coord]
            print format ["  " 2 ' ' 12 ' ' 8 ' ' 12 ' ' 8] [
                i
                gfx cid coord  skip dat 0x20
                gfx pid pcoord skip dat 0x80
            ]
        ]
        ++ dat
    ]
    print ']'
]

make-monsters: func [file] [
    dat: make binary! 256
    append/repeat dat 0 256

    spec: select load file 'monsters
    foreach [index gfx pos prev-gfx prev-pos] spec [
        entry: skip dat index
        poke entry 1    pick find graphics gfx -1
        poke entry 0x21 first  pos
        poke entry 0x41 second pos
        poke entry 0x61 pick find graphics prev-gfx -1
        poke entry 0x81 first  prev-pos
        poke entry 0xA1 second prev-pos
    ]
    write fp: open 1 dat
    close fp
]

either eq? last file 'b' [
    make-monsters file
][
    dump-monsters file
]
