#!/usr/bin/boron
; Compute average time/CPU cycles from log file.

prefix: "^/ut: "

do-ave: yes
do-plot: no
log-file: none

forall args [
    switch first args [
        "-p" [do-ave: no do-plot: yes]
        [log-file: first args]
    ]
]

times: []
parse read/text log-file [some[
    thru prefix p: to '^/' (append times to-int p)
]]
;probe times

low: high: first times
foreach t next times [
    if lt? t low  [low: t]
    if gt? t high [high: t]
]

if do-ave [
    forall times [
        sum: 0
        foreach t st: slice times 10 [
            sum: add sum t
        ]
        ; Average over 10 samples.
        print [div sum size? st]
        times: skip times 9
    ]
    print ["low:" low "high:" high]
]

if do-plot [
    count: 0
    print ['#' log-file]
    print "# N   cycles"
    foreach t next times [
        print [++ count t]
    ]
]
