package es.payment;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Data
@Entity
class Account {

  private @Id @GeneratedValue Long id;
  private int globalID;
  private String name;
  private String address;
  private double balance;

  Account() {}

  Account(int globalID, String name, String address, double balance) {
    this.name = name;
    this.address = address;
    this.balance = balance;
  }
}
