with source as (
    select *
    from
        {{ source('NBA', 'PLAYER_SALARIES_BY_SEASON') }}
)


, renamed as (
    select
        player_id
        , player_name
        , salary
        , rank
        , season
    from
        source
)

select *
from
    renamed
