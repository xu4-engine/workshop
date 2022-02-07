#!/usr/bin/boron
; Dump AVATAR.EXE & TITLE.EXE string tables

dump-strings: func [offset count /label desc] [
    print "; ---------"
    print [';' offset count either label desc ""]
    parse skip bin offset [
        count [s: to '^0' :s skip (probe to-string s)]
    ]
]

bin: read %ultima4_/AVATAR.EXE
print "; AVATAR.EXE"
dump-strings 0x0fc7b 11
dump-strings 0x0fee4 7
dump-strings 0x10187 5
dump-strings/label 0x123E9 53 "Hawkwind"
dump-strings/label 0x1561D 24 "Lord British"
dump-strings 0x156CA 25

bin: read %ultima4_/TITLE.EXE
print "^/; TITLE.EXE"
dump-strings 17444 add 28 [24 15]
