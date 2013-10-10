#!/usr/bin/tclsh

package require Tk

source "event_import.tcl"

init_db

set events [getAllEvents]

#[import ./events.tcld]

wm title . "Timeshlop"
wm minsize . 400 200
# Padding is w n e s
grid [ttk::frame .c -padding "5 5 10 10" -relief raised] -column 0 -row 0 -sticky wnes
# Make ttk::frame resize with window
grid columnconfigure . 0 -weight 1
grid rowconfigure . 0 -weight 1

grid [tk::listbox .c.eventlb -height 10 -listvariable events] -column 0 -row 0 -sticky wn
grid [ttk::entry .c.importentry -text "File path"] -column 1 -row 0 -sticky n
grid [ttk::button .c.importbtn -text "Import file" -command importMe] -column 2 -row 0 -sticky n
grid [ttk::label .c.messages] -column 0 -row 1 -columnspan 2 -sticky ws
#grid [ttk::sizegrip .c.grip] -column 2 -row 1 -sticky se #TODO Make this non-stationary

proc importMe {} {
	set path [.c.importentry get]
	set importmsg [import $path]
	.c.messages configure -text $importmsg
	#TODO Refresh events in listbox
}
