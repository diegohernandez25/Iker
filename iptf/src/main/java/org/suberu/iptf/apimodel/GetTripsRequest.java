package org.suberu.iptf.model;

import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import java.util.ArrayList;
import java.util.List;
import org.springframework.validation.annotation.Validated;
import javax.validation.Valid;
import javax.validation.constraints.*;

/**
 * GetTripsRequest
 */
@Validated

public class GetTripsRequest   {
  @JsonProperty("StartCoords")
  @Valid
  private List<Float> startCoords = new ArrayList<Float>();

  @JsonProperty("EndCoords")
  @Valid
  private List<Float> endCoords = new ArrayList<Float>();

  @JsonProperty("StartTime")
  private Float startTime = null;

  public GetTripsRequest startCoords(List<Float> startCoords) {
    this.startCoords = startCoords;
    return this;
  }

  public GetTripsRequest addStartCoordsItem(Float startCoordsItem) {
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

  public GetTripsRequest endCoords(List<Float> endCoords) {
    this.endCoords = endCoords;
    return this;
  }

  public GetTripsRequest addEndCoordsItem(Float endCoordsItem) {
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

  public GetTripsRequest startTime(Float startTime) {
    this.startTime = startTime;
    return this;
  }

  /**
   * the date for the trip
   * @return startTime
  **/


  public Float getStartTime() {
    return startTime;
  }

  public void setStartTime(Float startTime) {
    this.startTime = startTime;
  }


  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    GetTripsRequest getTripsRequest = (GetTripsRequest) o;
    return Objects.equals(this.startCoords, getTripsRequest.startCoords) &&
        Objects.equals(this.endCoords, getTripsRequest.endCoords) &&
        Objects.equals(this.startTime, getTripsRequest.startTime);
  }

  @Override
  public int hashCode() {
    return Objects.hash(startCoords, endCoords, startTime);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class GetTripsRequest {\n");
    
    sb.append("    startCoords: ").append(toIndentedString(startCoords)).append("\n");
    sb.append("    endCoords: ").append(toIndentedString(endCoords)).append("\n");
    sb.append("    startTime: ").append(toIndentedString(startTime)).append("\n");
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

