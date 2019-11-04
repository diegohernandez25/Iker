package es.payment;

class TransactionNotFoundException extends RuntimeException {

  TransactionNotFoundException(Long id) {
    super("Could not find transaction with id " + id);
  }
}
