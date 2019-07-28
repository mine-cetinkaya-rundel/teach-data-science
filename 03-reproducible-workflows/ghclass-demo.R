# load packages ----------------------------------------------------------------

library(devtools)
#install_github("rundel/ghclass")
library(ghclass)
library(tidyverse)

# clean up ---------------------------------------------------------------------

# repo_delete(org_repos("ghclass-demo"))

# load roster data -------------------------------------------------------------

roster <- read_csv("03-reproducible-workflows/Teaching Data Science - GitHub names (Responses) - Form Responses 1.csv")

names(roster) <- c("timestamp", "email", "name", "ghname")

# invite users -----------------------------------------------------------------

org_invite(org = "jsm19-tds-demo", user = roster$ghname)

# create individual assignment -------------------------------------------------

org_create_assignment(org = "jsm19-tds-demo", 
                      repo = paste0("hw-01-", roster$ghname), 
                      user = roster$ghname, 
                      source_repo = "jsm19-tds-demo/hw-01")

# create teams -----------------------------------------------------------------

team_names <- c("team1", "team2", "team3", "team4", "team5")

roster <- roster %>%
  mutate(team = sample(team_names, nrow(roster)))

team_create(org = "jsm19-tds-demo",
            team = unique(roster$team))

team_invite(org = "jsm19-tds-demo",
            user = roster$ghname,
            team = roster$team)

# create team assignment -------------------------------------------------

org_create_assignment(org = "jsm19-tds-demo", 
                      repo = paste0("hw-02-", roster$team), 
                      user = roster$ghname, 
                      team = roster$team,
                      source_repo = "jsm19-tds-demo/hw-02")

# collect assignments ----------------------------------------------------------

hw01_repos <- org_repos(org = "jsm19-tds-demo", filter = "hw-01-")

local_repo_clone(repo = hw01_repos, 
                 local_path = "hw-01-collect")

# styling ----------------------------------------------------------------------

repo_style(repo = "jsm19-tds-demo/hw-01-minebotmine", 
           files = "*.Rmd", draft = TRUE)

