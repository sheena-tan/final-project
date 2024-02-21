# Exploratory Data Analysis
# inspect target variable + other questions of interest

# load packages
library(tidyverse)
library(patchwork)
library(here)
library(ggthemes)

# load data
spotify_eda <- readRDS(here("data/spotify_eda.rds"))

# inspect target variable ----

# factor variables
plot_stacked_bar <- function(data, x_variable, fill_variable) {
  ggplot(data, aes({{x_variable}}, fill = {{fill_variable}})) +
    geom_bar(position = "fill") +
    scale_x_discrete(labels = c("Not Skipped", "Skipped")) +
    theme_fivethirtyeight() +
    theme(
      axis.title.y = element_blank(),
      axis.title.x = element_blank(),
      legend.title = element_blank(),
      legend.background = element_blank(),
      legend.position = "bottom",
      plot.title = element_text(size = 12, hjust = 0.5),
      plot.subtitle = element_text(size = 10, hjust = 0.5),
      panel.background = element_blank(),
      plot.background = element_blank()
    )
}

stacked_context <- spotify_eda |> plot_stacked_bar(skip_2, context_type) +
  labs(
    title = "Playlist context does not seem to affect skip behavior.",
    subtitle = "e.g., personalized playlists, radio, editorial playlists"
  )


stacked_start <- spotify_eda |> plot_stacked_bar(skip_2, hist_user_behavior_reason_start) +
  labs(
    title = "The way the song starts affects skip behavior.",
    subtitle = "e.g., previous song finishing, skipping previous song"
  ) +
  annotate(
    "text", x = 2, y = 0.5,
    label = "Songs are more\nlikely to be skipped\nif they were\nskipped to!",
    color = "white",
    fontface = "bold"
  ) +
  annotate(
    "text", x = 1, y = 0.3,
    label = "Songs are less\nlikely to be skipped\nif the song before\nthem wasn't!",
    color = "white",
    fontface = "bold"
  )

stacked_key <- spotify_eda |> plot_stacked_bar(skip_2, key) +
  labs(title = "Key")

stacked_mode <- spotify_eda |> plot_stacked_bar(skip_2, mode) +
  labs(title = "Mode")

stacked_time_signature <- spotify_eda |> plot_stacked_bar(skip_2, time_signature) +
  labs(title = "Key Signature")

ggsave(here("results/stacked_context.png"), stacked_context)
ggsave(here("results/stacked_start.png"), stacked_start)
ggsave(here("results/stacked_key.png"), stacked_key)
ggsave(here("results/stacked_mode.png"), stacked_mode)
ggsave(here("results/stacked_time_signature.png"), stacked_time_signature)


# skips but goes back?

# how often skip?
#### % listeners vs % song listened to
#### skip rate(%) within in the first 60 seconds of a song

# who skips?
#### premium or not?
#### user playlist, editorial, radio, personal playlist...?

# when skip?
#### hour of the day?
#### day of week?
#### date/season?

# album art?
