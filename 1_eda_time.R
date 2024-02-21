# EDA - time analyses (time of day, day of week, month/season)

library(tidyverse)
library(here)
library(ggthemes)
library(knitr)
library(kableExtra)

# load data
spotify_eda <- readRDS(here("data/spotify_eda.rds"))

# hour of day
hour_data <- spotify_eda |> count(hour_of_day, skip_2) |>
  group_by(hour_of_day) |>
  mutate(percent_skip = n / sum(n)) |>
  filter(skip_2 == TRUE)

plot_hour <- ggplot(hour_data, aes(hour_of_day, percent_skip)) +
  geom_line(color = "white") +
  geom_point(aes(color = "red")) +
  ylim(0, 1) +
  theme_fivethirtyeight() +
  theme(
    legend.title = element_blank(),
    legend.background = element_blank(),
    legend.position = "none",
    legend.text = element_text(color = "white"),
    plot.title = element_text(size = 12, hjust = 0.5, color = "white"),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "white"),
    panel.background = element_blank(),
    plot.background = element_blank(),
    axis.title.x = element_text(size = 10, vjust = 0, color = "white"),
    axis.title.y = element_text(size = 10, color = "white"),
    axis.text = element_text(color = "white")
  ) +
  labs(
    title = "When do people skip the most?",
    subtitle = "Skipping rate is lowest when people are asleep.",
    x = "Hour of Day",
    y = "Percentage of Songs Skipped"
  )

play_data <- spotify_eda |> count(hour_of_day) |>
  arrange(desc(n)) |>
  mutate(percent_plays = n / n[1])

plot_plays <- ggplot(hour_data, aes(hour_of_day, percent_skip)) +
  geom_line(color = "white") +
  geom_point(aes(color = "red")) +
  geom_line(data = play_data, aes(hour_of_day, percent_plays), color = "white") +
  geom_point(data = play_data, aes(hour_of_day, percent_plays, color = "skyblue")) +
  theme_fivethirtyeight() +
  ylim(0, 1) +
  theme(
    legend.title = element_blank(),
    legend.background = element_blank(),
    legend.position = "none",
    legend.text = element_text(color = "white"),
    plot.title = element_text(size = 12, hjust = 0.5, color = "white"),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "white"),
    panel.background = element_blank(),
    plot.background = element_blank(),
    axis.title.x = element_text(size = 10, vjust = 0, color = "white"),
    axis.title.y = element_text(size = 10, color = "white"),
    axis.text = element_text(color = "white")
  ) +
  labs(
    title = "How does skip rate relate to play rate?",
    subtitle = "At night, people play less and skip less. During the day, it's different.",
    x = "Hour of Day",
    y = "Percentage"
  )


# day of week

# date/season

ggsave(here("results/plot_hour.png"), plot_hour)
ggsave(here("results/plot_plays.png"), plot_plays)


