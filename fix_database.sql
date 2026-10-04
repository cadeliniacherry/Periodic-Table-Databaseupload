BEGIN;

DELETE FROM properties WHERE atomic_number = 1000;
DELETE FROM elements WHERE atomic_number = 1000;

ALTER TABLE elements
  ALTER COLUMN symbol SET NOT NULL,
  ALTER COLUMN name SET NOT NULL,
  ADD CONSTRAINT elements_symbol_key UNIQUE (symbol),
  ADD CONSTRAINT elements_name_key UNIQUE (name);

UPDATE elements
SET symbol = upper(left(symbol, 1)) || substring(symbol FROM 2);

ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;
ALTER TABLE properties
  ALTER COLUMN melting_point_celsius SET NOT NULL,
  ALTER COLUMN boiling_point_celsius SET NOT NULL,
  ALTER COLUMN atomic_mass TYPE DECIMAL USING atomic_mass::DECIMAL;

CREATE TABLE types (
  type_id INTEGER PRIMARY KEY,
  type VARCHAR(30) NOT NULL UNIQUE
);

INSERT INTO types (type_id, type) VALUES
  (1, 'metal'),
  (2, 'metalloid'),
  (3, 'nonmetal');

ALTER TABLE properties ADD COLUMN type_id INTEGER;
UPDATE properties
SET type_id = types.type_id
FROM types
WHERE properties.type = types.type;

ALTER TABLE properties DROP COLUMN type;
ALTER TABLE properties
  ALTER COLUMN type_id SET NOT NULL,
  ADD CONSTRAINT properties_type_id_fkey FOREIGN KEY (type_id) REFERENCES types(type_id),
  ADD CONSTRAINT properties_atomic_number_fkey FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);

UPDATE properties AS property
SET atomic_mass = mass.atomic_mass
FROM (VALUES
  (1, 1.008::DECIMAL),
  (2, 4.0026::DECIMAL),
  (3, 6.94::DECIMAL),
  (4, 9.0122::DECIMAL),
  (5, 10.81::DECIMAL),
  (6, 12.011::DECIMAL),
  (7, 14.007::DECIMAL),
  (8, 15.999::DECIMAL)
) AS mass(atomic_number, atomic_mass)
WHERE property.atomic_number = mass.atomic_number;

INSERT INTO elements (atomic_number, symbol, name) VALUES
  (9, 'F', 'Fluorine'),
  (10, 'Ne', 'Neon');

INSERT INTO properties (atomic_number, type_id, atomic_mass, melting_point_celsius, boiling_point_celsius) VALUES
  (9, 3, 18.998, -220, -188.1),
  (10, 3, 20.18, -248.6, -246.1);

COMMIT;
