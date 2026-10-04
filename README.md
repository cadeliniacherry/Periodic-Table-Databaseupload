# Periodic Table

A PostgreSQL-backed element lookup script for the freeCodeCamp Periodic Table project.

## Setup

The database must be named `periodic_table` and accessible to the `freecodecamp` PostgreSQL user. To restore the included database dump from a PostgreSQL superuser account:

```sh
psql -U postgres < periodic_table.sql
```

To look up an element by atomic number, symbol, or name:

```sh
./element.sh 1
./element.sh H
./element.sh Hydrogen
```

Run the lookup checks with:

```sh
./test_element.sh
```

`fix_database.sql` contains the one-time schema and data migration from the supplied starter database. `periodic_table.sql` is a dump of the completed database.
