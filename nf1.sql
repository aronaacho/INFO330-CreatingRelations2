-- grabbing original data as imported_pokemon_data
.mode csv
.import pokemon.csv imported_pokemon_data

-- correcting imported_pokemon_data where capture_rate has two values
UPDATE imported_pokemon_data
SET capture_rate = '30' 
WHERE pokedex_number = '774';

-- creating split_abilities table to split 'abilities' column
-- recursion annotation worksheet: https://docs.google.com/presentation/d/1CAkJA_GJZ8_Iu-XPGiIGnJNxpiPUPDla5MCM9Zn3AQk/edit?usp=sharing
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

-- cleaning up the data
UPDATE split_abilities 
SET ability = REPLACE(ability, '[', '');

UPDATE split_abilities
SET ability = REPLACE(ability, ']', '');

UPDATE split_abilities
SET ability = trim(ability);

-- joining split_abilities column to imported_pokemon_data table by pokedex_number
CREATE TABLE nf1 AS 
SELECT imported_pokemon_data.*, split_abilities.ability
FROM imported_pokemon_data, split_abilities 
WHERE imported_pokemon_data.pokedex_number = split_abilities.pokedex_number;

-- dropping the muli-valued abilities column
ALTER TABLE nf1
DROP COLUMN abilities;

-- dropping split_abilities and imported_pokemon_data table
DROP TABLE split_abilities;
DROP TABLE imported_pokemon_data;

/* 
resulting tables:
nf1
*/