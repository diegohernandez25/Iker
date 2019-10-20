start_trip="TripId=123"

trip_update="
{
  \"TripId\": 1569885623,
  \"Coords\": [
    40.642438,
    -8.655375
  ]
}
"

end_trip="TripId=123"

#########

curl -X POST localhost:8081/start_trip?$start_trip
echo;echo
curl -H "Content-Type: application/json" -d "$trip_update" -X POST localhost:8081/trip_update
echo;echo
curl -X POST localhost:8081/end_trip?$end_trip
echo
