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
 * ProbeRequest
 */
@Validated

public class ProbeRequest   {
  @JsonProperty("StartCoords")
  @Valid
  private List<Float> startCoords = new ArrayList<Float>();

  @JsonProperty("EndCoords")
  @Valid
  private List<Float> endCoords = new ArrayList<Float>();

  @JsonProperty("Consumption")
  @Valid
  private List<Float> consumption = new ArrayList<Float>();

  @JsonProperty("AvoidHighways")
  private Boolean avoidHighways = null;

  @JsonProperty("AvoidTolls")
  private Boolean avoidTolls = null;

  @JsonProperty("StartTime")
  private Float startTime = null;

  @JsonProperty("EndTime")
  private Float endTime = null;

  @JsonProperty("MaxDetour")
  private BigDecimal maxDetour = null;

  public ProbeRequest startCoords(List<Float> startCoords) {
    this.startCoords = startCoords;
    return this;
  }

  public ProbeRequest addStartCoordsItem(Float startCoordsItem) {
    this.startCoords.add(startCoordsItem);
    return this;
  }

  /**
   * the coordinates of the starting point (x,y)
   * @return startCoords
  **/
  @NotNull

@Size(min=2,max=2) 
  public List<Float> getStartCoords() {
    return startCoords;
  }

  public void setStartCoords(List<Float> startCoords) {
    this.startCoords = startCoords;
  }

  public ProbeRequest endCoords(List<Float> endCoords) {
    this.endCoords = endCoords;
    return this;
  }

  public ProbeRequest addEndCoordsItem(Float endCoordsItem) {
    this.endCoords.add(endCoordsItem);
    return this;
  }

  /**
   * the coordinates of the final destination (x,y)
   * @return endCoords
  **/
  @NotNull

@Size(min=2,max=2) 
  public List<Float> getEndCoords() {
    return endCoords;
  }

  public void setEndCoords(List<Float> endCoords) {
    this.endCoords = endCoords;
  }

  public ProbeRequest consumption(List<Float> consumption) {
    this.consumption = consumption;
    return this;
  }

  public ProbeRequest addConsumptionItem(Float consumptionItem) {
    this.consumption.add(consumptionItem);
    return this;
  }

  /**
   * the average consumption (in l/100Km) of the car at 50, 90 and 120 Km/h
   * @return consumption
  **/
  @NotNull

@Size(min=3,max=3) 
  public List<Float> getConsumption() {
    return consumption;
  }

  public void setConsumption(List<Float> consumption) {
    this.consumption = consumption;
  }

  public ProbeRequest avoidHighways(Boolean avoidHighways) {
    this.avoidHighways = avoidHighways;
    return this;
  }

  /**
   * disallows the trip planner to use highways
   * @return avoidHighways
  **/
  @NotNull


  public Boolean isAvoidHighways() {
    return avoidHighways;
  }

  public void setAvoidHighways(Boolean avoidHighways) {
    this.avoidHighways = avoidHighways;
  }

  public ProbeRequest avoidTolls(Boolean avoidTolls) {
    this.avoidTolls = avoidTolls;
    return this;
  }

  /**
   * disallows the trip planner to use toll roads
   * @return avoidTolls
  **/
  @NotNull


  public Boolean isAvoidTolls() {
    return avoidTolls;
  }

  public void setAvoidTolls(Boolean avoidTolls) {
    this.avoidTolls = avoidTolls;
  }

  public ProbeRequest startTime(Float startTime) {
    this.startTime = startTime;
    return this;
  }

  /**
   * the datetime of the start of the trip (this and EndTime are mutually exclusive)
   * @return startTime
  **/


  public Float getStartTime() {
    return startTime;
  }

  public void setStartTime(Float startTime) {
    this.startTime = startTime;
  }

  public ProbeRequest endTime(Float endTime) {
    this.endTime = endTime;
    return this;
  }

  /**
   * the datetime of the start of the trip (this and StartTime are mutually exclusive)
   * @return endTime
  **/


  public Float getEndTime() {
    return endTime;
  }

  public void setEndTime(Float endTime) {
    this.endTime = endTime;
  }

  public ProbeRequest maxDetour(BigDecimal maxDetour) {
    this.maxDetour = maxDetour;
    return this;
  }

  /**
   * maximum number of kilometers that the driver accepts in a detour
   * @return maxDetour
  **/
  @NotNull

  @Valid

  public BigDecimal getMaxDetour() {
    return maxDetour;
  }

  public void setMaxDetour(BigDecimal maxDetour) {
    this.maxDetour = maxDetour;
  }


  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    ProbeRequest probeRequest = (ProbeRequest) o;
    return Objects.equals(this.startCoords, probeRequest.startCoords) &&
        Objects.equals(this.endCoords, probeRequest.endCoords) &&
        Objects.equals(this.consumption, probeRequest.consumption) &&
        Objects.equals(this.avoidHighways, probeRequest.avoidHighways) &&
        Objects.equals(this.avoidTolls, probeRequest.avoidTolls) &&
        Objects.equals(this.startTime, probeRequest.startTime) &&
        Objects.equals(this.endTime, probeRequest.endTime) &&
        Objects.equals(this.maxDetour, probeRequest.maxDetour);
  }

  @Override
  public int hashCode() {
    return Objects.hash(startCoords, endCoords, consumption, avoidHighways, avoidTolls, startTime, endTime, maxDetour);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class ProbeRequest {\n");
    
    sb.append("    startCoords: ").append(toIndentedString(startCoords)).append("\n");
    sb.append("    endCoords: ").append(toIndentedString(endCoords)).append("\n");
    sb.append("    consumption: ").append(toIndentedString(consumption)).append("\n");
    sb.append("    avoidHighways: ").append(toIndentedString(avoidHighways)).append("\n");
    sb.append("    avoidTolls: ").append(toIndentedString(avoidTolls)).append("\n");
    sb.append("    startTime: ").append(toIndentedString(startTime)).append("\n");
    sb.append("    endTime: ").append(toIndentedString(endTime)).append("\n");
    sb.append("    maxDetour: ").append(toIndentedString(maxDetour)).append("\n");
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

