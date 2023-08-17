SELECT 
    f.film_id,
    f.release_year,
    f.language_id,
    f.original_language_id,
    f.rental_duration,
    f.rental_rate,
    f.length,
    f.replacement_cost,
    f.rating,
    f.special_features,
    MAX(CASE 
        WHEN ir.rental_date IS NULL THEN 0
        ELSE 1
    END) AS rented_in_may
FROM 
    film f
LEFT JOIN (
	SELECT r.rental_date, i.film_id FROM inventory i 
	JOIN rental r ON r.inventory_id = i.inventory_id
	WHERE 
    MONTH(r.rental_date) = 5 AND YEAR(r.rental_date) = 2005
    ) as ir
    ON f.film_id = ir.film_id
GROUP BY 
    f.film_id, 
    f.release_year, 
    f.language_id, 
    f.original_language_id, 
    f.rental_duration, 
    f.rental_rate, 
    f.length, 
    f.replacement_cost, 
    f.rating, 
    f.special_features;
    
    
    
    SELECT 
    f.film_id,
    f.release_year,
    f.language_id,
    f.original_language_id,
    f.rental_duration,
    f.rental_rate,
    f.length,
    f.replacement_cost,
    f.rating,
    f.special_features,
    MAX(CASE 
        WHEN ir.rental_date IS NULL THEN 0
        ELSE 1
    END) AS rented_in_may,
    COALESCE(sac.star_actor_count, 0) AS star_actor_count
FROM 
    film f
LEFT JOIN (
	SELECT r.rental_date, i.film_id FROM inventory i 
	JOIN rental r ON r.inventory_id = i.inventory_id
	WHERE 
    MONTH(r.rental_date) = 5 AND YEAR(r.rental_date) = 2005
    ) as ir
    ON f.film_id = ir.film_id
LEFT JOIN (
    SELECT 
        fa.film_id,
        COUNT(fa.actor_id) as star_actor_count
    FROM 
        film_actor fa
    WHERE 
        fa.actor_id IN (
            SELECT 
                actor_id
            FROM 
                film_actor
            GROUP BY 
                actor_id
            HAVING 
                COUNT(film_id) > 30
        )
    GROUP BY 
        fa.film_id
) as sac
ON f.film_id = sac.film_id
GROUP BY 
    f.film_id, 
    f.release_year, 
    f.language_id, 
    f.original_language_id, 
    f.rental_duration, 
    f.rental_rate, 
    f.length, 
    f.replacement_cost, 
    f.rating, 
    f.special_features;

SELECT 
    f.film_id,
    f.release_year,
    f.language_id,
    f.original_language_id,
    f.rental_duration,
    f.rental_rate,
    f.length,
    f.replacement_cost,
    f.rating,
    f.special_features,
    MAX(CASE 
        WHEN ir.rental_date IS NULL THEN 0
        ELSE 1
    END) AS rented_in_may,
    COALESCE(DATEDIFF('2005-06-01', lrd.last_rental_date), -1) AS days_since_last_rental
FROM 
    film f
LEFT JOIN (
    SELECT r.rental_date, i.film_id 
    FROM inventory i 
    JOIN rental r ON r.inventory_id = i.inventory_id
    WHERE 
        MONTH(r.rental_date) = 5 AND YEAR(r.rental_date) = 2005
) as ir
ON f.film_id = ir.film_id
LEFT JOIN (
    SELECT i.film_id, MAX(r.rental_date) as last_rental_date
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE r.rental_date < '2005-06-01'
    GROUP BY i.film_id
) as lrd
ON f.film_id = lrd.film_id
GROUP BY 
    f.film_id, 
    f.release_year, 
    f.language_id, 
    f.original_language_id, 
    f.rental_duration, 
    f.rental_rate, 
    f.length, 
    f.replacement_cost, 
    f.rating, 
    f.special_features;

SELECT 
    f.film_id,
    f.release_year,
    f.language_id,
    f.rental_duration,
    f.rental_rate,
    f.length,
    f.replacement_cost,
    f.rating,
    f.special_features,
    MAX(CASE 
        WHEN ir.rental_date IS NULL THEN 0
        ELSE 1
    END) AS rented_in_may,
    COALESCE(DATEDIFF('2005-06-01', lrd.last_rental_date), -1) AS days_since_last_rental,
    COALESCE(ROUND(mean_rental_price.avg_price, 2),-1) AS avg_rental_price
FROM 
    film f
LEFT JOIN (
    SELECT r.rental_date, i.film_id 
    FROM inventory i 
    JOIN rental r ON r.inventory_id = i.inventory_id
    WHERE 
        MONTH(r.rental_date) = 5 AND YEAR(r.rental_date) = 2005
) as ir
ON f.film_id = ir.film_id
LEFT JOIN (
    SELECT i.film_id, MAX(r.rental_date) as last_rental_date
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE r.rental_date < '2005-06-01'
    GROUP BY i.film_id
) as lrd
ON f.film_id = lrd.film_id
LEFT JOIN (
    SELECT i.film_id, AVG(p.amount) as avg_price
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE 
        MONTH(r.rental_date) = 5 AND YEAR(r.rental_date) = 2005
    GROUP BY i.film_id
) as mean_rental_price
ON f.film_id = mean_rental_price.film_id
GROUP BY 
    f.film_id, 
    f.release_year, 
    f.language_id, 
    f.original_language_id, 
    f.rental_duration, 
    f.rental_rate, 
    f.length, 
    f.replacement_cost, 
    f.rating, 
    f.special_features;
    
    
    SELECT
    fc.film_id,
    MAX(CASE WHEN fc.category_id = 1 THEN 1 ELSE 0 END) AS Action,
    MAX(CASE WHEN fc.category_id = 2 THEN 1 ELSE 0 END) AS Animation,
    MAX(CASE WHEN fc.category_id = 3 THEN 1 ELSE 0 END) AS Children,
    MAX(CASE WHEN fc.category_id = 4 THEN 1 ELSE 0 END) AS Classics,
    MAX(CASE WHEN fc.category_id = 5 THEN 1 ELSE 0 END) AS Comedy,
    MAX(CASE WHEN fc.category_id = 6 THEN 1 ELSE 0 END) AS Documentary,
    MAX(CASE WHEN fc.category_id = 7 THEN 1 ELSE 0 END) AS Drama,
    MAX(CASE WHEN fc.category_id = 8 THEN 1 ELSE 0 END) AS Family,
    MAX(CASE WHEN fc.category_id = 9 THEN 1 ELSE 0 END) AS 'Foreign',
    MAX(CASE WHEN fc.category_id = 10 THEN 1 ELSE 0 END) AS Games,
    MAX(CASE WHEN fc.category_id = 11 THEN 1 ELSE 0 END) AS Horror,
    MAX(CASE WHEN fc.category_id = 12 THEN 1 ELSE 0 END) AS Music,
    MAX(CASE WHEN fc.category_id = 13 THEN 1 ELSE 0 END) AS 'New',
    MAX(CASE WHEN fc.category_id = 14 THEN 1 ELSE 0 END) AS SciFi,
    MAX(CASE WHEN fc.category_id = 15 THEN 1 ELSE 0 END) AS Sports,
    MAX(CASE WHEN fc.category_id = 16 THEN 1 ELSE 0 END) AS Travel
FROM 
    film_category fc
GROUP BY
    fc.film_id
ORDER BY
	fc.film_id;
    
SELECT
    film_id,
    COUNT(*) as count
FROM
    film_category
GROUP BY
    film_id
HAVING
    COUNT(*) > 1;
