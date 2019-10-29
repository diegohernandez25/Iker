package org.suberu.iptf.repmodel;

import java.util.*;
import org.springframework.data.repository.CrudRepository;

public interface TripRepository extends CrudRepository<Trip, Integer> {

    //List<Trip> findById(Integer id);

    List<Trip> findByFinished(Boolean finished);

	List<Trip> findByStartTimeBetween(Date start,Date end);

}
