with games as (

    select * from {{ ref('stg_games') }}

)

, final as (
    
select
    team_id
    -- , season_id
    -- , team_abbreviation
    , team_name
    , season
    , game_type
    , game_id
    , game_date
    -- matchup,
    , case
        when wl = 'W' then 1
        else 0
    end as is_win
    -- , game_duration_mins
    , points
    , field_goals_made
    , field_goals_attempted
    -- , field_goal_pct
    , three_point_made
    , three_point_attempted
    -- , three_point_pct
    , free_throws_made
    , free_throws_attempted
        -- , free_throw_pct,
        -- , offensive_rebounds
        -- , defensive_rebounds
    , total_rebounds as rebounds
    , assists
    , steals
    , blocks
    , turnovers
    , personal_fouls
    -- , plus_minus
from games
where 1 = 1
    and team_name = 'Toronto Raptors'

)


select * from final