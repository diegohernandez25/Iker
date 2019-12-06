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
public class ItineraryPlannerAPI{

	//private static String RESTKEY = "RESTGP20190930110108209441913192";
	private static String RESTKEY = "RESTGP20191120000304894795243111";

	@Autowired
	TripRepository triprep;

	private static JSONObject michelinGet(String request) throws Exception{
		URL url = new URL(request+"&authkey="+RESTKEY+"&callback=%22%22");
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestMethod("GET");
		BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuilder content = new StringBuilder();
		while ((inputLine = in.readLine()) != null) {
			content.append(inputLine);
		}
		in.close();	
		return new JSONObject(content.substring(3,content.length()-1));

	}

	private static Map<String,Float> getFuelCosts() throws Exception{
		Document doc = Jsoup.connect("https://www.maisgasolina.com/").get();
		Element elem = doc.selectFirst("#homeAverage");
		Elements elems = elem.children();	

		Map<String,Float> ret = new HashMap<>();
	
		int ptr=1;
		String fuelName;
		Element fuelType;
		while(ptr<elems.size()-3){
			fuelName=elems.get(ptr).text();
			fuelType=elems.get(ptr+1);
			fuelType.child(0).remove();
			ret.put(fuelName,Float.parseFloat(fuelType.text().substring(1)));
			ptr+=2;
		}
		return ret;
	}

	public static ProbeResponse getTripDetails(List<Waypoint> lw, ProbeRequest pr) throws Exception{
		//https://secure-apir.viamichelin.com/apir/1/route.json/{lg}[/{data}]?steps={dep};[{steps};]{arr}&veht={veht}&itit={itit}&favMotorways={favMotorways}&avoidBorders={avoidBorders}&avoidTolls={avoidTolls}&avoidCCZ={avoidCCZ}&avoidORC={avoidORC}&multipleIti={multipleIti}&itiIdx={itiIdx}&distUnit={distUnit}&fuelConsump={fuelConsump}&fuelCost={fuelCost}&date={date}&cy={currency}&authkey={authkey}&charset={charset}&ie={ie}&callback={callback}&signature={signature}
		//Response: ProbeResponse,400
		String example="https://secure-apir.viamichelin.com/apir/1/route.json/fra?steps=1:e:2.0:48.0;1:e:3.0:49.0&fuelConsump=7.9:6.9:7.0";
		StringBuilder sb=new StringBuilder();
		sb.append("https://secure-apir.viamichelin.com/apir/1/route.json/eng?");
		sb.append("avoidTolls=").append(pr.isAvoidTolls()?"true":"false");

		if(lw==null){
			sb.append("&steps=").append("1:e:").append(pr.getStartCoords().get(1))
								.append(":").append(pr.getStartCoords().get(0))
								.append(";1:e:").append(pr.getEndCoords().get(1))
								.append(":").append(pr.getEndCoords().get(0));
		}
		else{
			sb.append("&steps=").append("1:e:").append(lw.get(0).getLon())
								.append(":").append(lw.get(0).getLat());
			for(int i=1;i<lw.size();i++)
				sb.append(";1:e:").append(lw.get(i).getLon())
				  .append(":").append(lw.get(i).getLat());
		}

		sb.append("&fuelConsump=").append(pr.getConsumption().get(0))
							.append(":").append(pr.getConsumption().get(1))
							.append(":").append(pr.getConsumption().get(2));
	
		JSONObject get=null;

		get=michelinGet(sb.toString()).getJSONObject("iti");

		ProbeResponse resp=new ProbeResponse();

		//Get waypoints	
		List<List<Float>> waypoints=new ArrayList<>();
		List<Float> wp;
		JSONObject jo;
		for(Object ja : get.getJSONArray("roadSheet").getJSONArray(0)){
			jo=((JSONArray) ja).getJSONObject(2);
			wp=new ArrayList<>();
			wp.add(jo.getFloat("lat"));
			wp.add(jo.getFloat("lon"));
			waypoints.add(wp);
		}

		//Get tollCost,totalDist and totalTime
		JSONObject summary = get.getJSONObject("header")
							.getJSONArray("summaries")
							.getJSONObject(0);
		int consumption=summary.getInt("consumption");
		float tollCost=summary.getJSONObject("tollCost").getInt("car")/(float) 100.0;
		int totalDist=summary.getInt("totalDist");
		int totalTime=summary.getInt("totalTime");

		//Get fuelCosts
		Map<String,Float> fuelCosts=null;
		fuelCosts=getFuelCosts();

		float fuelCost;
		switch(pr.getFuelType()){
			case "petrol":
				fuelCost=fuelCosts.get("Gasolina 95 Simples");
				break;
			case "diesel":
				fuelCost=fuelCosts.get("Gasóleo Simples");
				break;
			case "gpl":
				fuelCost=fuelCosts.get("GPL Auto");
				break;
			default:
				return null;
		}	

		//Calculate arrival/departure times
		long time;
		if(pr.getStartTime()!=null)
			time=pr.getStartTime().longValue()+totalTime;
		else
			time=pr.getEndTime().longValue()-totalTime;

		resp.setWaypoints(waypoints);
		resp.setCost(tollCost+fuelCost*consumption);
		resp.setDist((float) totalDist);
		resp.setTime(new BigDecimal(time));

		return resp;

	}
	
	@RequestMapping(value="/probe_trip",method=RequestMethod.POST)
	public ResponseEntity probeTrip(@RequestBody ProbeRequest pr,HttpServletRequest ht){
		System.out.printf("probeTrip: %s\n",pr.toString());
		//ProbeResponse
		try{
			return new ResponseEntity<ProbeResponse>(getTripDetails(null,pr),HttpStatus.OK);
		}catch(Exception e){
			//e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
	}
	
	@RequestMapping(value="/register_trip",method=RequestMethod.POST)
	public ResponseEntity registerTrip(@RequestBody ProbeRequest pr,HttpServletRequest ht){
		System.out.printf("registerTrip: %s\n",pr.toString());
		ProbeResponse prr = (ProbeResponse) probeTrip(pr,null).getBody();

		Date start,end;
		if(pr.getStartTime()!=null){
			start=new Date(pr.getStartTime().longValue()*1000);
			end=new Date(prr.getTime().longValue()*1000);
		}
		else{
			start=new Date(prr.getTime().longValue()*1000);
			end=new Date(pr.getEndTime().longValue()*1000);
		}

		List<List<Float>> coords=new ArrayList<>();
		coords.add(pr.getStartCoords());
		coords.add(pr.getEndCoords());

		Trip t = new Trip(coords,
							prr.getWaypoints(),
							start,
							end,
							pr.getMaxDetour().intValue()*1000, //KM to Meters
							pr.isAvoidTolls(),
							pr.getFuelType(),
							pr.getConsumption(),
							prr.getDist());
		
		//Response: 201,400,409
		return new ResponseEntity<Integer>(triprep.save(t).getId(),HttpStatus.OK);
	}
	
	@RequestMapping(value="/get_trips",method=RequestMethod.POST)
	public ResponseEntity getTrips(@RequestBody GetTripsRequest gtr,HttpServletRequest ht){
		System.out.printf("getTrips: %s\n",gtr.toString());
		Date startday,endday;

		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date(gtr.getStartTime().longValue()*1000));
		cal.set(Calendar.HOUR_OF_DAY,0);
		cal.set(Calendar.MINUTE,0);
		cal.set(Calendar.SECOND,0);
		startday=cal.getTime();
	
		cal.set(Calendar.HOUR_OF_DAY,23);
		cal.set(Calendar.MINUTE,59);
		cal.set(Calendar.SECOND,59);
		endday=cal.getTime();

		Iterable<Trip> it = triprep.findByStartTimeBetween(startday,endday);
		List<Integer> ls=new ArrayList<>();
		List<List<Float>> llf;
		ProbeRequest pr;
		for(Trip t : it){
			if(t.getMaxDetour()==0) continue;

			pr= new ProbeRequest();
			pr.setConsumption(t.getConsumption());
			pr.setAvoidTolls(t.getAvoidTolls());
			pr.setStartTime(new BigDecimal(t.getStartTime().getTime()/1000));
			pr.setEndTime(new BigDecimal(t.getEndTime().getTime()/1000));
			pr.setMaxDetour(new BigDecimal(t.getMaxDetour()));
			pr.setFuelType(t.getFuelType());

			llf=new ArrayList<>(t.getCoords());
			llf.add(1,gtr.getStartCoords());
			llf.add(llf.size()-1,gtr.getEndCoords());

			try{
				if(getTripDetails(Waypoint.toListWaypoints(llf),pr).getDist()<t.getMaxDetour()+t.getDist())
					ls.add(t.getId());
			}catch(Exception e){
				//e.printStackTrace();
				//return new ResponseEntity<>(HttpStatus.BAD_REQUEST);	
			}
		}
		//Response: 200 (array),400
		return new ResponseEntity<List<Integer>>(ls,HttpStatus.OK); 
	}

	@RequestMapping(value="/add_subtrip",method=RequestMethod.POST)
	public ResponseEntity addSubTrip(@RequestBody AddSubtripRequest asr, HttpServletRequest ht){
		System.out.printf("addSubTrip: %s\n",asr.toString());
		Trip t=triprep.findById(asr.getTripId().intValue()).get();

		if(t.getMaxDetour()==0)
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);

		ProbeRequest pr= new ProbeRequest();
		pr.setConsumption(t.getConsumption());
		pr.setAvoidTolls(t.getAvoidTolls());
		pr.setStartTime(new BigDecimal(t.getStartTime().getTime()));
		pr.setEndTime(new BigDecimal(t.getEndTime().getTime()));
		pr.setMaxDetour(new BigDecimal(t.getMaxDetour()));
		pr.setFuelType(t.getFuelType());

		List<List<Float>> llf=t.getCoords();
		llf.add(1,asr.getStartCoords());
		llf.add(llf.size()-1,asr.getEndCoords());

		ProbeResponse prr;
		try{
			prr = getTripDetails(Waypoint.toListWaypoints(llf),pr);
		}catch(Exception e){
			//e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);	
		}	

		if(prr.getDist()>t.getMaxDetour()+t.getDist())
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);

		//t.setMaxDetour(0); //Doesnt allow for more than one subtrip
		t.setDist(prr.getDist());
		t.setCoords(llf);
	
		triprep.save(t);	
	
		//Response: 200,400
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/get_trip",method=RequestMethod.GET)
	public ResponseEntity getTrip(@RequestParam("TripId") int tripid, HttpServletRequest ht){
		System.out.printf("getTrip: %d\n",tripid);
		
		Optional<Trip> ot = triprep.findById(tripid);	
		if(!ot.isPresent())
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		Trip t = ot.get();
		TripResponse tr=new TripResponse();
		tr.setCoords(t.getCoords());
		tr.setStartTime(t.getStartTime().getTime()/1000);
		tr.setEndTime(t.getEndTime().getTime()/1000);
		tr.setMaxDetour(new BigDecimal(t.getMaxDetour()));
		//Response: TripResponse,400
		return new ResponseEntity<TripResponse>(tr,HttpStatus.OK);
	}
	
	@RequestMapping(value="/del_trip",method=RequestMethod.DELETE)
	public ResponseEntity delTrip(@RequestParam("TripId") int tripid, HttpServletRequest ht){
		//Response: 200 (array),400
		//We dont erase trips for history
		//triprep.deleteById(tripid);
		return new ResponseEntity<>(HttpStatus.OK);
	}
}
