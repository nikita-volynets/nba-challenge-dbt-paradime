with games as (

    select * from {{ ref('stg_games') }}

)

, spendings as (


    select * from {{ ref('tfm_team_spendings') }}

)


, team_stats as (

select
    g.team_name
    , count(g.game_id) as games
    , sum(iff(wl='W',1,0)) as wins
    , sum(iff(wl='W',1,0))/count(g.game_id) as win_rate
    , sum(g.points) as points
    , sum(g.field_goals_made) as field_goals_made
    , sum(g.field_goals_attempted) as field_goals_attempted
    , sum(g.three_point_made) as three_point_made
    , sum(g.three_point_attempted) as three_point_attempted
    , sum(g.free_throws_made) as free_throws_made
    , sum(g.free_throws_attempted) as free_throws_attempted
    , sum(g.total_rebounds) as rebounds
    , sum(g.assists) as assists
    , sum(g.steals) as steals
    , sum(g.blocks) as blocks
    , avg(sp.total_spending) as total_spending
from games as g
left join spendings as sp
    on g.team_name = sp.team_name
    and g.season = sp.season
where 1 = 1
    and left(g.season, 4) in (2020,2021,2022)
    and g.game_type = 'Regular Season'
group by g.team_name
order by win_rate desc
limit 10

)

, team_metrics as (

select
    ts.team_name
    , sum(ts.wins)/sum(ts.games) as win_rate
    , sum(ts.points)/sum(ts.games) as points_per_game
    , sum(ts.field_goals_made)/sum(ts.field_goals_attempted) as pct_field_goals
    , sum(ts.three_point_made)/sum(ts.three_point_attempted) as pct_three_point
    , sum(ts.free_throws_made)/sum(ts.free_throws_attempted) as pct_throws_attempted
    , sum(ts.rebounds)/sum(ts.games) as rebounds_per_game
    , sum(ts.assists)/sum(ts.games) as assists_per_game
    , sum(ts.steals)/sum(ts.games) as steals_per_game
    , sum(ts.blocks)/sum(ts.games) as blocks_per_game
    , avg(ts.total_spending) as avg_spending
from team_stats as ts
group by ts.team_name

)

select * from team_metrics