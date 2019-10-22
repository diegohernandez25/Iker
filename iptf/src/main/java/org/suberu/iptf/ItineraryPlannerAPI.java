package org.suberu.iptf;

import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import org.suberu.iptf.model.*;

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

	private static String RESTKEY = "RESTGP20190930110108209441913192";

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
	
	@RequestMapping(value="/probe_trip",method=RequestMethod.POST)
	public ProbeResponse probeTrip(@RequestBody ProbeRequest pr,HttpServletRequest ht){
		//https://secure-apir.viamichelin.com/apir/1/route.json/{lg}[/{data}]?steps={dep};[{steps};]{arr}&veht={veht}&itit={itit}&favMotorways={favMotorways}&avoidBorders={avoidBorders}&avoidTolls={avoidTolls}&avoidCCZ={avoidCCZ}&avoidORC={avoidORC}&multipleIti={multipleIti}&itiIdx={itiIdx}&distUnit={distUnit}&fuelConsump={fuelConsump}&fuelCost={fuelCost}&date={date}&cy={currency}&authkey={authkey}&charset={charset}&ie={ie}&callback={callback}&signature={signature}
		//Response: ProbeResponse,400
		String example="https://secure-apir.viamichelin.com/apir/1/route.json/fra?steps=1:e:2.0:48.0;1:e:3.0:49.0&fuelConsump=7.9:6.9:7.0";
		StringBuilder sb=new StringBuilder();
		sb.append("https://secure-apir.viamichelin.com/apir/1/route.json/eng?");
		sb.append("avoidTolls=").append(pr.isAvoidTolls()?"true":"false");
		sb.append("&steps=").append("1:e:").append(pr.getStartCoords().get(1))
							.append(":").append(pr.getStartCoords().get(0))
							.append(";1:e:").append(pr.getEndCoords().get(1))
							.append(":").append(pr.getEndCoords().get(0));
		sb.append("&fuelConsump=").append(pr.getConsumption().get(0))
							.append(":").append(pr.getConsumption().get(1))
							.append(":").append(pr.getConsumption().get(2));
	
		JSONObject get=null;

		try{
			get=michelinGet(sb.toString()).getJSONObject("iti");
		}
		catch(Exception e){
			System.out.println(e);
			return null;
		}

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
		int tollCost=summary.getJSONObject("tollCost").getInt("car");
		int totalDist=summary.getInt("totalDist");
		int totalTime=summary.getInt("totalTime");

		//Get fuelCosts
		Map<String,Float> fuelCosts=null;
		try{
			fuelCosts=getFuelCosts();
		}
		catch(Exception e){
			System.out.println(e);
			return null;
		}

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
		int time;
		if(pr.getStartTime()!=null)
			time=pr.getStartTime().intValue()+totalTime;
		else
			time=pr.getEndTime().intValue()-totalTime;

		resp.setWaypoints(waypoints);
		resp.setCost(tollCost+fuelCost*consumption);
		resp.setDist((float) totalDist);
		resp.setTime(new BigDecimal(time));

		return resp;
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
