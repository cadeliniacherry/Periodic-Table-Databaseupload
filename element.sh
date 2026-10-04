#!/bin/bash

if [[ -z "${1:-}" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

PSQL=(psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only --field-separator='|')
query="SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p USING (atomic_number) JOIN types AS t USING (type_id) WHERE e.atomic_number::TEXT = :'element' OR e.symbol = :'element' OR e.name = :'element';"
element=$(printf '%s\n' "$query" | "${PSQL[@]}" --set=element="$1")

if [[ -z "$element" ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$element"
printf "The element with atomic number %s is %s (%s). It's a %s, with a mass of %s amu. %s has a melting point of %s celsius and a boiling point of %s celsius.\n" \
  "$atomic_number" "$name" "$symbol" "$type" "$atomic_mass" "$name" "$melting_point" "$boiling_point"
