# Interface to SQLite3 DB

package require sqlite3

sqlite3 db ./timeshlop.db -create true

db eval {
	-- enforce foreign key relationships
	PRAGMA foreign_keys = ON;
	-- make LIKE comparison case sensitive even for ASCII
	PRAGMA case_sensitive_like = ON;
}

proc getAllEvents {} {
	db eval {
		SELECT *
		FROM event
	}
}

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

		foreach location $locations {
			# use dict merge to add default empty keys if missing
			set location [dict merge {name {} lat {} long {}} $location]
			puts "location: $location"
			# TODO is there a more elegant way here to insert the dict values into the row?
			set name [dict get $location name]
			set lat [dict get $location lat]
			set long [dict get $location long]
			db eval {
				INSERT INTO location VALUES (
					null,
					strftime('%s', 'now'),
					$eventId,
					$name,
					$lat,
					$long
				)
			}
		}

		foreach fullname $people {
			db eval {
				INSERT INTO person VALUES (
					null,
					strftime('%s', 'now'),
					$eventId,
					$fullname
				)
			}
		}

	}
}

proc deleteEvent {eventId} {
	puts "Deleting event: $eventId"
}

proc initDb {} {
	puts "Creating DB tables"
	db eval {
		CREATE TABLE IF NOT EXISTS event(
			id INTEGER PRIMARY KEY,
			crt_date INTEGER,
			name TEXT,
			date INTEGER,
			note TEXT
		)
	}
	db eval {
		CREATE TABLE IF NOT EXISTS location(
			id INTEGER PRIMARY KEY,
			crt_date INTEGER,
			event_id INTEGER,
			name TEXT,
			lat REAL,
			long REAL,
			FOREIGN KEY (event_id) REFERENCES event(id)
		)
	}
	db eval {
		CREATE TABLE IF NOT EXISTS person(
			id INTEGER PRIMARY KEY,
			crt_date INTEGER,
			event_id INTEGER,
			name TEXT,
			FOREIGN KEY (event_id) REFERENCES event(id)
		)
	}
	db eval {
		CREATE TABLE IF NOT EXISTS attachment(
			id INTEGER PRIMARY KEY,
			crt_date INTEGER,
			file BLOB,
			name TEXT
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
	set expectedCount 5
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

proc init_db {} {
	ensureSchema
}
