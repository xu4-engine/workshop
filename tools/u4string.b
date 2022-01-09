#!/usr/bin/boron
; Dump AVATAR.EXE & TITLE.EXE string tables

dump-strings: func [offset count] [
    parse skip bin offset [
        count [s: to '^0' :s skip (probe to-string s)]
    ]
]

bin: read %ultima4_/AVATAR.EXE
print "-----"
dump-strings 0x0fc7b 11
print "-----"
dump-strings 0x0fee4 7
print "-----"
dump-strings 0x10187 5

bin: read %ultima4_/TITLE.EXE
dump-strings 17444 add 28 [24 15]
