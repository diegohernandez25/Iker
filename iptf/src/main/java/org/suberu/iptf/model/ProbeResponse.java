package org.suberu.iptf.model;

import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import org.springframework.validation.annotation.Validated;
import javax.validation.Valid;
import javax.validation.constraints.*;

/**
 * ProbeResponse
 */
@Validated

public class ProbeResponse   {
  @JsonProperty("waypoints")
  @Valid
  private List<List<Float>> waypoints = new ArrayList<List<Float>>();

  @JsonProperty("cost")
  private Float cost = null;

  @JsonProperty("time")
  private BigDecimal time = null;

  @JsonProperty("dist")
  private Float dist = null;

  public ProbeResponse waypoints(List<List<Float>> waypoints) {
    this.waypoints = waypoints;
    return this;
  }

  public ProbeResponse addWaypointsItem(List<Float> waypointsItem) {
    this.waypoints.add(waypointsItem);
    return this;
  }

  /**
   * Get waypoints
   * @return waypoints
  **/
  @NotNull

  @Valid

  public List<List<Float>> getWaypoints() {
    return waypoints;
  }

  public void setWaypoints(List<List<Float>> waypoints) {
    this.waypoints = waypoints;
  }

  public ProbeResponse cost(Float cost) {
    this.cost = cost;
    return this;
  }

  /**
   * Get cost
   * @return cost
  **/
  @NotNull


  public Float getCost() {
    return cost;
  }

  public void setCost(Float cost) {
    this.cost = cost;
  }

  public ProbeResponse time(BigDecimal time) {
    this.time = time;
    return this;
  }

  /**
   * Get time
   * @return time
  **/
  @NotNull

  @Valid

  public BigDecimal getTime() {
    return time;
  }

  public void setTime(BigDecimal time) {
    this.time = time;
  }

  public ProbeResponse dist(Float dist) {
    this.dist = dist;
    return this;
  }

  /**
   * Get dist
   * @return dist
  **/
  @NotNull


  public Float getDist() {
    return dist;
  }

  public void setDist(Float dist) {
    this.dist = dist;
  }


  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    ProbeResponse probeResponse = (ProbeResponse) o;
    return Objects.equals(this.waypoints, probeResponse.waypoints) &&
        Objects.equals(this.cost, probeResponse.cost) &&
        Objects.equals(this.time, probeResponse.time) &&
        Objects.equals(this.dist, probeResponse.dist);
  }

  @Override
  public int hashCode() {
    return Objects.hash(waypoints, cost, time, dist);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class ProbeResponse {\n");
    
    sb.append("    waypoints: ").append(toIndentedString(waypoints)).append("\n");
    sb.append("    cost: ").append(toIndentedString(cost)).append("\n");
    sb.append("    time: ").append(toIndentedString(time)).append("\n");
    sb.append("    dist: ").append(toIndentedString(dist)).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(java.lang.Object o) {
    if (o == null) {
      return "null";
    }
    return o.toString().replace("\n", "\n    ");
  }
}

