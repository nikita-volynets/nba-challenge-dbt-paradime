with stats as (

    select * from {{ ref('stg_team_stats_by_season') }}

)

, teams as (

    select * from {{ ref('stg_teams') }}

)

, final as (

select
    st.team_id
    -- s.team_city,
    , st.team_name
    , t.city as team_city
    , t.state as team_state
    , st.season
    , st.games_played
    , st.points
    , st.wins
    -- st.losses,
    , st.conference_rank
    , st.division_rank
    -- st.playoff_wins,
    -- st.playoff_losses,
    -- st.nba_finals_appearance,
    , st.field_goals_made
    , st.field_goals_attempted
    , st.three_pointers_made
    , st.three_pointers_attempted
    -- st.free_throws_made,
    -- st.free_throws_attempted,
    -- st.offensive_rebounds,
    -- st.defensive_rebounds,
    , st.total_rebounds
    , st.assists
    -- st.personal_fouls,
    , st.steals
    , st.turnovers
    , st.blocks
from stats as st
left join teams as t
    on st.team_id = t.team_id

)

select * from final
