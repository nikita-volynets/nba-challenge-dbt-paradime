with stats_detailed as (

    select * from {{ ref('tfm_team_grouped_stats') }}

)

, teams as (

    select * from {{ ref('stg_teams') }}

)

, final as (

select
    sd.team_id
    , sd.team_name
    , t.city
    , t.state
    , sd.season
    , date_from_parts(left(sd.season, 4), 1, 1) as season_start_on
    , sd.game_type
    , sd.games
    , sd.wins
    , sd.points
    , sd.field_goals_made
    , sd.field_goals_attempted
    , sd.three_point_made
    , sd.three_point_attempted
    , sd.free_throws_made
    , sd.free_throws_attempted
    , sd.rebounds
    , sd.assists
    , sd.steals
    , sd.blocks
    , sd.turnovers
from stats_detailed as sd
left join teams as t
    on sd.team_id = t.team_id
where 1 = 1
    and left(sd.season, 4) > 2019

)

select * from final
