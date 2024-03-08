with spendings as (

    select * from {{ ref('stg_team_spend_by_season') }}

)

, final as (

select
    sp.team_id
    -- sp.team_city,
    -- sp.team_name as short_team_name
    , sp.full_name as team_name
    , sp.season
    , sp.team_payroll
    , sp.active_payroll
    , sp.luxury_tax_space
    -- sp.dead_payroll,
    -- sp.luxury_tax_payroll,
    , sp.team_payroll + sp.luxury_tax_bill as total_spending
    -- sp.luxury_tax_bill
from spendings as sp

)

select * from final