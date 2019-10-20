package org.suberu.iptf;

import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import org.suberu.iptf.model.*;


@RestController
public class TripFollowerAPI{
	
	@RequestMapping(value="/start_trip",method=RequestMethod.POST)
	public int startTrip(@RequestParam("TripId") int tripid,HttpServletRequest ht){
		//Response: 201,400
		return tripid;
	}
	
	@RequestMapping(value="/trip_update",method=RequestMethod.POST)
	public TripUpdateBody tripUpdate(@RequestBody TripUpdateBody tub,HttpServletRequest ht){
		//Response: 201,400
		return tub;
	}
	
	@RequestMapping(value="/end_trip",method=RequestMethod.POST)
	public int endTrip(@RequestParam("TripId") int tripid,HttpServletRequest ht){
		//Response: 201,400
		return tripid;
	}
}
