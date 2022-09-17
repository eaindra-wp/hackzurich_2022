# SUPPLY KNIGHTS

Demo: https://ukuphepha.retool.com/embedded/public/37221284-4f26-4121-8d31-4554990cbd5c

## Summary

We developed a mechanism through which logistics managers can monitor global events that might cause hinderances in their supplies or deliveres. Our project is a dashboard that pin points any relevant locations where some unusual event occurred recently and is likely to have an adverse effect on the supply chain.

For example, if there was a huge electricity breakout in China for two entire nights and it caused trouble in completing foreign orders, it will most likely be in news. Similarly, if there are flood warnings from Pakistan while you were expecting a supply from there, your team will be notified timely so that you can take any necessary measures. Our program will scan through news on a daily basis and mark places with disturbances with an “X” marker. 

When a user clicks on an “X” mark, a modal opens that gives more details regarding the potential threat, including the link to a relevant news article. The criteria regarding whether something should be marked or not can be modified for example using the sentiment score.

## Data

### GDELT

Apart from the Migros provided data, we used the public GDELT data source. GDELT monitors print, broadcast, and web news media in over 100 languages from across every country in the world to keep continually updated on breaking developments anywhere on the planet. 

The GDELT Event Database records over 300 categories of physical activities around the world, from riots and protests to peace appeals and diplomatic exchanges across the entire planet dating back to January 1, 1979 and updated every 15 minutes.

Our program uses the GDELT (Global Entity Graph) data to locate disturbances across the globe on the basis of different news mediums.

### Genomes

We used OpenDataSoft’s 
Geonames - All Cities with a population > 1000 dataset to match different articles with their respective cities or countries and geographical coordinates. The performance of this process can be improved by opting for a better, paid dataset.  

https://public.opendatasoft.com/explore/dataset/geonames-all-cities-with-a-population-1000/table/?disjunctive.cou_name_en&sort=name&q=tullow

### Sentiment Analysis

Google’s Natural Language API allows users to scan texts and obtain a sentiment and magnitude score accordingly. In our use case, the API is used to derive scores for different news articles.

* score: sentiment score values lie in the range of -1 (negative) to 1 (positive) and reflect the overall emotion of the news. 

* magnitude: magnitude indicates the overall strength of emotion (both positive and negative) within the given text, between 0.0 and +inf.

For our current dashboard, we classify incidents with a score lower than -0.1 as potential risks. Hence, we mark them all on our map. This can be modified.

On our dashboard, we also show a “Threat Level” which is derived by simply rounding the magnitude value for now. The logic for this could be further improved. 

### Migros Data Analysis

The second part of our dashboard focuses on the datasets we received from Migros. These datasets keep track of shipment routes, timeframes, and locations of the departures and arrivals of containers around the globe. 

Firstly, we filtered the names of the cities which are considered as risk areas according to the negative scores we received from the Sentiment Analysis, to check any orders/shipments which would go through those risk areas. <br/>
Afterward, we retrieved the mandatory information, such as the estimated and actual datetimes, location names the departure and arrival cities of each container from different datasests of Migros. <br/>
In this way, we detected the number of days the shipment was delayed to reach the final destination, which is considered as a risk area.  

This data is presented as as a table for moderators to view and analyze. 


## Tech Stack

### Database

To interact with the database and link it to our front-end, we used SQL and Google BigQuery.

### Front-end

Retool, JavaScript

### Maps

We used Google Maps Direction API, Geocoding API, and JavaScript to obtain coordinates to draw points and route lines.

https://cloud.google.com/natural-language/docs/basics#sentiment_analysis

### File Directory
Below is a short summary of the folders in this repository.
* [geonames_datasets](./geonames_datasets) --> this includes the dataset for location name and geography mapping
* [javascript](./javascript) --> this includes JS files required for mappings
  * for the directions to GEO and coordinate extractions of the selected locations
* [sql](./sql) --> this contains SQL scripts for the data analysis on Migros datasets and Genomes
  * [coordinates.sql](./sql/coordinates.sql) --> extract coordinates of particular locations from Geonames dataset
  * [delays_from_risk_areas.sql](./sql/delays_from_risk_areas.sql) --> extract important shipment details from provided Migros datasets, including locations and timeframes details for departures and arrivals of all shipments, which are affected by the risks around the cities along the shipping routes
  * [get_full_sentiment_data.sql](./sql/get_full_sentiment_data.sql) --> extract sentimental scores of the selected locations to determine the risk rates
  * [get_geonames_coordinates.sql](./sql/et_geonames_coordinates.sql) --> divide the selected coordinate names into lat and long 
  * [risk_area_names.sql](./sql/risk_area_names.sql) --> extract risk area city names from Geonames dataset
 

## Challenges we ran into
Some SQL related function names on BigQuery are different from other SQLs such as PostgreSQL. Thanks to this challenge, we also learned different syntaxes for BigQuery. 


## What we learned

It was a great opportunity to brush up Google BigQuery SQL querying skills. Retrieving and combining data from different sources was challenging yet intriguing. Additionally, we got to explore interesting technologies like Google Maps Direction API, Geocoding API, ReTool, and NLP API while retrieving potential city names for successful shipments in the future.

## Further Development

* For now, we have only displayed one shipment route for demenstoration purposes. This can be modified such that the user can enter their disired origin and destination locations which can then be displayed on the maps.

* Instead of the free Geonames (city, country names) dataset, we should ideally switch to a better (paid) version of it. This will improve accuracy of our system. 

## References

https://blog.gdeltproject.org/announcing-the-global-entity-graph-geg-and-a-new-11-billion-entity-dataset/

https://developers.google.com/maps/documentation/directions/overview

https://cloud.google.com/bigquery/docs

### Google Clouds Credentials
Project ID: hackzurich22-4070 <br/>
Project Number: 451917323108 <br/>
