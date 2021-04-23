#!/usr/bin/boron -s
; Edit DNGMAP.SAV

file: first args
if ne? 512 second info? file [
    print "DNGMAP.SAV must be 512 bytes."
    quit/return 1
]

; Features 0x80 0x90 0xA0 0xD0 use low nibble
features: [
    0x00  '.'   ; Nothing
    0x10  '^'   ; Ladder up
    0x20  'v'   ; Ladder down
    0x30  '|'   ; Ladder up/down
    0x40  'c'   ; Chest
    0x50  'O'   ; Hole in ceiling
    0x60  'o'   ; Hole in floor
    0x70  '*'   ; Orb (see below)
    0x80  't'   ; Trap (magic-wind, rocks, 0x8E pit)
    0x90  'f'   ; Fountain (water, heal, damage, cure, poison)
    0xA0  'm'   ; Magic field (poison, energy, fire, sleep)
    0xB0  'a'   ; Altar (stone color depends on dungeon)
    0xC0  'I'   ; Door
    0xD0  'R'   ; Room 0-15
    0xE0  'i'   ; Hidden Door
    0xF0  'W'   ; Wall
]

monsters: [
    0x0  ' '    ; none
    0x1  Rat
    0x2  Bat
    0x3  Spider
    0x4  Ghost
    0x5  Slime
    0x6  Troll
    0x7  Gremlin
    0x8  Mimic
    0x9  Reaper
    0xA  Insects
    0xB  Gazer
    0xC  Phantom
    0xD  Orc
    0xE  Skeleton
    0xF  Rogue
]

map: read file
loop [lvl 1 8] [
    print ["Level:" lvl]
    loop [row 0 7] [
        loop [col 0 7] [
            byte: first ++ map

            feat: select features hnib: and byte 0xf0
            mon:  and byte 0x0f
            switch hnib [
                0x80 [mon: pick "wr............p." add 1 mon]
                0x90 [mon: pick "whdcp" add 1 mon]
                0xA0 [mon: pick "PEFS"  add 1 mon]
                0xD0 []
                [
                    mon: select monsters mon
                    if word? mon [mon: slice to-string mon 3]
                ]
            ]

            prin format ["  " -2 ' ' 3] [feat mon]
        ]
        prin '^/'
    ]
]
