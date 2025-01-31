-- grabbing original data for no duplicates when creating pokemon_basic_stats
.mode csv
.import pokemon.csv imported_pokemon_data
-- correcting imported_pokemon_data where capture_rate has two values
UPDATE imported_pokemon_data
SET capture_rate = '30' 
WHERE pokedex_number = '774';

-- create pokemon_basic_stats table
-- PRIMARY KEY: pokedex_number
CREATE TABLE pokemon_basic_stats
(pokedex_number TEXT PRIMARY KEY, 
name TEXT,
attack TEXT,
base_egg_steps TEXT,
base_happiness TEXT,
base_total TEXT,
capture_rate TEXT,
classfication TEXT,
defense TEXT,
experience_growth TEXT,
height_m TEXT,
hp TEXT,
percentage_male TEXT,
sp_attack TEXT,
sp_defense TEXT,
speed TEXT,
type1 TEXT,
type2 TEXT,
weight_kg TEXT,
generation TEXT,
is_legendary TEXT,
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

INSERT INTO pokemon_basic_stats
(pokedex_number, 
name,
attack,
base_egg_steps,
base_happiness,
base_total,
capture_rate,
classfication,
defense,
experience_growth,
height_m,
hp,
percentage_male,
sp_attack,
sp_defense,
speed,
type1,
type2,
weight_kg,
generation,
is_legendary,
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
SELECT
pokedex_number, 
name,
attack,
base_egg_steps,
base_happiness,
base_total,
capture_rate,
classfication,
defense,
experience_growth,
height_m,
hp,
percentage_male,
sp_attack,
sp_defense,
speed,
type1,
type2,
weight_kg,
generation,
is_legendary,
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
FROM imported_pokemon_data;

-- creating abilities table
-- PRIMARY KEY: ability_number
CREATE TABLE abilities (ability_number INTEGER PRIMARY KEY, ability TEXT);
INSERT INTO abilities (ability) SELECT DISTINCT ability FROM nf1;

-- temp table: split abilities table 
CREATE TABLE split_abilities (ability TEXT, pokedex_number TEXT);

INSERT INTO split_abilities 
WITH split(pokedex_number, ability, nextability) 
    AS (
        SELECT
							pokedex_number, 
							'' AS ability, 
							abilities||',' AS nextability 
        FROM imported_pokemon_data 
        UNION ALL 
            SELECT pokedex_number, 
            substr(nextability, 0, instr(nextability, ',')) AS ability,
            substr(nextability, instr(nextability, ',') + 1) AS nextability
            FROM split
            WHERE nextability !=''
    )
    SELECT DISTINCT ability, pokedex_number 
    FROM split
    WHERE ability !='';

-- cleaning up the temp_table data 
UPDATE split_abilities 
SET ability = REPLACE(ability, '[', '');

UPDATE split_abilities
SET ability = REPLACE(ability, ']', '');

UPDATE split_abilities
SET ability = trim(ability);

-- creating pokemon_abilities table, joining on abilities
-- FOREIGN KEYS: pokedex_number, ability_number
CREATE TABLE pokemon_abilities AS 
SELECT DISTINCT split_abilities.pokedex_number, abilities.ability_number
FROM split_abilities, abilities
WHERE abilities.ability = split_abilities.ability;

-- creating foreign keys for pokedex_number and ability_number
ALTER TABLE pokemon_abilities 
ADD COLUMN pokedex_temp REFERENCES pokemon_basic_stats(pokedex_number);
ALTER TABLE pokemon_abilities
ADD COLUMN ability_temp REFERENCES abilities(ability_number);

UPDATE pokemon_abilities
SET pokedex_temp = pokedex_number, ability_temp = ability_number;

ALTER TABLE pokemon_abilities
DROP COLUMN pokedex_number;
ALTER TABLE pokemon_abilities
DROP COLUMN ability_number;

ALTER TABLE pokemon_abilities
RENAME COLUMN pokedex_temp TO pokedex_number;
ALTER TABLE pokemon_abilities
RENAME COLUMN ability_temp TO ability_number;

-- drop split_abilities, nf1, and imported_pokemon_data tables
DROP TABLE split_abilities;
DROP TABLE nf1;
DROP TABLE imported_pokemon_data;

/*
resulting tables:
abilities            pokemon_abilities    pokemon_basic_stats
*/