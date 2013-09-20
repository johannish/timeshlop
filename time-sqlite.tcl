# Interface to SQLite3 DB

package require sqlite3

sqlite3 db ./timeshlop.db -create true

proc addEvent {date locations people note attachments} {
	puts "Inserting: $date $locations $people $note $attachments"
	db eval {
		INSERT INTO event VALUES (
			strftime('%s', 'now'),
			$date,
			$note
		)
	}
}

proc deleteEvent {date locations people note attachments} {
	puts "Got: $date $locations $people $note $attachments"
}

proc initDb {} {
	puts "Creating DB tables"
	db eval { CREATE TABLE IF NOT EXISTS event(crt_date INTEGER, date INTEGER, note TEXT) }
	db eval { CREATE TABLE IF NOT EXISTS location(crt_date INTEGER, place TEXT, lat REAL, long REAL) }
	db eval { CREATE TABLE IF NOT EXISTS person(crt_date INTEGER, fname TEXT, lname TEXT) }
	db eval { CREATE TABLE IF NOT EXISTS attachment(crt_date INTEGER, file BLOB, name TEXT) }
	db eval {
		CREATE TABLE IF NOT EXISTS event_locations(
			event_id INTEGER,
			location_id INTEGER,
			FOREIGN KEY(event_id) REFERENCES event(rowid),
			FOREIGN KEY(location_id) REFERENCES location(rowid)
		)
	}
	db eval {
		CREATE TABLE IF NOT EXISTS event_persons(
			event_id INTEGER,
			person_id INTEGER,
			FOREIGN KEY(event_id) REFERENCES event(rowid),
			FOREIGN KEY(person_id) REFERENCES person(rowid)
		)
	}
	db eval {
		CREATE TABLE IF NOT EXISTS event_attachments(
			event_id INTEGER,
			attachment_id INTEGER,
			FOREIGN KEY(event_id) REFERENCES event(rowid),
			FOREIGN KEY(attachment_id) REFERENCES attachment(rowid)
		)
	}
}

proc ensureSchema {} {
	set expectedCount 7
	set tableCount [db eval {
		SELECT count(*)
		FROM sqlite_master
		WHERE type='table'
	}]
	if {$tableCount != $expectedCount} {
		puts "Number of tables was not $expectedCount. Re-initializing."
		initDb
	}
}

ensureSchema
