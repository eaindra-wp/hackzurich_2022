SELECT
    date, url, lang,
    polarity,
    magnitude,
    score,

    name,
    type,
    mid,
    wikipediaUrl,
    numMentions,
    avgSalience
FROM
    gdelt-bq.gdeltv2.geg_gcnlapi,
    UNNEST(entities) 
WHERE type = "LOCATION" AND score < -0.1 AND (date BETWEEN TIMESTAMP(current_timestamp(), INTERVAL 40 DAY) AND current_timestamp())
