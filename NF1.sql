-- correcting imported_pokemon_data where capture_rate = two values
UPDATE imported_pokemon_data
SET capture_rate = '30' 
WHERE pokedex_number = '774';

-- creating split_abilities table to split abilities columns
CREATE TABLE split_abilities (ability TEXT, pokedex_number TEXT);


INSERT INTO split_abilities 
WITH split(pokedex_number, ability, nextability) -- 1. start of query
    AS (
        SELECT -- 2. start of anchor query: selecting the abilities of each pokedex_number
							pokedex_number, 
							'' AS ability, 
							abilities||',' AS nextability 
        FROM imported_pokemon_data -- 2. end of anchor query
        UNION ALL -- 4. union: connects the queries together
            SELECT pokedex_number, -- 3. start of recursive query: selecting and sunstr/instr-ing individual abilities into ability and nextability
            substr(nextability, 0, instr(nextability, ',')) AS ability,
            substr(nextability, instr(nextability, ',') + 1) AS nextability
            FROM split
            WHERE nextability !=''
    )
    SELECT DISTINCT ability, pokedex_number -- 5. end: all abilities are separated
    FROM split
    WHERE ability !=''; -- 5. end of query

-- cleaning up the data
UPDATE split_abilities 
SET ability = REPLACE(ability, '[', '');

UPDATE split_abilities
SET ability = REPLACE(ability, ']', '');

UPDATE split_abilities
SET ability = trim(ability);

-- joining split_abilities column to the original table by pokedex_number
CREATE TABLE nf1 AS 
SELECT imported_pokemon_data.*, split_abilities.ability
FROM imported_pokemon_data, split_abilities 
WHERE imported_pokemon_data.pokedex_number = split_abilities.pokedex_number;

-- dropping the muli-valued abilities column
ALTER TABLE nf1
DROP COLUMN abilities;

-- dropping split_abilities table
DROP TABLE split_abilities;