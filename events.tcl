#!/usr/bin/tclsh
# Timeshlop: a personal timeline application to make sense of that "shlop"

source "ts_sqlite.tcl"

namespace eval ::events {
}

proc ::events::import {filename} {
	set fh [open $filename]
	set data [read -nonewline $fh] 
	close $fh

	set events [split $data "\n"]
	set rowcount 0
	foreach event $events {
		set addSuccess [::eventsDb::addEvent \
			[dict get $event name] \
			[dict get $event date] \
			[dict get $event locations] \
			[dict get $event people] \
			[dict get $event note] \
			{} \
		]
		if {$addSuccess} {
			incr rowcount 1
		}
	}
	return "Successfully added $rowcount items"
}

proc ::events::exportCsv {filename} {
	#TODO export csv
}

proc ::events::getSummaryList {} {
	::eventsDb::getAllEvents
}

::eventsDb::init_db
