library(tidyverse)
library(DBI)
library(RPostgreSQL)

con <- DBI::dbConnect(RPostgreSQL::PostgreSQL(), 
                      dbname="x",
                      host = "x",
                      port = "x",
                      user = "x",
                      password = "x"
)

data <- read_csv("https://opendata.ecdc.europa.eu/covid19/nationalcasedeath/csv")

data <- data %>%
  select(country_code, year_week, indicator, weekly_count) %>%
  drop_na(country_code)%>%
  pivot_wider(values_from = weekly_count, names_from = indicator)%>%
  separate(year_week, into = c("date_year", "date_week"), sep="-")%>%
  rename(iso_a3 = country_code,
         ecdc_covid_country_weekly_cases = cases,
         ecdc_covid_country_weekly_deaths = deaths)

data <- data%>%
  mutate(date_year = as.numeric(date_year),
         date_week = as.numeric(date_week),
         ecdc_covid_country_weekly_cases = as.numeric(ecdc_covid_country_weekly_cases),
         ecdc_covid_country_weekly_deaths = as.numeric(ecdc_covid_country_weekly_deaths))

dbWriteTable(con, "ecdc_covid_country_weekly", data , row.names = FALSE, overwrite = TRUE)
