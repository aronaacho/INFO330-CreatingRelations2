-- creating trainer table
-- PRIMARY KEY: trainer_number
CREATE TABLE trainer (trainer_number INTEGER PRIMARY KEY, first_name VARCHAR(80), last_name VARCHAR(80));

INSERT INTO trainer (first_name, last_name) VALUES 
('Arona', 'Cho'),
('Ted', 'Neward'),
('Justin', 'Dong'),
('Kaarina', 'Tulleau'),
('Arpan', 'Kapoor');

-- creating favorite_pokemon_types table
-- FOREIGN KEYS: trainer_number, type_number
CREATE TABLE favorite_pokemon_types (trainer_number REFERENCES trainer(trainer_number), type_number REFERENCES types(type_number));
INSERT INTO favorite_pokemon_types VALUES
(1, 59),
(1, 77),
(2, 89),
(3, 106),
(4, 92),
(4, 34),
(5, 4);

-- creating teams table
-- FOREIGN KEYS: trainer_number, pokedex_number
CREATE TABLE teams (trainer_number REFERENCES trainer(trainer_number), pokedex_number REFERENCES pokemon_basic_stats(pokedex_number));
INSERT INTO teams VALUES 
(1, 668),
(1, 208),
(1, 292),
(2, 361),
(2, 713),
(3, 475),
(3, 794),
(3, 800),
(3, 655),
(4, 379),
(4, 599),
(4, 474),
(4, 572),
(5, 7),
(5, 771),
(5, 393),
(5, 594);