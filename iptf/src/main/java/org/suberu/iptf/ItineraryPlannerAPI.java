package org.suberu.iptf;

import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import org.suberu.iptf.model.*;


@RestController
public class ItineraryPlannerAPI{
	
	@RequestMapping(value="/probe_trip",method=RequestMethod.POST)
	public ProbeRequest probeTrip(@RequestBody ProbeRequest pr,HttpServletRequest ht){
		//Response: ProbeResponse,400
		return pr;
	}
	
	@RequestMapping(value="/register_trip",method=RequestMethod.POST)
	public TripRequest registerTrip(@RequestBody TripRequest tr,HttpServletRequest ht){
		//Response: 201,400,409
		return tr;
	}
	
	@RequestMapping(value="/get_trips",method=RequestMethod.POST)
	public GetTripsRequest getTrips(@RequestBody GetTripsRequest gtr,HttpServletRequest ht){
		//Response: 200 (array),400
		return gtr;
	}
	
	@RequestMapping(value="/get_trip",method=RequestMethod.GET)
	public int getTrip(@RequestParam("TripId") int tripid, HttpServletRequest ht){
		//Response: TripResponse,400
		return tripid;
	}
	
	@RequestMapping(value="/del_trip",method=RequestMethod.DELETE)
	public int delTrip(@RequestParam("TripId") int tripid, HttpServletRequest ht){
		//Response: 200 (array),400
		return tripid;
	}
}
