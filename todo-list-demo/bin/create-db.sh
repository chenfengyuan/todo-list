#!/usr/bin/env bash
dropdb todo-list --if-exists
createdb todo-list
psql todo-list -f `dirname $0`"/create-schema.sql"
psql todo-list -c "
drop role if exists cfy;
CREATE USER cfy WITH PASSWORD 'foobar';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO cfy;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO cfy;"
