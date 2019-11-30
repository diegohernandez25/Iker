package es.payment;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import java.time.LocalDate;

@Data
@Entity
class Transaction {

  private @Id @GeneratedValue Long ttoken;
  //private @Id Long ttoken;
  private String sourceID;
  private String targetID;
  private String briefDescription;
  private double amount;
  private String status;
  private LocalDate date;


  Transaction() {}

  Transaction(String sourceID, String targetID, String briefDescription, double amount, String status, LocalDate date) {
    //this.ttoken = ttoken;
    this.sourceID = sourceID;
    this.targetID = targetID;
    this.briefDescription = briefDescription;
    this.amount = amount;
    this.status = status;
    this.date = date;
  }

}
