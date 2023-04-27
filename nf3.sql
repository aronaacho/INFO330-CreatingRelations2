-- creating type_effectiveness table
-- effectiveness is based on the type combos therefore together

-- effect_number: numbers for all unique against_* combos
-- temp columns: type1, type2
-- PRIMARY KEY: effect_number
CREATE TABLE type_effectiveness 
	(effect_number INTEGER PRIMARY KEY,
	type1 REFERENCES pokemon_basic_stats(type1),
	type2 REFERENCES pokemon_basic_stats(type2),
  against_bug TEXT,
  against_dark TEXT,
  against_dragon TEXT,
  against_electric TEXT,
  against_fairy TEXT,
  against_fight TEXT,
  against_fire TEXT,
  against_flying TEXT,
  against_ghost TEXT,
  against_grass TEXT,
  against_ground TEXT,
  against_ice TEXT,
  against_normal TEXT,
  against_poison TEXT,
  against_psychic TEXT,
  against_rock TEXT,
  against_steel TEXT,
  against_water TEXT);

INSERT INTO type_effectiveness 
	(type1,
	 type2,
  against_bug,
  against_dark,
  against_dragon,
  against_electric,
  against_fairy,
  against_fight,
  against_fire,
  against_flying,
  against_ghost,
  against_grass,
  against_ground,
  against_ice,
  against_normal,
  against_poison,
  against_psychic,
  against_rock,
  against_steel,
  against_water)
SELECT DISTINCT
	type1,
	type2,
  against_bug,
  against_dark,
  against_dragon,
  against_electric,
  against_fairy,
  against_fight,
  against_fire,
  against_flying,
  against_ghost,
  against_grass,
  against_ground,
  against_ice,
  against_normal,
  against_poison,
  against_psychic,
  against_rock,
  against_steel,
  against_water
FROM pokemon_basic_stats;

-- creating types table
-- type_number: numbers unique combos of type1 and type2 
-- PRIMARY KEY: type_number
CREATE TABLE types (type_number INTEGER PRIMARY KEY, type_name1 TEXT, type_name2 TEXT);
INSERT INTO types (type_name1, type_name2) SELECT DISTINCT type1, type2 FROM pokemon_basic_stats;

-- creating pokemon_types table
-- FOREIGN KEYS: pokedex_number, type_number
CREATE TABLE pokemon_types AS
SELECT pokemon_basic_stats.pokedex_number, types.type_number
FROM pokemon_basic_stats, types
WHERE pokemon_basic_stats.type1 = types.type_name1 AND
			pokemon_basic_stats.type2 = types.type_name2;

-- creating foreign keys for pokedex_number and type_number
ALTER TABLE pokemon_types 
ADD COLUMN pokedex_temp REFERENCES pokemon_basic_stats(pokedex_number);
ALTER TABLE pokemon_types
ADD COLUMN type_temp REFERENCES types(type_number);

UPDATE pokemon_types
SET pokedex_temp = pokedex_number, type_temp = type_number;

ALTER TABLE pokemon_types
DROP COLUMN pokedex_number;
ALTER TABLE pokemon_types
DROP COLUMN type_number;

ALTER TABLE pokemon_types
RENAME COLUMN pokedex_temp TO pokedex_number;
ALTER TABLE pokemon_types
RENAME COLUMN type_temp TO type_number;

-- creating type_against table
-- FOREIGN KEYS: type_number, effect_number
CREATE TABLE type_against AS
SELECT types.type_number, type_effectiveness.effect_number
FROM types, type_effectiveness
WHERE types.type_name1 = type_effectiveness.type1 AND
			types.type_name2 = type_effectiveness.type2;

-- creating foreign keys for effect_number and type_number
ALTER TABLE type_against 
ADD COLUMN effect_temp REFERENCES type_effectiveness(effect_number);
ALTER TABLE type_against
ADD COLUMN type_temp REFERENCES types(type_number);

UPDATE type_against
SET effect_temp = effect_number, type_temp = type_number;

ALTER TABLE type_against
DROP COLUMN effect_number;
ALTER TABLE type_against
DROP COLUMN type_number;

ALTER TABLE type_against
RENAME COLUMN effect_temp TO effect_number;
ALTER TABLE type_against
RENAME COLUMN type_temp TO type_number;

-- dropping columns in the type_effectiveness and pokemon_basic_stats table
ALTER TABLE type_effectiveness DROP COLUMN type1;
ALTER TABLE type_effectiveness DROP COLUMN type2;
ALTER TABLE pokemon_basic_stats DROP COLUMN type1;
ALTER TABLE pokemon_basic_stats DROP COLUMN type2; 
ALTER TABLE pokemon_basic_stats DROP COLUMN against_bug;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_dark;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_dragon;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_electric;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_fairy;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_fight;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_fire;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_flying;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_ghost;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_grass;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_ground;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_ice;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_normal;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_poison;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_psychic;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_rock;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_steel;
ALTER TABLE pokemon_basic_stats DROP COLUMN against_water;

/*
resulting tables:
abilities            pokemon_types        types              
pokemon_abilities    type_against      
pokemon_basic_stats  type_effectiveness
*/