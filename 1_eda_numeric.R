
# skips but goes back?

# how often skip?
#### % listeners vs % song listened to
#### skip rate(%) within in the first 60 seconds of a song


library(tidyverse)
library(here)
library(ggthemes)
library(knitr)
library(kableExtra)

# load data
spotify_eda <- readRDS(here("data/spotify_eda.rds"))

# hour of day
plot_hour <- spotify_eda |> count(hour_of_day, skip_2) |>
  group_by(hour_of_day) |>
  mutate(percent_skip = n / sum(n)) |>
  filter(skip_2 == TRUE) |>
  ggplot(aes(hour_of_day, percent_skip)) +
  geom_line() +
  geom_point(aes(color = "red")) +
  ylim(0, 1) +
  theme_fivethirtyeight() +
  theme(
    legend.title = element_blank(),
    legend.background = element_blank(),
    legend.position = "none",
    plot.title = element_text(size = 12, hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5),
    panel.background = element_blank(),
    plot.background = element_blank()
  ) +
  labs(
    title = "When do people skip the most?",
    subtitle = "Skipping rate is lowest when people are asleep.",
    x = "Hour of Day",
    y = "Percentage of Songs Skipped"
  )

spotify_eda |> count(hour_of_day, skip_2) |>
  group_by(hour_of_day) |>
  mutate(percent_skip = n / sum(n))

# day of week

# date/season

ggsave(here("results/plot_hour.png"), plot_hour)

