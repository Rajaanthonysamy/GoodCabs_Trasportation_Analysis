SELECT city.city_name,
count(trip.trip_id) as total_trips,
sum(trip.fare_amount)/sum(trip.distance_travelled_km) as avg_fare_per_km,
sum(trip.fare_amount)/count(trip.trip_id) as avg_fare_per_trip,
count(trip.trip_id)*100/(select count(*) from trips_db.fact_trips) as trip_contribution_percentage,
(SUM(trip.fare_amount) * 100 / (SELECT SUM(fare_amount) FROM trips_db.fact_trips)) AS fare_contribution_percentage
FROM trips_db.fact_trips trip
join trips_db.dim_city city on trip.city_id=city.city_id
group by trip.city_id;