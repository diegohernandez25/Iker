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

/*
 * TripResponse
 */
@Validated

public class TripResponse{
  @JsonProperty(required=true,value="Coords")
  @Valid
  private List<List<Float>> coords = new ArrayList<>();

  @JsonProperty(required=true,value="StartTime")
  private Long startTime = null;

  @JsonProperty(required=true,value="EndTime")
  private Long endTime = null;

  @JsonProperty(required=true,value="MaxDetour")
  private BigDecimal maxDetour = null;

  public TripResponse coords(List<List<Float>> coords) {
    this.coords = coords;
    return this;
  }

  public List<List<Float>> getCoords() {
    return coords;
  }

  public void setCoords(List<List<Float>> coords) {
    this.coords = coords;
  }

  public TripResponse startTime(Long startTime) {
    this.startTime = startTime;
    return this;
  }

  /**
   * Get startTime
   * @return startTime
  **/
  @NotNull


  public void setStartTime(Long startTime) {
    this.startTime = startTime;
  }



  public Long getEndTime() {
    return endTime;
  }

  public void setEndTime(Long date) {
    this.endTime = date;
  }

  public TripResponse maxDetour(BigDecimal maxDetour) {
    this.maxDetour = maxDetour;
    return this;
  }

  /**
   * Get maxDetour
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
    TripResponse tripResponse = (TripResponse) o;
    return Objects.equals(this.coords, tripResponse.coords) &&
        Objects.equals(this.startTime, tripResponse.startTime) &&
        Objects.equals(this.endTime, tripResponse.endTime) &&
        Objects.equals(this.maxDetour, tripResponse.maxDetour);
  }

  @Override
  public int hashCode() {
    return Objects.hash(coords, startTime, endTime, maxDetour);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class TripResponse {\n");
    
    sb.append("    coords: ").append(toIndentedString(coords)).append("\n");
    sb.append("    startTime: ").append(toIndentedString(startTime)).append("\n");
    sb.append("    date: ").append(toIndentedString(endTime)).append("\n");
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

