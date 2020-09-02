-- for current useability:
-- set up
-- "road to"

-- for a search tool:
-- seed source type: 1 per hour, Kingable per half hour, rare, 2xrare per node, hunt billmaster, crossbreed, crossbreed depth
-- alternate cross
-- n gardens?
-- grow time?

-- n recipes
-- glazenut 22 depth 1
-- royal fern 8 depth 4
-- blood pepper 12 depth 3

-- royal kukuru 
-- crafting
-- azeyma rose 1 depth 1
-- cloudsbreath 2 depth 1
-- nymeia lily 2 depth 1
-- pearl roselle 1 depth 1
-- halone gerbera 1 depth = 2 (azeyma)
-- broombush 3 depth 2 (flower)
-- jute 6 depth 2 (minion or flower)
-- umbrella fig 1 depth 1

-- minions
-- thavn onion in chocobo food?


CREATE TYPE plot_type AS ENUM ('4x4', '3x5');

DROP VIEW IF EXISTS vgroups;
DROP VIEW IF EXISTS vplots;
DROP TABLE IF EXISTS group_plots;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS plot_spots;
DROP TABLE IF EXISTS spots;
DROP TABLE IF EXISTS plots;
DROP TABLE IF EXISTS crops;

CREATE TABLE crops (
    name text PRIMARY KEY,
    abbrev text,
    html_class_name text NOT NULL UNIQUE
);

CREATE TABLE spots (
    id SERIAL PRIMARY KEY,
    switching boolean NOT NULL DEFAULT FALSE,
    crop_1 text NOT NULL REFERENCES crops(name),
    crop_2 text REFERENCES crops(name)
);
-- constraint crop vs switching

CREATE TABLE plots (
    id SERIAL PRIMARY KEY,
    org plot_type NOT NULL,
    desired_crop text REFERENCES crops(name),
    desired_seed text REFERENCES crops(name)
);
-- constraint desired crop OR seed must be filled

CREATE TABLE plot_spots (
    plot int REFERENCES plots(id),
    org int NOT NULL,
    spot int NOT NULL,
    permaplant boolean NOT NULL DEFAULT FALSE,
    PRIMARY KEY (plot, spot)
);

CREATE TABLE groups (
    name text PRIMARY KEY,
    league_only boolean NOT NULL
);

CREATE TABLE group_plots (
    "group" text REFERENCES groups(name),
    plot int REFERENCES plots(id),
    PRIMARY KEY ("group", plot)
);

INSERT INTO crops (abbrev, name, html_class_name) VALUES
('EL', 'Earthlight', 'earthlight'),
('EK', 'Eggplant Knight', 'knight'),
('GJ', 'Garlic Jester', 'jester'),
('MQ', 'Mandragora Queen', 'queen'),
('OP', 'Onion Prince', 'prince'),
('TK', 'Tomato King', 'king'),
('UF', 'Umbrella Fig', 'umbrella'),
('HL', 'Honey Lemon', 'lemon'),
('JT', 'Jute', 'jute'),
('BB', 'Broombush', 'broombush'),
('HG', 'Halone Gerbera', 'halone'),
('AL', 'Almonds', 'almonds'),
('NL', 'Nymeia Lily', 'nymeia'),
('PR', 'Pearl Roselle', 'roselle'),
('CB', 'Cloudsbreath', 'cloudsbreath'),
('CH', 'Chamomile', 'chamomile'),
('AR', 'Azeyma Rose', 'azeyma'),
('MK', 'Mandrake', 'mandrake'),
('TO', 'Thavnairian Onion', 'onion'),
('MB', 'Midland Basil', 'basil'),
('CT', 'Coerthan Tea', 'coerthan'),
('LS', 'Linseed', 'linseed'),
('BC', 'Blood Currant', 'currant'),
('KR', 'Krakka Root', 'krakka'),
('PF', 'Pahsana Fruit', 'pahsana'),
('SB', 'Sylkis Bud', 'sylkis'),
('TP', 'Tantalplant', 'tantalplant'),
('MC', 'Midland Cabbage', 'cabbage'),
('BP', 'Blood Pepper', 'blood'),
('CH', 'Chives', 'chives'),
('CR', 'Curiel Root', 'curiel'),
('MG', 'Mimett Gourd', 'mimett'),
('DP', 'Dalamud Popoto', 'dalamud'),
('DT', 'Dzemael Tomato', 'dzemael'),
('GZ', 'Glazenut', 'glazenut'),
('MG', 'Mimmett Gourd', 'mimmett'),
('OWF', 'Old World Fig', 'owf'),
('PS', 'Pearl Sprouts', 'pearl'),
('CP', 'Cieldalaes Pineapple', 'cieldalaes'),
('PP', 'Prickly Pineapple', 'pineapple'),
('RF', 'Royal Fern', 'fern'),
('RKB', 'Royal Kukuru Bean', 'rkb');

INSERT INTO spots (crop_1)
SELECT name FROM crops;
INSERT INTO spots (switching, crop_1, crop_2) VALUES (true, 'Old World Fig', 'Royal Kukuru Bean');

INSERT INTO plots (org, desired_seed) VALUES 
('3x5', 'Mandragora Queen'),
('3x5', 'Jute'),
('3x5', 'Thavnairian Onion'),
('3x5', 'Blood Pepper'), 
('3x5', 'Royal Fern');
INSERT INTO plot_spots (plot, org, spot) VALUES
((SELECT id FROM plots WHERE desired_seed='Thavnairian Onion'), 3, (SELECT id FROM spots WHERE switching=false AND crop_1='Sylkis Bud')),
((SELECT id FROM plots WHERE desired_seed='Thavnairian Onion'), 5, (SELECT id FROM spots WHERE switching=true AND crop_1='Old World Fig')),
((SELECT id FROM plots WHERE desired_seed='Blood Pepper'), 3, (SELECT id FROM spots WHERE switching=false AND crop_1='Chives')),
((SELECT id FROM plots WHERE desired_seed='Blood Pepper'), 5, (SELECT id FROM spots WHERE switching=false AND crop_1='Glazenut')),
((SELECT id FROM plots WHERE desired_seed='Royal Fern'), 3, (SELECT id FROM spots WHERE switching=false AND crop_1='Blood Pepper')),
((SELECT id FROM plots WHERE desired_seed='Royal Fern'), 5, (SELECT id FROM spots WHERE switching=false AND crop_1='Old World Fig'));

INSERT INTO plot_spots (plot, org, spot, permaplant) VALUES 
((SELECT id FROM plots WHERE desired_seed='Jute'), 3, (SELECT id FROM spots WHERE switching=false AND crop_1='Pearl Roselle'), true),
((SELECT id FROM plots WHERE desired_seed='Jute'), 5, (SELECT id FROM spots WHERE switching=false AND crop_1='Mandrake'), false),
((SELECT id FROM plots WHERE desired_seed='Mandragora Queen'), 3, (SELECT id FROM spots WHERE switching=false AND crop_1='Nymeia Lily'), true),
((SELECT id FROM plots WHERE desired_seed='Mandragora Queen'), 5, (SELECT id FROM spots WHERE switching=false AND crop_1='Mandrake'), false);

INSERT INTO plots (org, desired_seed) VALUES 
('4x4', 'Eggplant Knight'),
('4x4', 'Tomato King'),
('4x4', 'Onion Prince'),
('4x4', 'Garlic Jester'),
('4x4', 'Umbrella Fig'),
('4x4', 'Broombush'),
('4x4', 'Halone Gerbera'),
('4x4', 'Pearl Roselle'),
('4x4', 'Nymeia Lily'),
('4x4', 'Cloudsbreath'),
('4x4', 'Azeyma Rose'),
('4x4', 'Tantalplant'),
('4x4', 'Sylkis Bud'),
('4x4', 'Pahsana Fruit'),
('4x4', 'Mimett Gourd'),
('4x4', 'Curiel Root'),
('4x4', 'Dalamud Popoto'),
('4x4', 'Chives'),
('4x4', 'Glazenut');
INSERT INTO plots (org, desired_crop, desired_seed) VALUES
('4x4', 'Royal Fern', 'Chives');

INSERT INTO plot_spots (plot, org, spot) VALUES
((SELECT id FROM plots WHERE desired_seed='Eggplant Knight'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Onion Prince')), 
((SELECT id FROM plots WHERE desired_seed='Eggplant Knight'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Krakka Root')), 
((SELECT id FROM plots WHERE desired_seed='Tomato King'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Cieldalaes Pineapple')), 
((SELECT id FROM plots WHERE desired_seed='Tomato King'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Pearl Roselle')), 
((SELECT id FROM plots WHERE desired_seed='Onion Prince'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Krakka Root')), 
((SELECT id FROM plots WHERE desired_seed='Onion Prince'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Mandrake')), 
((SELECT id FROM plots WHERE desired_seed='Garlic Jester'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Coerthan Tea')), 
((SELECT id FROM plots WHERE desired_seed='Garlic Jester'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Earthlight')), 
((SELECT id FROM plots WHERE desired_seed='Umbrella Fig'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Honey Lemon')), 
((SELECT id FROM plots WHERE desired_seed='Umbrella Fig'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Old World Fig')), 
((SELECT id FROM plots WHERE desired_seed='Broombush'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Coerthan Tea')), 
((SELECT id FROM plots WHERE desired_seed='Broombush'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Pearl Roselle')), 
((SELECT id FROM plots WHERE desired_seed='Halone Gerbera'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Azeyma Rose')), 
((SELECT id FROM plots WHERE desired_seed='Halone Gerbera'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Chamomile')), 
((SELECT id FROM plots WHERE desired_seed='Pearl Roselle'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Coerthan Tea')), 
((SELECT id FROM plots WHERE desired_seed='Pearl Roselle'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Almonds')), 
((SELECT id FROM plots WHERE desired_seed='Nymeia Lily'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Coerthan Tea')), 
((SELECT id FROM plots WHERE desired_seed='Nymeia Lily'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Mandrake')), 
((SELECT id FROM plots WHERE desired_seed='Cloudsbreath'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Coerthan Tea')), 
((SELECT id FROM plots WHERE desired_seed='Cloudsbreath'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Dzemael Tomato')), 
((SELECT id FROM plots WHERE desired_seed='Azeyma Rose'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Chamomile')), 
((SELECT id FROM plots WHERE desired_seed='Azeyma Rose'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Coerthan Tea')), 
((SELECT id FROM plots WHERE desired_seed='Tantalplant'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Krakka Root')), 
((SELECT id FROM plots WHERE desired_seed='Tantalplant'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Midland Basil')),
((SELECT id FROM plots WHERE desired_seed='Sylkis Bud'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Krakka Root')), 
((SELECT id FROM plots WHERE desired_seed='Sylkis Bud'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Coerthan Tea')),
((SELECT id FROM plots WHERE desired_seed='Pahsana Fruit'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Krakka Root')), 
((SELECT id FROM plots WHERE desired_seed='Pahsana Fruit'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Linseed')),
((SELECT id FROM plots WHERE desired_seed='Mimett Gourd'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Krakka Root')), 
((SELECT id FROM plots WHERE desired_seed='Mimett Gourd'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Midland Cabbage')),
((SELECT id FROM plots WHERE desired_seed='Curiel Root'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Krakka Root')), 
((SELECT id FROM plots WHERE desired_seed='Curiel Root'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Blood Currant')),
((SELECT id FROM plots WHERE desired_crop='Royal Fern' AND org='4x4'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Royal Fern')), 
((SELECT id FROM plots WHERE desired_crop='Royal Fern' AND org='4x4'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Midland Cabbage')),
((SELECT id FROM plots WHERE desired_seed='Dalamud Popoto'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Old World Fig')), 
((SELECT id FROM plots WHERE desired_seed='Dalamud Popoto'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Pearl Sprouts')),
((SELECT id FROM plots WHERE desired_seed='Chives' AND desired_crop IS NULL), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Dzemael Tomato')), 
((SELECT id FROM plots WHERE desired_seed='Chives' AND desired_crop IS NULL), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Dalamud Popoto')),
((SELECT id FROM plots WHERE desired_seed='Glazenut'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Old World Fig')), 
((SELECT id FROM plots WHERE desired_seed='Glazenut'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Prickly Pineapple'));

INSERT INTO groups (name, league_only) VALUES 
('Minions', false),
('Misc Crafting', false),
('Royal Fern (and Blood Pepper)', false),
('Kai''s House', true),
('League House', true),
('Fram''s House', true),
('Chocobo Food', false);

INSERT INTO group_plots ("group", plot) VALUES 
('Misc Crafting', (SELECT id FROM plots WHERE desired_seed='Azeyma Rose')),
('Misc Crafting', (SELECT id FROM plots WHERE desired_seed='Cloudsbreath')),
('Misc Crafting', (SELECT id FROM plots WHERE desired_seed='Nymeia Lily')),
('Misc Crafting', (SELECT id FROM plots WHERE desired_seed='Pearl Roselle')),
('Misc Crafting', (SELECT id FROM plots WHERE desired_seed='Halone Gerbera')),
('Misc Crafting', (SELECT id FROM plots WHERE desired_seed='Broombush')),
('Misc Crafting', (SELECT id FROM plots WHERE desired_seed='Jute')),
('Misc Crafting', (SELECT id FROM plots WHERE desired_seed='Umbrella Fig')),
('Minions', (SELECT id FROM plots WHERE desired_seed='Garlic Jester')),
('Minions', (SELECT id FROM plots WHERE desired_seed='Mandragora Queen')),
('Minions', (SELECT id FROM plots WHERE desired_seed='Onion Prince')),
('Minions', (SELECT id FROM plots WHERE desired_seed='Tomato King')),
('Minions', (SELECT id FROM plots WHERE desired_seed='Eggplant Knight')),
-- ('Minions', (SELECT id FROM plots WHERE desired_seed='')),
('Royal Fern (and Blood Pepper)', (SELECT id FROM plots WHERE desired_seed='Dalamud Popoto')),
('Royal Fern (and Blood Pepper)', (SELECT id FROM plots WHERE desired_seed='Chives' and desired_crop IS NULL)),
('Royal Fern (and Blood Pepper)', (SELECT id FROM plots WHERE desired_seed='Blood Pepper')),
('Royal Fern (and Blood Pepper)', (SELECT id FROM plots WHERE desired_seed='Glazenut')),
('Royal Fern (and Blood Pepper)', (SELECT id FROM plots WHERE desired_seed='Royal Fern')),
('Chocobo Food', (SELECT id FROM plots WHERE desired_seed='Tantalplant')),
('Chocobo Food', (SELECT id FROM plots WHERE desired_seed='Sylkis Bud')),
('Chocobo Food', (SELECT id FROM plots WHERE desired_seed='Pahsana Fruit')),
('Chocobo Food', (SELECT id FROM plots WHERE desired_seed='Mimett Gourd')),
('Chocobo Food', (SELECT id FROM plots WHERE desired_seed='Curiel Root')),
('Chocobo Food', (SELECT id FROM plots WHERE desired_seed='Thavnairian Onion')),
('Fram''s House', (SELECT id FROM plots WHERE desired_crop='Royal Fern' AND org='4x4')),
('Kai''s House', (SELECT id FROM plots WHERE desired_seed='Blood Pepper')),
('Kai''s House', (SELECT id FROM plots WHERE desired_seed='Glazenut')),
('League House', (SELECT id FROM plots WHERE desired_seed='Royal Fern' AND org='3x5')),
('League House', (SELECT id FROM plots WHERE desired_seed='Thavnairian Onion'));

-- UPDATE plot_spots SET permaplant=false;
UPDATE plot_spots AS ps SET permaplant=true
FROM spots AS s
WHERE ps.spot=s.id AND (s.crop_1='Blood Pepper' OR s.crop_1='Chives' OR s.crop_1='Sylkis Bud');
-- SELECT * FROM plot_spots;

DROP VIEW IF EXISTS vgroups;
DROP VIEW IF EXISTS vplots;
CREATE VIEW vplots AS
WITH desireds AS 
(
    SELECT p.id, 
        row_to_json((SELECT _ FROM (SELECT dc1.name, dc1.abbrev, dc1.html_class_name) _)) as desired_crop, 
        row_to_json((SELECT _ FROM (SELECT dc2.name, dc2.abbrev, dc2.html_class_name) _)) as desired_seed
    FROM plots AS p
        LEFT JOIN crops AS dc1 ON p.desired_crop=dc1.name
        LEFT JOIN crops AS dc2 ON p.desired_seed=dc2.name
),
spots AS 
(
    SELECT id, json_agg(spot) as spots
    FROM 
    (
        SELECT p.id, 
            json_build_object(
                'org', ps.org,
                'switching', s.switching,
                'permaplant', ps.permaplant,
                'crop_1', row_to_json((SELECT _ FROM (SELECT c1.name, c1.abbrev, c1.html_class_name) _)),
                'crop_2', row_to_json((SELECT _ FROM (SELECT c2.name, c2.abbrev, c2.html_class_name) _)) 
            ) as spot
        FROM plots AS p
            LEFT JOIN plot_spots AS ps ON p.id=ps.plot
            LEFT JOIN spots AS s ON ps.spot=s.id
            LEFT JOIN crops AS c1 ON s.crop_1=c1.name
            LEFT JOIN crops AS c2 ON s.crop_2=c2.name
    ) a
    GROUP BY id
)
SELECT p.id, dc.desired_crop, dc.desired_seed, p.org, s.spots
FROM plots AS p
    LEFT JOIN desireds AS dc ON p.id=dc.id
    LEFT JOIN spots AS s ON p.id=s.id;

DROP VIEW IF EXISTS vgroups;
CREATE VIEW vgroups AS
WITH vp AS 
(
    SELECT id, row_to_json((SELECT _ FROM (SELECT desired_crop, desired_seed, org, spots) _)) AS plot
    FROM vplots
)
SELECT g.name, json_agg(p.plot) as plots
FROM groups as g
	LEFT JOIN group_plots as gp ON g.name=gp.group
	LEFT JOIN vp AS p ON gp.plot=p.id
GROUP BY g.name
ORDER BY g.league_only;

GRANT SELECT ON group_plots, groups, plots, crops, vplots, vgroups TO ffxivro;

-- LEGEND ONE TIME USE
-- INSERT INTO plots (org, desired_crop, desired_seed) VALUES
-- ('4x4', 'Royal Fern', 'Azeyma Rose');
-- INSERT INTO plot_spots (plot, org, spot) VALUES
-- ((SELECT id FROM plots WHERE desired_seed='Azeyma Rose'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Royal Fern')), 
-- ((SELECT id FROM plots WHERE desired_seed='Azeyma Rose'), 4, (SELECT id FROM spots WHERE switching=false AND crop_1='Mandrake'));
-- INSERT INTO groups (name, league_only) VALUES 
-- ('Legend', true);
-- INSERT INTO group_plots ("group", plot) VALUES 
-- ('Legend', (SELECT id FROM plots WHERE desired_seed='Azeyma Rose'));
-- UPDATE plot_spots AS ps SET permaplant=true
-- FROM spots as s
-- WHERE ps.spot=s.id 
-- AND (s.crop_1='Royal Fern' AND plot=(SELECT id FROM plots WHERE desired_seed='Azeyma Rose'));