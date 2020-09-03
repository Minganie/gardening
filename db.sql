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
SELECT g.name, g.league_only, json_agg(p.plot) as plots
FROM groups as g
	LEFT JOIN group_plots as gp ON g.name=gp.group
	LEFT JOIN vp AS p ON gp.plot=p.id
GROUP BY g.name, g.league_only
ORDER BY g.league_only, g.name;

GRANT SELECT ON group_plots, groups, plots, crops, vplots, vgroups TO ffxivro;
