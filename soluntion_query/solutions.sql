SELECT city.city_name,
count(trip.trip_id) as total_trips,
sum(trip.fare_amount)/sum(trip.distance_travelled_km) as avg_fare_per_km,
sum(trip.fare_amount)/count(trip.trip_id) as avg_fare_per_trip,
count(trip.trip_id)*100/(select count(*) from trips_db.fact_trips) as trip_contribution_percentage,
(SUM(trip.fare_amount) * 100 / (SELECT SUM(fare_amount) FROM trips_db.fact_trips)) AS fare_contribution_percentage
FROM trips_db.fact_trips trip
join trips_db.dim_city city on trip.city_id=city.city_id
group by trip.city_id;




SELECT 
	city.city_name as city_name,
    DATE_FORMAT(trip.date, "%b") AS month_name,
    COUNT(trip.trip_id) AS actual_trips,
    ANY_VALUE(target.total_target_trips) as target_trips,
    CASE 
        WHEN COUNT(trip.trip_id) > ANY_VALUE(target.total_target_trips)
        THEN "Above Target"
        ELSE "Below Target"
    END AS performance_status,
    ((COUNT(trip.trip_id) - ANY_VALUE(target.total_target_trips)) / ANY_VALUE(target.total_target_trips)) * 100 as performance
    
FROM 
    trips_db.fact_trips trip
JOIN 
    targets_db.monthly_target_trips target
    ON DATE_FORMAT(trip.date, "%b") = DATE_FORMAT(target.month, "%b")
    AND trip.city_id = target.city_id
join trips_db.dim_city city
on city.city_id=trip.city_id
GROUP BY 
    trip.city_id, DATE_FORMAT(trip.date, "%b")
;

