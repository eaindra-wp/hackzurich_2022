-- helper function to convert the negative integer to the valid delay days
CREATE TEMP FUNCTION remove_minus_sign(x INT64) AS
(IF (x < 0, 
    (-1) * x, 
     /* ELSE */ CAST(x AS NUMERIC)));


-- retrieving the names of potential_risk_areas (cities), which are defined
-- according to the NLP dataset that we used to look for risks in the city, from 
-- Migros database
WITH potential_risk_areas AS(
 SELECT DISTINCT migros_raw_trac.*
  FROM `hackzurich22-4070.migros.gis_opex_international_raw_trac` migros_raw_trac
  JOIN `hackzurich22-4070.migros.UNIQUE` risky_locations
  ON risky_locations.name = migros_raw_trac.pod_name 
),
-- removing rows where city names are NULL from being SELECTED
not_null_arrivals_departures AS (
  SELECT * 
  FROM potential_risk_areas pra
  WHERE pra.sea_eta_pod IS NOT NULL
  AND pra.sea_dat_ank_hafen IS NOT NULL
  AND pra.sea_etd_pol IS NOT NULL 
),
-- find the difference between estimated and actual dates, i.e. for arrivals
date_diffs AS (
  SELECT pod_name, sea_etd_pol as est_dept_date, sea_eta_pod as est_arrival_date, sea_dat_ank_hafen as actual_arrival_date,
  DATETIME_DIFF(CAST(sea_eta_pod AS DATETIME FORMAT 'DD.MM.YYYY HH24:MI'), CAST(sea_dat_ank_hafen AS DATETIME FORMAT 'DD.MM.YYYY HH24:MI'), DAY) AS arrival_date_diff, container
  FROM not_null_arrivals_departures
),
-- joining with `opex_international_raw` table to retrieve the departure port's information
joined_raw AS (
  SELECT DISTINCT raw.imo_nr, raw.pol_land, raw.pol_name, raw.pod_land, date_diffs.*
  FROM date_diffs
  JOIN `hackzurich22-4070.migros.gis_opex_international_raw` raw 
  ON raw.container = date_diffs.container
  WHERE arrival_date_diff < 0
),
-- retrieving the ship routes of the containers which arrived later than estimated
ship_routes AS(
  SELECT date, eta, imo_number, destination, 
    SPLIT(destination, ' ')[safe_ordinal(1)] as country,
    SPLIT(destination, ' ')[safe_ordinal(2)] as city,
  FROM `hackzurich22-4070.migros.gis_opex_international_shiptrac` ship_track
  JOIN joined_raw ON joined_raw.imo_nr = ship_track.imo_number
  AND CAST(date AS DATETIME FORMAT 'DD.MM.YYYY HH24:MI') BETWEEN
    CAST(est_dept_date AS DATETIME FORMAT 'DD.MM.YYYY HH24:MI') AND CAST(actual_arrival_date AS DATETIME FORMAT 'DD.MM.YYYY HH24:MI')
)

-- finalizing the arrival dates and delays of the filtered routes which go through/reach the risk areas
SELECT DISTINCT container, imo_nr, pol_name AS departure_city, pod_name AS arrival_city, 
  SPLIT(est_dept_date, ' ')[safe_ordinal(1)]  AS est_dept_date,
  SPLIT(est_arrival_date, ' ')[safe_ordinal(1)] AS est_arrival_date, 
  SPLIT(actual_arrival_date, ' ')[safe_ordinal(1)] AS actual_arrival_date, 
  remove_minus_sign(arrival_date_diff) as delay_in_days
FROM joined_raw,ship_routes
WHERE imo_nr IS NOT NULL
AND REGEXP_CONTAINS(UPPER(pod_name), ship_routes.city)
ORDER BY imo_nr