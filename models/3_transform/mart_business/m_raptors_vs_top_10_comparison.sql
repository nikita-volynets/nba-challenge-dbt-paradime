with raptors as (

    select * from {{ ref('tfm_raptors_3y_avg_metrics') }}

)

, top_10 as (

    select * from {{ ref('tfm_team_top_10_3y_avg_metrics') }}

)

, final as (

    select * from raptors
    union
    select * from top_10

)

select * from final