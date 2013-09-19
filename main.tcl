#!/usr/bin/tclsh
# Timeshlop: a personal timeline application to make sense of that "shlop"

source "time-sqlite.tcl"

puts "event date: " 
gets stdin evtDate
puts "event location: "
gets stdin evtLocation
puts "event people: "
gets stdin evtPeople
puts "event notes: "
gets stdin evtNotes
puts "event files: "
gets stdin evtBlobs

addEvent $evtDate $evtLocation $evtPeople $evtNotes $evtBlobs
