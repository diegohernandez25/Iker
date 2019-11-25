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
  private String email;
  private String password;
  private String address;
  private double balance;

  Account() {}

  Account(String name, String email, String password, String address, double balance) {
    this.name = name;
    this.password = password;
    this.email = email;
    this.address = address;
    this.balance = balance;
  }
}
