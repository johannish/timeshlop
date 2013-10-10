#!/usr/bin/tclsh

package require Tk

source "event_import.tcl"

init_db

set events [getAllEvents]

#[import ./events.tcld]

wm title . "Timeshlop"
wm minsize . 200 100
# Padding is w n e s
grid [ttk::frame .c -padding "5 5 10 10" -relief raised] -column 0 -row 0 -sticky wnes
# Make ttk::frame resize with window
grid columnconfigure . 0 -weight 1
grid rowconfigure . 0 -weight 1

grid [tk::listbox .c.eventlb -height 10 -listvariable events] -column 0 -row 0 -sticky wn
grid [ttk::button .c.importbtn -text "Import file" -command importMe] -column 1 -row 0 -sticky n
grid [ttk::label .c.messages -text "msg"] -column 0 -row 1 -columnspan 2 -sticky ws

proc importMe {} {
	set importmsg [import ./events.dat]
	.c.messages configure -text $importmsg
	#TODO Refresh events in listbox
}
