SELECT 
    peak_name
FROM
    peaks
ORDER BY peak_name;

SELECT 
    country_name, population
FROM
    countries
WHERE
    continent_code = 'EU'
ORDER BY population DESC , country_name ASC
LIMIT 30;


SELECT 
    country_name,
    country_code,
    IF(currency_code = 'EUR',
        'Euro',
        'Not Euro') as currancy
FROM
    countries
ORDER BY country_name ASC;


SELECT 
    name
FROM
    characters
ORDER BY name ASC;





