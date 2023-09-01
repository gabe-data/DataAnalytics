/* This is SQL project that takes a look at the career of Barry Bonds. 
 */
-- How many years did Barry Bonds play in the MLB? From this, determine whether or not Bonds whether Bonds hit more home runs in the first or second half of his career.
SELECT count(Year)
FROM barry_bonds bb;

WITH first_half AS (
    SELECT sum(hr) AS total
    FROM barry_bonds
    WHERE year  <= 1996
),
second_half AS (
    SELECT sum(hr) AS total
    FROM barry_bonds
    WHERE year  >= 1997
)
SELECT first_half.total AS first_half_total, second_half.total AS second_half_total
FROM first_half, second_half;

-- Show a list of Barry Bonds career Home Run totals progression, year by year.
SELECT YEAR, team, sum(hr) OVER (ORDER BY year)
FROM barry_bonds bb;

-- Create a table indicating when Barry Bonds had a batting average better or worse than the league's average.
SELECT year,ba,lgba, 
CASE	
	WHEN ba > lgba THEN 'Better'
	WHEN ba < lgba THEN 'Worse'
	ELSE 'Equal'
END AS better_or_worse
FROM bonds_sabometrics bs 
ORDER BY YEAR;

-- What is the most home runs Barry Bonds ever hit in a single season? 
SELECT YEAR, team, hr 
FROM barry_bonds bb
ORDER BY hr DESC 
LIMIT 1;

-- In this season, what was his home run percentage? 
WITH best AS (
SELECT YEAR, team, ab, hr 
FROM barry_bonds bb
ORDER BY hr DESC 
LIMIT 1)
SELECT hr/ab::NUMERIC  AS hr_percentage, hr, ab 
FROM best; 
 
-- Create a column indicating whether or not Bonds was the league on-base percentage leader that year.
ALTER TABLE barry_bonds 
ADD COLUMN obp_leader varchar(50);

UPDATE barry_bonds 
SET obp_leader = 'Yes'
WHERE YEAR IN (1991,1992,1993,1995,2001,2002,2003,2004,2006,2007);

UPDATE barry_bonds 
SET obp_leader = 'No'
WHERE obp_leader IS NULL; 

-- What was the average number of strikeouts per season? Show the seasons where he struck out more than his average?
SELECT YEAR, strikeouts 
FROM barry_bonds bb 
WHERE strikeouts > (SELECT avg(strikeouts) FROM barry_bonds bb2)
ORDER BY strikeouts DESC

-- Calculate the correlation between his extra-base hits and his slugging percentage. 
SELECT CORR(slg, xbh)
FROM (SELECT YEAR, (hr+triples+doubles) AS xbh, slg
		FROM barry_bonds bb ) AS xbh; 


-- On average, how many at-bats did it take per home run in his best home run season?
SELECT "year" , ab, hr, round(sum(ab)::numeric/sum(hr),2) AS ab_per_hr
FROM barry_bonds bb 
GROUP BY YEAR, ab, hr 
ORDER BY hr desc 
LIMIT 1;

-- Create a table that shows Bonds' batting average, babip, and the number of hits. 
SELECT bb.ba, ba.babip, bb.hits
FROM barry_bonds bb 
JOIN bonds_advanced ba 
ON bb."year" = ba."year" 

-- Show the years where Barry Bonds was the OBP leader and the MVP? 
SELECT YEAR, team, obp
FROM barry_bonds bb 
WHERE obp_leader = 'Yes' AND mvp = 'No'

-- In the years he was the OBP leader, what were his unintentional walk numbers? 
SELECT YEAR, team, walks - ibb AS earned_walks
FROM barry_bonds bb 
WHERE obp_leader = 'Yes'
ORDER BY earned_walks DESC 

