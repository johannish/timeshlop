#!/usr/bin/tclsh
# Timeshlop: a personal timeline application to make sense of that "shlop"

source "time-sqlite.tcl"

set fh [open ./events.tcld]
set data [read -nonewline $fh] 
close $fh

set events [split $data "\n"]
foreach event $events {
	addEvent [dict get $event name] [dict get $event date] [dict get $event locations] [dict get $event people] [dict get $event note] {}
}

# addEvent $evtDate $evtLocation $evtPeople $evtNotes $evtBlobs
