create table migros.neww as (SELECT 
A.*,
B.coordinates
FROM `hackzurich22-4070.migros.TEST` A
INNER JOIN `hackzurich22-4070.migros.geonames-all-cities-with-a-population-1000` B
ON A.name=B.Name OR A.name=B.Country_Code OR A.name=B.Country_name_EN)
