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
 * TripUpdateBody
 */
@Validated

public class TripUpdateBody   {
  @JsonProperty("TripId")
  private BigDecimal tripId = null;

  @JsonProperty("Coords")
  @Valid
  private List<Float> coords = new ArrayList<Float>();

  public TripUpdateBody tripId(BigDecimal tripId) {
    this.tripId = tripId;
    return this;
  }

  /**
   * the id of the trip
   * @return tripId
  **/
  @NotNull

  @Valid

  public BigDecimal getTripId() {
    return tripId;
  }

  public void setTripId(BigDecimal tripId) {
    this.tripId = tripId;
  }

  public TripUpdateBody coords(List<Float> coords) {
    this.coords = coords;
    return this;
  }

  public TripUpdateBody addCoordsItem(Float coordsItem) {
    this.coords.add(coordsItem);
    return this;
  }

  /**
   * the coordinates of the current position (x,y)
   * @return coords
  **/
  @NotNull

@Size(min=2,max=2) 
  public List<Float> getCoords() {
    return coords;
  }

  public void setCoords(List<Float> coords) {
    this.coords = coords;
  }


  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    TripUpdateBody tripUpdateBody = (TripUpdateBody) o;
    return Objects.equals(this.tripId, tripUpdateBody.tripId) &&
        Objects.equals(this.coords, tripUpdateBody.coords);
  }

  @Override
  public int hashCode() {
    return Objects.hash(tripId, coords);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class TripUpdateBody {\n");
    
    sb.append("    tripId: ").append(toIndentedString(tripId)).append("\n");
    sb.append("    coords: ").append(toIndentedString(coords)).append("\n");
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

