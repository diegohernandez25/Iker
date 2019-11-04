package org.suberu.iptf.repmodel;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.util.*;

import java.io.Serializable;

@Entity
public class Waypoint implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
	private Float lat,lon;

	protected Waypoint() {
    }

	public Waypoint(Float lat,Float lon){
		this.lat=lat;
		this.lon=lon;
	}

	public Float getLat(){ return lat; }
	public Float getLon(){ return lon; }

	public List<Float> getCoords(){
		List<Float> l = new ArrayList<>();
		l.add(lat);
		l.add(lon);
		return l;
	}

	public static Waypoint toWaypoint(List<Float> l){
		return new Waypoint(l.get(0),l.get(1));
	}

	public static List<Waypoint> toListWaypoints(List<List<Float>>  ll){
		List<Waypoint> l = new ArrayList<>();
		for(List<Float> lf : ll)
			l.add(toWaypoint(lf));
		return l; 
	}

	public static List<List<Float>> toListLists(List<Waypoint> lw){
		List<List<Float>> ll = new ArrayList<>();
		for(Waypoint w : lw)
			ll.add(w.getCoords());
		return ll;
	}

	@Override
	public String toString(){
		return (new StringBuilder())
				.append("Waypoint(")
				.append(lat).append(",")
				.append(lon).append(")")
				.toString();
	}
}
