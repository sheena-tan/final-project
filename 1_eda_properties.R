# eda of song properties

# how do the properties of the previous song compare to the current song if the song wasn't skipped
# euclidean distance of the song attributes, normalize by standard deviation
# along each dimension to see what is most influential

# load packages
library(tidyverse)
library(here)
library(ggthemes)
library(doMC)
library(patchwork)
library(kableExtra)

# parallel processing ----
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load data
spotify_eda <- readRDS(here("data/spotify_eda.rds"))


# create subset of songs that weren't skipped and the song before them
subset <- data.frame()

for (session in unique(spotify_eda$session_id)) {
  session_subset <- subset(spotify_eda, session_id == session)

  for (i in 2:nrow(session_subset)) {
    if (!session_subset$skip_2[i]) {
      subset <- rbind(subset, session_subset[(i-1):i, ])
    }
  }
}

subset_properties <- subset |>
  select(session_id, session_position, duration, us_popularity_estimate,
         acousticness, beat_strength, bounciness, danceability, dyn_range_mean,
         energy, instrumentalness, liveness, loudness, speechiness, tempo,
         valence, acoustic_vector_0, acoustic_vector_1, acoustic_vector_2,
         acoustic_vector_3, acoustic_vector_4, acoustic_vector_5,
         acoustic_vector_6, acoustic_vector_7)

# write out subset
save(subset_properties, file = here("data/spotify_skip_subset.rda"))

# calculate euclidean distance for each property

distances <- subset_properties |>
  select(-session_id, -session_position) |>
  mutate(row_num = row_number()) |>
  group_by(group = ceiling(row_num / 2)) |>
  summarise(across(-row_num, ~ if(n() == 2) dist(.))) |>
  rename(pair = group)

save(distances, file = here("data/euclidean_distances.rda"))

# normalize distances
z_score_normalize <- function(x) {
  (x - mean(x)) / sd(x)
}

distances_normalized <- distances |>
  mutate(across(everything(), z_score_normalize)) |>
  mutate(pair = row_number())

save(distances_normalized, file = here("data/euclidean_distances_normalized.rda"))

# summary statistics
summary_stat <- distances |>
  summarise(across(everything(), list(min = min, max = max, median = median, IQR = IQR))) |>
  pivot_longer(
    cols = everything(),
    names_to = c(".value", "stat"),
    names_pattern = "(.*)_(min|max|median|IQR)"
  ) |>
  select(-pair, -starts_with("acoustic_"))

summary_transpose <- data.frame(t(summary_stats[-1]))

colnames(summary_transpose) <- c("min", "max", "median", "IQR")

summary_transpose <- summary_transpose |> arrange(desc(median))

save(summary_transpose, file = here("data/euclidean_distances_summary.rda"))

summary_print <- kable(summary_transpose, format = "html") |>
  kable_styling()

as_image(summary_print, file = here("results/euclidean_distances_summary.png"))

# # boxplot of distances
# plot_boxplots <- function(data, x_1) {
#   p1 <- ggplot(data, aes({{x_1}})) +
#     geom_boxplot() +
#     xlim(-1, 30) +
#     theme_void()
#
#   p2 <- ggplot(data, aes({{x_2}})) +
#     geom_boxplot() +
#     xlim(-1, 30) +
#     theme_minimal() +
#     theme(
#       axis.text.y = element_blank(),
#       axis.ticks.y = element_blank()
#     )
#
#   p1/p2 + plot_layout(heights = unit(c(1, 5), c("cm", "null")))
# }
#
# duration_bp <- plot_boxplots(distances_normalized, duration)
