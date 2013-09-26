# Interface to SQLite3 DB

package require sqlite3

sqlite3 db ./timeshlop.db -create true

# Enforce foreign key relationships
db eval { PRAGMA foreign_keys = ON }

proc addEvent {name date locations people note attachments} {
	puts "Inserting: $name | $date | $locations | $people | $note | $attachments"
	db transaction {
		db eval {
			INSERT INTO event VALUES (
				null,
				strftime('%s', 'now'),
				$name,
				$date,
				$note
			)
		}
		# This must come immediately after inserting into event table
		# TODO: Is there a cleaner way?
		set eventId [db eval {
			SELECT last_insert_rowid()
		}]
	}
}

proc deleteEvent {date locations people note attachments} {
	puts "Got: $date $locations $people $note $attachments"
}

proc initDb {} {
	puts "Creating DB tables"
	db eval { CREATE TABLE IF NOT EXISTS event(id INTEGER PRIMARY KEY, crt_date INTEGER, name TEXT, date INTEGER, note TEXT) }
	db eval { CREATE TABLE IF NOT EXISTS location(id INTEGER PRIMARY KEY, crt_date INTEGER, place TEXT, lat REAL, long REAL) }
	db eval { CREATE TABLE IF NOT EXISTS person(id INTEGER PRIMARY KEY, crt_date INTEGER, fname TEXT, lname TEXT) }
	db eval { CREATE TABLE IF NOT EXISTS attachment(id INTEGER PRIMARY KEY, crt_date INTEGER, file BLOB, name TEXT) }
	db eval {
		CREATE TABLE IF NOT EXISTS event_locations(
			event_id INTEGER,
			location_id INTEGER,
			FOREIGN KEY(event_id) REFERENCES event(id),
			FOREIGN KEY(location_id) REFERENCES location(id)
		)
	}
	db eval {
		CREATE TABLE IF NOT EXISTS event_persons(
			event_id INTEGER,
			person_id INTEGER,
			FOREIGN KEY(event_id) REFERENCES event(id),
			FOREIGN KEY(person_id) REFERENCES person(id)
		)
	}
	db eval {
		CREATE TABLE IF NOT EXISTS event_attachments(
			event_id INTEGER,
			attachment_id INTEGER,
			FOREIGN KEY(event_id) REFERENCES event(id),
			FOREIGN KEY(attachment_id) REFERENCES attachment(id)
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
