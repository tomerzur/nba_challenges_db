select * from abbrevs;

select * from challenges;

select * from schedule;


-- number of games won, lost where a team successfully or unsuccessfully challenged a call
with schedule_winners as (
select *, case when away_pts > home_pts then away else home end as winner_name from schedule),

challenges1 as (
select *, a1.name as away_name, a2.name as home_name, a3.name as challenging_name
from challenges c join abbrevs a1 on c.away = a1.abbrev join abbrevs a2 on c.home = a2.abbrev join abbrevs a3 on c.challenging = a3.abbrev),

challenge_all_data as (
select *,
challenging_name = winner_name as challenger_won_game
from challenges1 c join schedule_winners s on c.date = s.date and c.away_name = s.away and c.home_name = s.home)

select result, challenger_won_game, count(*) from challenge_all_data group by result, challenger_won_game;



-- win percentage when using a challenge vs when not using a challenge 
with schedule_winners as (
select *, case when away_pts > home_pts then away else home end as winner_name from schedule),

challenges1 as (
select *, a1.name as away_name, a2.name as home_name, a3.name as challenging_name
from challenges c join abbrevs a1 on c.away = a1.abbrev join abbrevs a2 on c.home = a2.abbrev join abbrevs a3 on c.challenging = a3.abbrev),

schedule_away_games as (
select s.date as date, s.away as away, s.home as home, s.winner_name, c.period, c.time, c.challenging_name,
s.away = s.winner_name as won, c.date is not NULL as used_challenge
from schedule_winners s left join challenges1 c on s.date = c.date and s.away = c.away_name and s.away = c.challenging_name),

schedule_home_games as (
select s.date as date, s.away as away, s.home as home, s.winner_name, c.period, c.time, c.challenging_name,
s.home = s.winner_name as won, c.date is not NULL as used_challenge
from schedule_winners s left join challenges1 c on s.date = c.date and s.home = c.home_name and s.home = c.challenging_name),

schedule_all_data as (
select * from schedule_away_games
UNION ALL
select * from schedule_home_games)

--select used_challenge, sum(won) * 1.0 / count(*) as home_win_pct, sum(won) as home_wins, count(*) as num_of_games from schedule_home_games group by used_challenge;

select used_challenge, sum(won) * 1.0 / count(*) as away_win_pct, sum(won) as away_wins, count(*) as num_of_games from schedule_away_games group by used_challenge;

select * from schedule_all_data order by date, away, home;