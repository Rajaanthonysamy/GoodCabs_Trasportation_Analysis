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
city.city_name, 
date_format(trip.month,"%b") as month_name,
sum(FLOOR(SUBSTRING_INDEX(trip_count, '-', 1)) * repeat_passenger_count) AS total_trips,
target.total_target_trips as target_trips,
CASE 
	when sum(FLOOR(SUBSTRING_INDEX(trip_count, '-', 1)) * repeat_passenger_count) > target.total_target_trips
    then 'Above Target'
    else 'Below Target'
end as result,
CASE 
        WHEN target.total_target_trips = 0 THEN NULL
        ELSE 
            ROUND(ABS(((SUM(FLOOR(SUBSTRING_INDEX(trip.trip_count, '-', 1)) * trip.repeat_passenger_count) - target.total_target_trips) / target.total_target_trips)) * 100, 2) 
    END AS percentage_difference

FROM trips_db.dim_repeat_trip_distribution trip
join trips_db.dim_city city on trip.city_id=city.city_id
join targets_db.monthly_target_trips target on trip.city_id=target.city_id and target.month=trip.month
group by trip.month,trip.city_id;
