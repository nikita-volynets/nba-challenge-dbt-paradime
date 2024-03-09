# DBT Challenge: NBA Edition

## Table of Contents

1. [Introduction](#introduction)
2. [Tools Used](#tools-used)
3. [DBT project architecture](#dbt-project-architecture)
    - [Layers](#layers)
    - [Exposures](#exposures)
    - [Tests](#tests)
    - [Documentation](#documentation)
    - [Seeds](#seeds)
    - [Linting](#linting)
    - [Jobs](#jobs)
4. [Analysis for General Manager](#analysis-for-general-manager)
    - [Objective](#objective)
    - [DBT Models](#dbt-models)
    - [Data Analysis](#data-analysis)
    - [Dashboard](#dashboard)
    - [Findings](#findings)
5. [Analysis for NBA fans](#analysis-for-nba-fans)
    - [Objective](#objective-2)
    - [DBT Models](#dbt-models-2)
    - [Data Analysis](#data-analysis-2)
    - [Findings](#findings-2)
6. [Conclusions](#conclusions)

## **Introduction**

This project was created for the *dbt™ data modeling challenge - NBA Edition*, Hosted by [Paradime](https://www.paradime.io/)! The main goal of the project was to generate insights from raw NBA datasets by utilizing Modern Data Stack.

## Tools Used

- [Paradime](https://www.paradime.io/) for dbt project
- [Snowflake](https://www.snowflake.com/en/) for data storage and computing
- [Hex](https://hex.tech/) for data analysis and ad-hoc visualisations
- [Sigma](https://www.sigmacomputing.com/) for dashboard creation

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/f7f30961-1b77-44d2-b064-15c78e977070)


## DBT project architecture

### Layers

The project consists of 3 layers:

**1. Sources:** These tables are the starting point. Small adjustments are made, such as changing the names of columns, but not much else.

**2. Transform:** In this step, the data from the "Sources" goes through more complex changes. It includes combining tables, performing calculations, and organizing the data. It is divided into two parts:
- Raptors: This section focuses on data specifically about the Toronto Raptors team.
- Teams: This section deals with data about all teams.

**3. Marts:** These tables are the finished product, ready for people to use. They come in two sub-folders:
- Business: Aimed at professionals who need to analyze data or make visualizations and dashboards, like business stakeholders or data analysts.
- Fans: Designed for NBA fans who want to explore and analyze the data for fun.
    
![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/8c4cef22-db7b-4194-9a97-51f9726d71ef)


### **Exposures**

Exposures were created in the `dashboards_analysis.yml` file in models folder to define and describe a downstream use of the dbt project, such as in a dashboard and data analysis.

Example of a Sigma Dashboard exposure that was used in this project:

```yaml
version: 2

exposures:
  - name: Team_Performance_Dashboard
    type: dashboard
    maturity: low
    url: https://app.sigmacomputing.com/paradime-io-nba/workbook/workbook-3UFg1EvbT5BriHVxB7cdI1?:link_source=share
    description: NBA Teams Performance Dashboard about key metrics of NBA teams by season
    depends_on:
    - ref('m_team_performance_by_season')
    owner:
      name: Nikita Volynets
      email: nikita.volynets@gmail.com
```

### Tests

To maintain good data quality in dbt various generic tests were implemented for models in yml files.

Example:

```yaml
version: 2

models:
  - name: tfm_team_spendings
    description: "This model aggregates financial information from the 'stg_team_spend_by_season' source table, detailing team payroll, active payroll, luxury tax space, and calculates total spending by adding team payroll and luxury tax bill for each team per season."
    tests:
      - unique:
          column_name: "team_id || '-' || season"
    columns:
      - name: team_id
        description: '{{ doc("team_id") }}'
        tests:
          - not_null:
              config:
                severity: warn
```

In this example, two tests were done on the `tfm_team_spendings model`. The first test makes sure that each `team_id` and `season` combination is unique. The second check makes sure that the `team_id` column doesn't have any missing values. Also, we set a warning severity level for the team_id column, meaning if there's a missing value, the model won't stop running; it will just give a warning message.

### Documentation

To make it easier for other engineers to understand the models, documentation was written. For each model, a yml file was created that describes the table and its columns. Also, for columns that appear often, a `doc.md` file was made. This file includes descriptions of the most commonly used columns:

`docs.md`:

```markdown
{% docs team_name %}

"Full name of the team, including the city and team name."

{% enddocs %}

{% docs season %}

"NBA season for which the financial data is reported."

{% enddocs %}

{% docs team_id %}

"Unique identifier for the team."

{% enddocs %}
```

How it was used in models' descriptions:

```yaml
version: 2

models:
  - name: tfm_team_spendings
    description: "This model aggregates financial information from the 'stg_team_spend_by_season' source table, detailing team payroll, active payroll, luxury tax space, and calculates total spending by adding team payroll and luxury tax bill for each team per season."
    tests:
      - unique:
          column_name: "team_id || '-' || season"
    columns:
      - name: team_id
        description: '{{ doc("team_id") }}'
      - name: team_name
        description: '{{ doc("team_name") }}'
      - name: season
        description: '{{ doc("season") }}'
```

### Seeds

To enhance the analysis for the NBA fans, a file `seed_full_moon_dates.csv` was included in the seeds folder of the dbt project. This seed file is in CSV format that can be loaded into Snowflake with the `dbt seed` command.

This seed file can be incorporated into other models similarly to how models reference each other, by utilizing the `ref` function.

An illustration of how a seed file is applied can be seen in the `m_fullmoon_raptors_games model`:

```yaml
, full_moon_dates as (

    select *
    from {{ ref('seed_full_moon_dates') }}
```

### Linting

To ensure the code looks clean and follows style guidelines, a tool called **SQLfluff** linter was set up in the dbt project, using configurations in a `.sqlfluff` file. This tool helps to automatically spot and correct styling and formatting mistakes either in one specific model or across all models. On paradime.io, using this tool is very simple — just by clicking the 'Prettier' button in the code editor.

Here's an example of some rules used to configure the linter in the project:

```yaml
[sqlfluff]

dialect = snowflake
templater = dbt

[sqlfluff:templater:dbt]
project_dir = ./

[sqlfluff:rules:aliasing.table]
aliasing = explicit

[sqlfluff:rules:capitalisation.keywords]
capitalisation_policy = lower

[sqlfluff:layout:type:comma]
line_position = leadin
```

### Jobs

To ensure the dbt project runs every day, a job was set up to follow a daily routine using Bolt UI, which is a job scheduler found on Paradime:

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/9640579e-1412-4679-a501-5180ac440817)


## Analysis for General Manager

In this section analysis was conducted for General Manager of Toronto Raptors NBA team.

### Objective

General Managers have two main goals:

1. Ensure the team performs well.
2. Make a profit, or at least avoid losing money.

The following analysis will be concentrated on the first goal.

To meet this goal, General Managers and their support teams should follow these steps:

**Step 1: Evaluate Team Performance**

- The team's performance will be analyzed by examining key statistics such as win percentage and average points per game, followed by a comparison with other teams to identify any weaknesses. For instance, the average performance of the Toronto Raptors over the last three seasons will be scrutinized and compared with the top 10 teams.

**Step 2: Keep an Eye on Key Metrics**

- To remain informed about the team's progress, a Team Performance Dashboard will be established in Sigma. This setup will facilitate regular monitoring of critical metrics.

### **DBT Models**

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/c8a5acd4-e936-43d7-8471-e06bb48aa85b)

To prepare the final analysis model, two source models were used:

- **stg_games**: This includes key performance metrics for all NBA teams.
- **stg_team_spend_by_seasons**: Spending data by NBA team

In the transform layer, the following models were created:

- **tfm_raptors_games**: This model aggregates and filters data specifically for the Toronto Raptors.
- **tfm_team_spendings**: This model aggregates and filters data on team spending.
- **tfm_raptors_3y_avg_metrics**: It calculates the average metrics for the Toronto Raptors over the last three full seasons.
- **tfm_team_top_10_3y_avg_metrics**: This model finds the average metrics for the top 10 teams over the last three seasons, selecting teams with the highest average win rate.

In the marts layer:

- **m_raptors_vs_top_10_comparison**: This combines the metrics of the Raptors and the top 10 teams for comparison.

For Team Performance Dashboard **m_team_performance_by_season** model was created:

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/01c8a5f1-8459-458b-b145-9bd1f9ec5b40)


### Data analysis

**Step 1: Evaluate Team Performance**

[Link to the Hex App](https://app.hex.tech/9fbdd66e-c23f-44d7-9431-ec421afdbe0a/app/4de47f4c-016b-4678-a0fd-5dd7b42df9df/latest)

To get a clear picture, all the metrics were averaged over the last three full NBA seasons: 2020/21, 2021/22, and 2022/23.

First, win rate will be used as a measure of success to track team performance and compare it with that of the Toronto Raptors.

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/eb640b09-2814-4a52-9bcd-d87b08343fe8)

The chart shows that Toronto has a win rate of 49%, which isn't bad, but it's still lower than most other teams.

Next, the total spendings by NBA teams will be analyzed:

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/a7d62a0b-dd88-4ec4-a080-ea9bb1b0aa91)


The chart reveals that the Toronto Raptors have a budget of $137 million, placing them in the middle compared to other teams. This is only $10 million (about 7%) less than the team ranked 10th. This suggests that with effective management, Toronto could break into the top 10.

Next, a comparison of the Toronto Raptors' performance metrics with those of the top-10 teams will be conducted.

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/dd9e8b9f-3254-4e8a-892f-6b280957911c)

The table highlights four main improvement areas for the Toronto Raptors to potentially rank among the top-10 teams:

- Turnovers per game are 11.6% lower compared to the top-10.
- Assists per game are 9.6% lower.
- Field goal percentage is 5.2% lower.
- Three-point shooting percentage needs improvement.

However, steals per game are 18.3% higher compared to the top-10 teams, indicating a strong point.

### Dashboard

**Step 2: Keep an Eye on Key Metrics**

In the previous step, important metrics were reviewed and areas needing improvement were identified. A Team Performance Dashboard was then set up for the General Manager to keep track of these metrics.

**[Link to the Dashboard](https://app.sigmacomputing.com/paradime-io-nba/workbook/workbook-3UFg1EvbT5BriHVxB7cdI1?:link_source=share)**

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/83a9d4ba-12c6-4de4-9461-4f477f42a4c3)


**Filters:** Users can select a particular team, season, whether it's a Regular game or Playoffs, and the City and State.

**KPIs:** The metrics shown are for the team selected in the 'Choose team for KPIs' filter. For example, metrics for the Toronto Raptors are displayed. There's also a comparison with previous seasons; red numbers show a decrease in specific metrics, while green numbers indicate an increase.

Small descriptions are provided for some metrics to help explain them better.

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/48b6b93b-acda-4830-ac3d-e60390387949)


**Table:**

The table display information about all teams' metrics, sorted by win rate. This Dashboard was specially designed for the General Manager of the Toronto Raptors, which is why this team is highlighted.

**Analysis:**

Forty-six games have been played, and Toronto's performance has been poor. The team ranks 25th out of 30 in terms of win rate, with a win rate 15% lower than the previous season.

Key metrics that have declined from the previous season include Free Throw percentage by 4%, a significant decrease in Steals per Game by 2.0, and a slight decrease in Blocks per Game by 0.3.

When these metrics are compared with those of the top teams, Toronto is underperforming in almost every metric except for Assists per Game. The main areas that need improvement are the percentage of Three Points, Free Throw percentage, and Blocks per Game.

### Findings

- Toronto Raptors' key areas for improvement: turnovers, assists, field goal percentage, and three-point shooting.
- The team's steals per game are higher than the top-10 teams, marking a strength.
- Currently, Toronto ranks 25th out of 30 teams with a win rate 15% lower than the previous season.
- Performance has declined in free throw percentage, steals per game, and blocks per game from the previous season.
- Main improvement targets: three-point shooting, free throw percentage, and blocks per game.

## Analysis for NBA fans

In this section analysis was conducted for fans of Toronto Raptors NBA team.

This analysis for conducted just for fun. 

<a id="objective-2"></a>
### Objective

The objective is to analyze Toronto Raptors games on the full moon dates and identify interesting patterns in data.

<a id="dbt-models-2"></a>
### DBT Models

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/1103a615-0624-4529-9286-1a64d0b9a3f7)


To create the final analysis model called **`m_fullmoon_raptors_games`**, two main components were used:

- A transform model named **`tfm_raptors_games`** that contains details about all the Raptors games.
- A CSV file named **`seed_full_moon_dates`** which lists all the dates of full moons between 2009 and 2030

<a id="data-analysis-2"></a>
### Data analysis

[Link to the Hex App](https://app.hex.tech/9fbdd66e-c23f-44d7-9431-ec421afdbe0a/app/f7273ecc-1470-442c-9f4d-7f5b5553a7a9/latest)

1. **How many Toronto Raptors games were played on the full moon dates during Regular season?**

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/704c7eb2-1269-4985-a181-a15313db45d4)

From 2009 to 2023 were played 37 games on the full moon games, on average 2.5 games per year.

2. **Toronto Raptors won or lost most of the games in full moon dates during Regular Season?**

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/30536c7f-8a0b-4f08-b6c6-af3a320458d6)

Toronto won 18 games and lost 22. However, it's clear that most of the losses happened before 2017, and they achieved more wins after 2017.

3. **What about Playoff games on full moon dates?**

![image](https://github.com/nikita-volynets/paradime-dbt-nba-challenge/assets/22579201/0a6216d4-2215-4100-a7bb-d132c8df88db)

The Toronto Raptors played only three games on full moon dates, winning two and losing one. Because there is so little data, it's not possible to use this information to predict their playoff performance.

<a id="findings-2"></a>
### Findings

The analysis showed one clear trend: before 2017, Toronto had more losses than after 2017. Despite this pattern, fans should not use it as a basis for betting strategies, as all other factors examined showed no correlation with full moon dates.

## Conclusions

This project uses modern data tools to extract insights from NBA data. It aims to meet three main criteria: 

**1. Value of findings:**
- The General Manager of the Toronto Raptors gained a clear understanding of the team's weak points and what needs improvement. Additionally, a Dashboard was provided for easy access to key metrics, serving as a reliable source for truth.
- Fans received an enjoyable analysis. While the findings may not have practical use, they discovered some fun facts about their team.

**2. Complexity**
- The dbt project includes three layers of models. Models in the transform and marts layers use joins, unions, window functions, and calculations.
- Exposures were set up to show the connections between models, Dashboard and data analysis notebooks.
- A seed file was included for use in the analysis interesting to NBA fans.

**3. Quality**
- Linter was used to make sure the dbt data models have high-quality code and formatting.
- Documentation for all data models was provided, helping new team members quickly get up to speed with the project.
- Sigma was utilized to develop a Team Performance Dashboard.
- Hex notebooks were employed for data analysis and creating visualizations.


Additionally, the project made use of these features from Paradime.io:

- Lineage, to view the flow and connections of models.
- Catalog, for observing the project and datasets.
- Bolt UI, to set up a job that runs every day.

