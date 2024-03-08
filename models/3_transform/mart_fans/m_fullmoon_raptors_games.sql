with games as (
    select *
    from
        {{ ref('tfm_raptors_games') }}
)

, full_moon_dates as (

    select *
    from {{ ref('seed_full_moon_dates') }}

)

, final as (

select
    team_id
    , team_name
    , season
    , game_type
    , game_id
    , game_date
    , is_win
    , points
    , field_goals_made
    , field_goals_attempted
    , three_point_made
    , three_point_attempted
    , free_throws_made
    , free_throws_attempted
    , rebounds
    , assists
    , steals
    , blocks
    , turnovers
    , personal_fouls
from games as g
inner join full_moon_dates as m
    on g.game_date = m.full_moon_date

)

select * from final
