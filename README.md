## Introduction

Spotify, an online music streaming platform with over 190 million active users and over 40 million tracks, faces a key challenge: how do you recommend the right music to right user? Out of a robust body of literature on recommendation systems, little work describes how users sequentially interact with recommended content. This gap is particularly evident in the music domain, where understanding when and why users skip tracks serves as crucial implicit feedback. The [Music Streaming Sessions Dataset](https://www.aicrowd.com/challenges/spotify-sequential-skip-prediction-challenge) was released by Spotify in 2018 to encourage research on this overlooked aspect of streaming. 

This project hopes to begin to provide an elementary solution to Spotify's challenge: **Predict whether individual tracks encountered in a listening session will be skipped by a particular user.** 

The prediction output is a binary variable indicating if the track was skipped (`1`) or not skipped (`0`). The data set provides information about each user's listening session, including metadata and acoustic descriptors for all tracks encountered. This project uses the `skip_2` field of the session logs as ground truth/the target variable as the original challenge does. 

## Data Overview

Given laptop constraints, this project uses the miniature version of the [Music Streaming Sessions Dataset](https://www.aicrowd.com/challenges/spotify-sequential-skip-prediction-challenge), which is a minimally sized version of the original training set and track features provided by Spotify for challenge users to familiarize themselves with the data set. For more information on the data used, please refer to the `README.me` in the `\data` folder.

## Repository Setup

Project memos can be found in the "\memos" subdirectory.

Data can be found in the "\data" subdirectory.

Script `0_initial_setup.R` contains data quality checks and data splitting.
Script `1_eda.R` contains an initial data exploration.
