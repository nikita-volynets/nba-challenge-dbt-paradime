with games as (

    select * from {{ ref('tfm_raptors_games') }}

)

, spendings as (


    select * from {{ ref('tfm_team_spendings') }}

)

, final as (
select
    g.team_name
    , sum(g.is_win)/count(g.game_id) as win_rate
    , sum(g.points)/count(g.game_id) as points_per_game
    , sum(g.field_goals_made)/sum(g.field_goals_attempted) as pct_field_goals
    , sum(g.three_point_made)/sum(g.three_point_attempted) as pct_three_point
    , sum(g.free_throws_made)/sum(g.free_throws_attempted) as pct_throws_attempted
    , sum(g.rebounds)/count(g.game_id) as rebounds_per_game
    , sum(g.assists)/count(g.game_id) as assists_per_game
    , sum(g.steals)/count(g.game_id) as steals_per_game
    , sum(g.blocks)/count(g.game_id) as blocks_per_game
    , avg(sp.total_spending) as avg_spending
from games as g
left join spendings as sp
    on g.team_name = sp.team_name
    and g.season = sp.season
where 1 = 1
    and left(g.season, 4) in (2020,2021,2022)
    and g.game_type = 'Regular Season'
group by g.team_name

)

select * from final