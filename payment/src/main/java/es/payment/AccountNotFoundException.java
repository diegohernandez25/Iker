package es.payment;

class AccountNotFoundException extends RuntimeException {

  AccountNotFoundException(Long id) {
    super("Could not find account with id " + id);
  }
}
