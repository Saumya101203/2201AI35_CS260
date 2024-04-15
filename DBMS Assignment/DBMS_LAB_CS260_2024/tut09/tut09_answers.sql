-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 
-- 1. List the names of all left-handed batsmen from England.
SELECT player_name
FROM players
WHERE batting_hand = 'Left-hand bat' AND country_name = 'England'
ORDER BY player_name;

-- 2. List the names and age of all bowlers with skill “Legbreak googly” who are 28 or more in age.
SELECT player_name, 
       EXTRACT(YEAR FROM AGE('2018-12-02', dob)) AS player_age
FROM players
JOIN player_match_roles ON players.player_id = player_match_roles.player_id
WHERE bowling_skill = 'Legbreak googly'
AND EXTRACT(YEAR FROM AGE('2018-12-02', dob)) >= 28
ORDER BY player_age DESC, player_name;

-- 3. List the match ids and toss winning team IDs where the toss winner decided to bat first.
SELECT match_id, toss_winner
FROM matches
WHERE toss_decision = 'bat'
ORDER BY match_id;

-- 4. In match id 335987, list the over ids and runs scored where at most 7 runs were scored.
SELECT over_id, SUM(runs_scored) AS runs_scored
FROM ball_by_ball
WHERE match_id = 335987
GROUP BY over_id
HAVING SUM(runs_scored) <= 7
ORDER BY runs_scored DESC, over_id ASC;

-- 5. List the names of those batsmen who were bowled at least once.
SELECT DISTINCT player_name
FROM players
JOIN ball_by_ball ON players.player_id = ball_by_ball.striker
WHERE kind_out LIKE '%bowled%'
ORDER BY player_name;

-- 6. List all the match ids along with team names and win margin where win margin is at least 60 runs.
SELECT m.match_id, t1.name AS team_1, t2.name AS team_2, 
       CASE WHEN m.match_winner = t1.team_id THEN t1.name ELSE t2.name END AS winning_team_name,
       win_margin
FROM matches m
JOIN teams t1 ON m.team_1 = t1.team_id
JOIN teams t2 ON m.team_2 = t2.team_id
WHERE win_margin >= 60
ORDER BY win_margin, m.match_id;

-- 7. List the names of all left handed batsmen below 30 years of age as on 2018-12-02.
SELECT player_name
FROM players
WHERE batting_hand = 'Left-hand bat' 
AND EXTRACT(YEAR FROM AGE('2018-12-02', dob)) < 30
ORDER BY player_name;

-- 8. List the match wise total for the entire series.
SELECT match_id, SUM(runs_scored) AS total_runs
FROM ball_by_ball
GROUP BY match_id
ORDER BY match_id;

-- 9. For each match id, list the maximum runs scored in any over and the bowler bowling in that over.
WITH MaxRunsPerOver AS (
    SELECT match_id, over_id, MAX(runs_scored) AS max_runs
    FROM ball_by_ball
    GROUP BY match_id, over_id
)
SELECT b.match_id, b.over_id, b.striker AS bowler_id, p.player_name
FROM MaxRunsPerOver m
JOIN ball_by_ball b ON m.match_id = b.match_id AND m.over_id = b.over_id AND m.max_runs = b.runs_scored
JOIN players p ON b.striker = p.player_id
ORDER BY b.match_id, b.over_id;

-- 10. List the names of batsmen and the number of times they have been “run out”.
SELECT p.player_name, COUNT(*) AS number
FROM players p
JOIN ball_by_ball b ON p.player_id = b.player_out
WHERE kind_out = 'run out'
GROUP BY p.player_name
ORDER BY number DESC, p.player_name;

-- 11. List the number of times any batsman has got out for any out type.
SELECT kind_out, COUNT(*) AS number
FROM ball_outs
GROUP BY kind_out
ORDER BY number DESC, kind_out;

-- 12. List the team name and the number of times any player from the team has received man of the match award.
SELECT t.name, COUNT(*) AS number
FROM teams t
JOIN matches m ON t.team_id = m.man_of_the_match
GROUP BY t.name
ORDER BY t.name;

-- 13. Find the venue where the maximum number of wides have been given.
SELECT venue
FROM (
    SELECT venue, COUNT(*) AS wides_count
    FROM ball_by_ball
    WHERE extra_type = 'wide'
    GROUP BY venue
    ORDER BY wides_count DESC, venue ASC
    LIMIT 1
) AS subquery;

-- 14. Find the venues where the team bowling first has won the match.
SELECT venue
FROM (
    SELECT venue, 
           CASE 
               WHEN (team_1 = match_winner AND toss_decision = 'field') 
                    OR (team_2 = match_winner AND toss_decision = 'bat') THEN 1
               ELSE 0
           END AS won
    FROM matches
) AS subquery
WHERE won = 1
GROUP BY venue
ORDER BY COUNT(*) DESC, venue ASC;

-- 15. Find the bowler who has the best average overall.
SELECT p.player_name
FROM (
    SELECT bowler, 
           SUM(runs_scored) AS total_runs, 
           COUNT(*) AS total_wickets
    FROM ball_by_ball
    WHERE kind_out != 'not out'
    GROUP BY bowler
) AS bowling_stats
JOIN players p ON bowling_stats.bowler = p.player_id
ORDER BY (total_runs / NULLIF(total_wickets, 0)) ASC, p.player_name
LIMIT 1;

-- 16. List the players and the corresponding teams where the player played as “CaptainKeeper” and won the match.
SELECT p.player_name, t.name
FROM players p
JOIN player_match_roles pmr ON p.player_id = pmr.player_id
JOIN teams t ON pmr.team_id = t.team_id
JOIN matches m ON pmr.match_id = m.match_id
WHERE pmr.role = 'CaptainKeeper' AND m.match_winner = pmr.team_id
ORDER BY p.player_name;

-- 17. List the names of all players and their runs scored (who have scored at least 50 runs in any match).
SELECT p.player_name, SUM(runs_scored) AS runs_scored
FROM players p
JOIN ball_by_ball b ON p.player_id = b.striker
GROUP BY p.player_name
HAVING SUM(runs_scored) >= 50
ORDER BY runs_scored DESC, p.player_name;

-- 18. List the player names who scored a century but their teams lost the match.
SELECT p.player_name
FROM players p
JOIN ball_by_ball b ON p.player_id = b.striker
JOIN matches m ON b.match_id = m.match_id
WHERE runs_scored >= 100 AND m.match_winner != b.team_batting
ORDER BY p.player_name;
