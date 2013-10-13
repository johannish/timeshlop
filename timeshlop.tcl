#!/usr/bin/tclsh

package require Tk

source "events.tcl"

set events [::events::getSummaryList]

wm title . "Timeshlop"
wm minsize . 400 200
# Padding is w n e s
grid [ttk::frame .c -padding "5 5 10 10" -relief raised] -column 0 -row 0 -sticky wnes
#ttk::style configure TFrame -background red #DEBUG
# Make ttk::frame resize with window
grid columnconfigure . 0 -weight 1
grid rowconfigure . 0 -weight 1

grid [tk::listbox .c.eventlb -height 10 -listvariable events] -column 0 -row 0 -sticky wns
grid columnconfigure .c 0 -weight 1
grid rowconfigure .c 0 -weight 1
grid [ttk::entry .c.importentry -text "File path"] -column 1 -row 0 -sticky n
grid [ttk::button .c.importbtn -text "Import file" -command importMe] -column 2 -row 0 -sticky n
grid [ttk::label .c.messages] -column 0 -row 1 -columnspan 2 -sticky ws
#ttk::style configure TLabel -background blue #DEBUG
grid [ttk::sizegrip .c.grip] -column 999 -row 1 -sticky se


proc importMe {} {
	set path [.c.importentry get]
	set importmsg [::events::import $path]
	.c.messages configure -text $importmsg
	#TODO do this without upvar
	upvar events evts
	set evts [::events::getSummaryList]
	.c.eventlb yview moveto 1; # scroll to last item in list
}
