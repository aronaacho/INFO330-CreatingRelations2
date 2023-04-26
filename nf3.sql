-- creating type_against table:

-- creating types table 
CREATE TABLE types (type_number INTEGER PRIMARY KEY, type_name1 TEXT, type_name2 TEXT);
INSERT INTO types (type_name1, type_name2) SELECT DISTINCT type1, type2 FROM pokemon_basic_stats;

-- creating pokemon_types table
CREATE TABLE pokemon_types AS
SELECT pokemon_basic_stats.pokedex_number, types.type_number
FROM pokemon_basic_stats, types
WHERE pokemon_basic_stats.type1 = types.type_name1 AND
			pokemon_basic_stats.type2 = types.type_name2;

-- creating type_against table
CREATE TABLE type_against AS
SELECT types.type_number, type_effectiveness.effect_number
FROM types, type_effectiveness
WHERE types.type_name1 = type_effectiveness.type1 AND
			types.type_name2 = type_effectiveness.type2;

-- dropping types in the type_effectiveness and pokemon_basic_stats table
ALTER TABLE type_effectiveness DROP COLUMN type1;
ALTER TABLE type_effectiveness DROP COLUMN type2;
ALTER TABLE pokemon_basic_stats DROP COLUMN type1;
ALTER TABLE pokemon_basic_stats DROP COLUMN type2;

/*
resulting tables:
-------------------------------------------------
abilities            pokemon_types        types              
pokemon_abilities    type_against       
pokemon_basic_stats  type_effectiveness
*/