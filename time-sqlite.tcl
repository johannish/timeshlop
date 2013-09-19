# Interface to SQLite3 DB

package require sqlite3

sqlite3 db ./timeshlop.db -create true

proc addEvent {date locations people note blobs} {
	puts "Got: $date $locations $people $note $blobs"
}

proc initDb {} {
	puts "Creating DB tables"
	db eval { CREATE TABLE event(date INTEGER, crt_date INTEGER, note TEXT) }
	db eval { CREATE TABLE location(lat REAL, long REAL, event_id INTEGER, FOREIGN KEY(event_id) REFERENCES event(rowid)) }
	db eval { CREATE TABLE person(fname TEXT, lname TEXT) }
	db eval { CREATE TABLE person_event(event_id INTEGER, person_id INTEGER, FOREIGN KEY(event_id) REFERENCES event(rowid), FOREIGN KEY(person_id) REFERENCES person(rowid)) }
}

initDb
