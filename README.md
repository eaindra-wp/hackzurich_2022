# SUPPLY KNIGHTS

## Summary

We developed a mechanism through which logistics managers can monitor global events that might cause hinderances in their supplies or deliveres. Our project is a dashboard that pin points any relevant locations where some unusual event occurred recently and is likely to have an adverse effect on the supply chain.

For example, if there was a huge electricity breakout in China for two entire nights and it caused trouble in completing foreign orders, it will most likely be in news. Similarly, if there are flood warnings from Pakistan while you were expecting a supply from there, your team will be notified timely so that you can take any necessary measures. Our program will scan through news on a daily basis and mark places with disturbances with an “X” marker. 

When a user clicks on an “X” mark, a modal opens that gives more details regarding the potential threat, including the link to a relevant news article. The criteria regarding whether something should be marked or not can be modified for example using the sentiment score.

## Data

### GDELT

Apart from the Migros provided data, we used the public GDELT data source. GDELT monitors print, broadcast, and web news media in over 100 languages from across every country in the world to keep continually updated on breaking developments anywhere on the planet. 

The GDELT Event Database records over 300 categories of physical activities around the world, from riots and protests to peace appeals and diplomatic exchanges, georeferenced to the city or mountaintop, across the entire planet dating back to January 1, 1979 and updated every 15 minutes.

Our program uses the GDELT data to locate disturbances across the globe on the basis of different news mediums.

### Genomes

We used OpenDataSoft’s 
Geonames - All Cities with a population > 1000 dataset to match different articles with their respective cities or countries and geographical coordinates. The performance of this process can be improved by opting for a better, paid dataset.  


### Sentiment Analysis

Google’s Natural Language API allows users to scan texts and obtain a sentiment and magnitude score accordingly. In our use case, the API is used to derive scores for different news articles.

score: sentiment score values lie in the range of -1 (negative) to 1 (positive) and reflect the overall emotion of the news. 
﻿
magnitude: magnitude indicates the overall strength of emotion (both positive and negative) within the given text, between 0.0 and +inf.

For our current dashboard, we classify incidents with a score lower than -0.1 as potential risks. Hence, we mark them all on our map. This can be modified.

On our dashboard, we also show a “Threat Level” which is derived by simply rounding the magnitude value for now. The logic for this could be further improved. 

### Migros Data Analysis
From Migros, we received datasets which keep track of shipment routes, timeframes and locations of the departures and arrivals of containers around the globe. 

Firstly, we filtered the names of the cities which are considered as risk areas according to the negative scores we received from the Sentiment Analysis, to check any orders/shipments which would go through those risk areas. Afterward, we retrieved the mandatory information, such as the estimated and actual datetimes, location names the departure and arrival cities of each container from different datasests of Migros. In this way, we detected the number of days the shipment was delayed to reach the final destination, which is considered as a risk area.  


## Tech Stack

### Database

To interact with the database and link it to our front-end, we used SQL and Google BigQuery.

### Front-end

Retool, JavaScript

### Maps

We used Google Maps Direction API, Geocoding API, and JavaScript to obtain coordinates to draw points and route lines.

https://cloud.google.com/natural-language/docs/basics#sentiment_analysis

## Challenges we ran into
Some SQL related function names on BigQuery are different from other SQLs such as PostgreSQL. Thanks to this challenge, we also learned different syntaxes for BigQuery. 


## What we learned
While working on this challenge, we got an opportunity to write SQL queries on Google BigQuery more efficiently to combine and retrieve values from the datasets. Additionally, we explored more on Google Maps Direction API, Geocoding API, ReTool, and NLP while retrieving potential city names for successful shipments in the future.

## Further Development

For now, we have only displayed one route for demenstoration purposes. This can be modified such that the user can enter their diseried.

## References

https://blog.gdeltproject.org/announcing-the-global-entity-graph-geg-and-a-new-11-billion-entity-dataset/

https://developers.google.com/maps/documentation/directions/overview

https://cloud.google.com/bigquery/docs

### Google Clouds Credentials
Project ID: hackzurich22-4070
Project Number: 451917323108
