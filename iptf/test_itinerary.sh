probe_trip="
{
  \"StartCoords\": [
    40.632933, 
	-8.659798
  ],
  \"EndCoords\": [
	40.209366,
	-8.444125
  ],
  \"Consumption\": [
    5,
    7.4,
    9
  ],
  \"AvoidHighways\": false,
  \"AvoidTolls\": true,
  \"StartTime\": 1569885623,
  \"EndTime\": 1569885623,
  \"MaxDetour\": 0,
  \"FuelType\": \"petrol\"
}
"

register_trip="
{
  \"TripId\": 0,
  \"StartCoords\": [
    40.642438,
    -8.655375
  ],
  \"EndCoords\": [
    40.633309,
    -8.659626
  ],
  \"Consumption\": [
    5,
    7.4,
    9
  ],
  \"AvoidHighways\": false,
  \"AvoidTolls\": true,
  \"StartTime\": 1569885623,
  \"EndTime\": 1569885623,
  \"MaxDetour\": 0,
  \"FuelType\": \"petrol\"
}
"

get_trips="
{
  \"StartCoords\": [
    40.642438,
    -8.655375
  ],
  \"EndCoords\": [
    40.633309,
    -8.659626
  ],
  \"StartTime\": 1569885623
}
"

get_trip="TripId=123"

del_trip="TripId=123"

#########

curl -H "Content-Type: application/json" -d "$probe_trip" -X POST localhost:8081/probe_trip
echo;echo
curl -H "Content-Type: application/json" -d "$register_trip" -X POST localhost:8081/register_trip
echo;echo
curl -H "Content-Type: application/json" -d "$get_trips" -X POST localhost:8081/get_trips
echo;echo
curl -X GET localhost:8081/get_trip?$get_trip
echo;echo
curl -d "$del_trip" -X DELETE localhost:8081/del_trip
echo
