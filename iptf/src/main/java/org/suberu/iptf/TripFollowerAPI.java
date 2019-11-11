package org.suberu.iptf;

import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.*;
import javax.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.suberu.iptf.apimodel.*;
import org.suberu.iptf.repmodel.*;

import java.io.*;
import java.net.*;
import java.util.*;
import java.math.*;

import org.json.*;
import org.jsoup.*;
import org.jsoup.nodes.*;
import org.jsoup.select.*;



@RestController
public class TripFollowerAPI{

	@Autowired
	TripRepository triprep;

	@RequestMapping(value="/start_trip",method=RequestMethod.POST)
	public ResponseEntity startTrip(@RequestParam("TripId") int tripid,HttpServletRequest ht){
		Trip t = triprep.findById(tripid).get();

		if(t.isFinished() || t.isOngoing()) return new ResponseEntity<>(HttpStatus.CONFLICT);

		t.setOngoing();
		triprep.save(t);
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/trip_update",method=RequestMethod.POST)
	public ResponseEntity tripUpdate(@RequestBody TripUpdateBody tub,HttpServletRequest ht){
		Trip t = triprep.findById(tub.getTripId().intValue()).get();
		
		if(t.isFinished() || !t.isOngoing()) return new ResponseEntity<>(HttpStatus.CONFLICT);

		List<List<Float>> hist = t.getHistory();
		hist.add(tub.getCoords());
		t.setHistory(hist);
		triprep.save(t);

		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/get_last_pos",method=RequestMethod.GET)
	public ResponseEntity getLastPos(@RequestParam("TripId") int tripid,HttpServletRequest ht){
		Optional<Trip> ot = triprep.findById(tripid);
		if(!ot.isPresent()) return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		Trip t = triprep.findById(tripid).get();
		TripUpdateBody tub = new TripUpdateBody();
		List<List<Float>> llf = t.getHistory();

		tub.setTripId(new BigDecimal(tripid));
		tub.setCoords(llf.get(llf.size()-1));
	
		return new ResponseEntity<TripUpdateBody>(tub,HttpStatus.OK);
	}

	@RequestMapping(value="/end_trip",method=RequestMethod.POST)
	public ResponseEntity endTrip(@RequestParam("TripId") int tripid,HttpServletRequest ht){
		Trip t = triprep.findById(tripid).get();

		if(t.isFinished() || !t.isOngoing()) return new ResponseEntity<>(HttpStatus.CONFLICT);
		t.setFinished();			
		triprep.save(t);

		return new ResponseEntity<>(HttpStatus.OK);
	}
}
