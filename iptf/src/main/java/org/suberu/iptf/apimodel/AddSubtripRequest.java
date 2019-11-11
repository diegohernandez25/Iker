package org.suberu.iptf.apimodel;

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
 * AddSubtripRequest
 */
@Validated

public class AddSubtripRequest   {
  @JsonProperty(required=true,value="TripId")
  private BigDecimal tripId = null;

  @JsonProperty(required=true,value="StartCoords")
  @Valid
  private List<Float> startCoords = new ArrayList<Float>();

  @JsonProperty(required=true,value="EndCoords")
  @Valid
  private List<Float> endCoords = new ArrayList<Float>();

  public AddSubtripRequest tripId(BigDecimal tripId) {
    this.tripId = tripId;
    return this;
  }

  /**
   * the id of the trip to add the subtrip
   * @return tripId
  **/

  @Valid

  public BigDecimal getTripId() {
    return tripId;
  }

  public void setTripId(BigDecimal tripId) {
    this.tripId = tripId;
  }

  public AddSubtripRequest startCoords(List<Float> startCoords) {
    this.startCoords = startCoords;
    return this;
  }

  public AddSubtripRequest addStartCoordsItem(Float startCoordsItem) {
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

  public AddSubtripRequest endCoords(List<Float> endCoords) {
    this.endCoords = endCoords;
    return this;
  }

  public AddSubtripRequest addEndCoordsItem(Float endCoordsItem) {
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


  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    AddSubtripRequest addSubtripRequest = (AddSubtripRequest) o;
    return Objects.equals(this.tripId, addSubtripRequest.tripId) &&
        Objects.equals(this.startCoords, addSubtripRequest.startCoords) &&
        Objects.equals(this.endCoords, addSubtripRequest.endCoords);
  }

  @Override
  public int hashCode() {
    return Objects.hash(tripId, startCoords, endCoords);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class AddSubtripRequest {\n");
    
    sb.append("    tripId: ").append(toIndentedString(tripId)).append("\n");
    sb.append("    startCoords: ").append(toIndentedString(startCoords)).append("\n");
    sb.append("    endCoords: ").append(toIndentedString(endCoords)).append("\n");
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


