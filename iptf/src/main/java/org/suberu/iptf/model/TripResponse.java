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
 * TripResponse
 */
@Validated

public class TripResponse   {
  @JsonProperty("StartCoords")
  @Valid
  private List<Float> startCoords = new ArrayList<Float>();

  @JsonProperty("EndCoords")
  @Valid
  private List<Float> endCoords = new ArrayList<Float>();

  @JsonProperty("StartTime")
  private Boolean startTime = null;

  @JsonProperty("Date")
  private Float date = null;

  @JsonProperty("MaxDetour")
  private BigDecimal maxDetour = null;

  public TripResponse startCoords(List<Float> startCoords) {
    this.startCoords = startCoords;
    return this;
  }

  public TripResponse addStartCoordsItem(Float startCoordsItem) {
    this.startCoords.add(startCoordsItem);
    return this;
  }

  /**
   * Get startCoords
   * @return startCoords
  **/
  @NotNull


  public List<Float> getStartCoords() {
    return startCoords;
  }

  public void setStartCoords(List<Float> startCoords) {
    this.startCoords = startCoords;
  }

  public TripResponse endCoords(List<Float> endCoords) {
    this.endCoords = endCoords;
    return this;
  }

  public TripResponse addEndCoordsItem(Float endCoordsItem) {
    this.endCoords.add(endCoordsItem);
    return this;
  }

  /**
   * Get endCoords
   * @return endCoords
  **/
  @NotNull


  public List<Float> getEndCoords() {
    return endCoords;
  }

  public void setEndCoords(List<Float> endCoords) {
    this.endCoords = endCoords;
  }

  public TripResponse startTime(Boolean startTime) {
    this.startTime = startTime;
    return this;
  }

  /**
   * Get startTime
   * @return startTime
  **/
  @NotNull


  public Boolean isStartTime() {
    return startTime;
  }

  public void setStartTime(Boolean startTime) {
    this.startTime = startTime;
  }

  public TripResponse date(Float date) {
    this.date = date;
    return this;
  }

  /**
   * Get date
   * @return date
  **/
  @NotNull


  public Float getDate() {
    return date;
  }

  public void setDate(Float date) {
    this.date = date;
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
    return Objects.equals(this.startCoords, tripResponse.startCoords) &&
        Objects.equals(this.endCoords, tripResponse.endCoords) &&
        Objects.equals(this.startTime, tripResponse.startTime) &&
        Objects.equals(this.date, tripResponse.date) &&
        Objects.equals(this.maxDetour, tripResponse.maxDetour);
  }

  @Override
  public int hashCode() {
    return Objects.hash(startCoords, endCoords, startTime, date, maxDetour);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class TripResponse {\n");
    
    sb.append("    startCoords: ").append(toIndentedString(startCoords)).append("\n");
    sb.append("    endCoords: ").append(toIndentedString(endCoords)).append("\n");
    sb.append("    startTime: ").append(toIndentedString(startTime)).append("\n");
    sb.append("    date: ").append(toIndentedString(date)).append("\n");
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

