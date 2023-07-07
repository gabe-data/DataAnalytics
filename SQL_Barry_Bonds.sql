-- Top 3 home run seasons
SELECT "year" , hr 
FROM barry_bonds bb
ORDER BY hr DESC 
LIMIT 3;

-- average ops in mvp years 
SELECT avg(ops) AS average_ops_mvp
FROM barry_bonds bb 
WHERE mvp = 'Yes';

-- Were there any years when Barry Bonds won the mvp but was not named a gold glover? 
SELECT YEAR, team, gold_glove, mvp 
FROM barry_bonds bb 
WHERE mvp = 'Yes' AND gold_glove= 'No';

-- What was the least amount of games needed to play for Barry Bonds to win an mvp? 
SELECT games, YEAR, team, mvp
FROM barry_bonds bb 
WHERE mvp = 'Yes'
ORDER BY games ASC 
LIMIT 1;

-- How many home runs did Barry Bonds hit in his entire career? 
SELECT sum(hr) AS career_hr
FROM barry_bonds bb;

-- On average, how many at-bats would it take Barry Bonds to hit a home run?
SELECT round(sum(ab)::numeric/sum(hr),2) AS ab_per_hr
FROM barry_bonds bb;

-- On average, how many at-bats did it take per home run in his best home run season?
SELECT "year" , ab, hr, round(sum(ab)::numeric/sum(hr),2) AS ab_per_hr
FROM barry_bonds bb 
GROUP BY YEAR, ab, hr 
ORDER BY hr desc 
LIMIT 1;

-- Of all his career hits, what percentage were home runs? 
SELECT sum(hr)::NUMERIC/sum(hits) AS percent_of_hits
FROM barry_bonds bb; 

-- How many seasons did Barry Bonds hit more home runs than his 162 game home run average?
SELECT count(*) AS more_than_average
FROM barry_bonds bb 
WHERE hr>= (SELECT sum(hr)/(sum(games)::NUMERIC /162) FROM barry_bonds bb2);

-- What was the correlation between getting on base (OBP) and being intentionally walked? Consider a 
-- a good sample size. Let's say greater than or equal to his 162 average for at-bats.

SELECT CORR(obp, ibb)
FROM barry_bonds bb 
WHERE ab>= (SELECT sum(ab)/(sum(games)::NUMERIC /162) FROM barry_bonds bb2);

-- What were Barry Bond's 2nd and 3rd most extra-base hit seasons?
SELECT "year" ,sum(doubles) + sum(triples) + sum(hr) AS XBH  
FROM barry_bonds bb 
GROUP BY YEAR 
ORDER BY xbh DESC
LIMIT 2
OFFSET 1;

-- What was the correlation between % batted balls in the air to home runs? 
SELECT CORR(bb.hr,ba."FB%")
FROM barry_bonds bb 
JOIN bonds_advanced ba 
USING(year);

-- How many of Barry Bonds' walks were not intentional?
SELECT sum(walks)-sum(ibb) AS earned_walks
FROM barry_bonds bb ;

-- Create a table indicating when Barry Bonds had a batting average better or worse than the league's average.
SELECT year,ba,lgba, 
CASE	
	WHEN ba > lgba THEN 'Better'
	WHEN ba < lgba THEN 'Worse'
	ELSE 'Equal'
END AS better_or_worse
FROM bonds_sabometrics bs 
ORDER BY YEAR;







