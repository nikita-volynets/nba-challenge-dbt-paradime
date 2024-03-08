with games as (

    select * from {{ ref('stg_games') }}

)

, final as (

select
    team_id
    -- season_id,
    -- team_abbreviation,
    , team_name
    , season
    , game_type
    , count(game_id) as games
    -- game_date,
    -- matchup,
    , sum(case
        when wl = 'W' then 1
        else 0
    end) as wins
    -- game_duration_mins,
    , sum(points) as points
    , sum(field_goals_made) as field_goals_made
    , sum(field_goals_attempted) as field_goals_attempted
    -- field_goal_pct,
    , sum(three_point_made) as three_point_made
    , sum(three_point_attempted) as three_point_attempted
    -- three_point_pct,
    , sum(free_throws_made) as free_throws_made
    , sum(free_throws_attempted)
        as free_throws_attempted
        -- free_throw_pct,
        -- offensive_rebounds,
        -- defensive_rebounds,
    , sum(total_rebounds) as rebounds
    , sum(assists) as assists
    , sum(steals) as steals
    , sum(blocks) as blocks
    , sum(turnovers) as turnovers
    , sum(personal_fouls) as personal_fouls
    -- plus_minus
from games
group by team_id, team_name, season, game_type

)

select * from final