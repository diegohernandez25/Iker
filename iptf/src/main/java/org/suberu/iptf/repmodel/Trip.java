package org.suberu.iptf.repmodel;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.*;
import java.util.*;

import java.io.Serializable;

@Entity
public class Trip implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Integer id;
	private Boolean finished;
	private Boolean ongoing;
	private Integer maxDetour;
	private Float dist;
	private Boolean avoidTolls;
	private String fuelType;
	
	private Float cons50;
	private Float cons90;
	private Float cons120;

	@Temporal(TemporalType.TIMESTAMP)
	private Date startTime;
	@Temporal(TemporalType.TIMESTAMP)
	private Date endTime;

	@OneToMany(cascade = {CascadeType.ALL})
	private List<Waypoint> history;

	@OneToMany(cascade = {CascadeType.ALL})
	private List<Waypoint> coords;
	@OneToMany(cascade = {CascadeType.ALL})
	private List<Waypoint> waypoints;


	protected Trip() {
	}

	public Trip(List<List<Float>> c,List<List<Float>> wp,Date st,Date et,int md,boolean at,String ft,List<Float> cons,float d){
		coords=Waypoint.toListWaypoints(c);
		waypoints=Waypoint.toListWaypoints(wp);
		history=new ArrayList<>();
		maxDetour=md;
		startTime=st;
		endTime=et;
		avoidTolls=at;
		fuelType=ft;
		cons50=cons.get(0);
		cons90=cons.get(1);
		cons120=cons.get(2);
		dist=d;
		finished=false;
		ongoing=false;
	}

	public List<List<Float>> getHistory(){
		return Waypoint.toListLists(history);
	}
	public void setHistory(List<List<Float>> llf){
		history=Waypoint.toListWaypoints(llf);
	}

	public float getDist(){ return dist; }
	public void setDist(float d){ dist=d; }

	public List<List<Float>> getCoords(){
		return Waypoint.toListLists(coords);
	}

	public void setCoords(List<List<Float>> llf){
		coords=Waypoint.toListWaypoints(llf);
	}

	public List<List<Float>> getWaypoints(){
		return Waypoint.toListLists(waypoints);
	}
	public void setWaypoints(List<List<Float>> llf){
		waypoints=Waypoint.toListWaypoints(llf); 
	}

	public String getFuelType(){ return fuelType; }
	public boolean getAvoidTolls(){ return avoidTolls; }
	public List<Float> getConsumption(){
		List<Float> a = new ArrayList<>();
		a.add(cons50);
		a.add(cons90);
		a.add(cons120);
		return a;
	}

	public int getMaxDetour(){ return maxDetour; }
	public void setMaxDetour(int md){ maxDetour=md; }

	public boolean isFinished() { return finished; }
	public void setFinished() { finished=true; }

	public boolean isOngoing() { return ongoing; }
	public void setOngoing() { ongoing=true; }

	public Integer getId(){ return id; }

	public Date getStartTime(){ return startTime; }
	public Date getEndTime(){ return endTime; }

    @Override
    public String toString(){
        return (new StringBuilder())
                .append("Trip(Coords:").append(coords)
                .append("\nStartTime:").append(startTime)
				.append("\nEndTime:").append(endTime)
				.append("\nDistance:").append(dist)
				.append("\nWaypoints:").append(waypoints)
				.append("\nMaxDetour:").append(maxDetour)
				.append("\nFinished:").append(finished)
				.append(")").toString();
    }
}
