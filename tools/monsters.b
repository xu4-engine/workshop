#!/usr/bin/boron -s
; Edit MONSTERS.SAV

file: first args
if ne? 256 second info? file [
    print "MONSTERS.SAV must be 256 bytes."
    quit/return 1
]

coord: func [xind] [
    to-coord reduce [pick xind 1 pick xind 0x21]
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

dat: read file
print "monsters: ["
loop [i 0 31] [
    if all [
        not zero? tid: pick dat 1
        not zero? prev-tid: pick dat 0x61
    ][
        print format ["  " 2 ' ' 12 ' ' 8 ' ' 12 ' ' 8] [
            i
            gfx tid      coord skip dat 0x20
            gfx prev-tid coord skip dat 0x80
        ]
    ]
    ++ dat
]
print ']'
