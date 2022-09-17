select SPLIT(`coordinates`, ',')[safe_ordinal(1)] AS `lat`, 
  SPLIT(`coordinates`, ',')[safe_ordinal(2)] AS `long`, from `hackzurich22-4070.migros.UNIQUE`
