package es.payment;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
class TransactionController {

  private final TransactionRepository repository;

  TransactionController(TransactionRepository repository) {
    this.repository = repository;
  }

  // Aggregate root

  @GetMapping("/transactions")
  List<Transaction> all() {
    return repository.findAll();
  }

  @PostMapping("/payment")
  Transaction newTransaction(@RequestBody Transaction newTransaction) {
    return repository.save(newTransaction);
  }

  // Single items

  @GetMapping("/transactions/{id}")
  Transaction one(@PathVariable Long id) {

    return repository.findById(id)
      .orElseThrow(() -> new TransactionNotFoundException(id));
  }

  @PutMapping("/transactions/{id}")
  Transaction replaceTransaction(@RequestBody Transaction newTransaction, @PathVariable Long id) {

    return repository.findById(id)
      .map(transaction -> {
        transaction.setSourceID(newTransaction.getSourceID());
        transaction.setTargetID(newTransaction.getTargetID());
        transaction.setBriefDescription(newTransaction.getBriefDescription());
        transaction.setAmount(newTransaction.getAmount());
        transaction.setStatus(newTransaction.getStatus());
        transaction.setDate(newTransaction.getDate());
        return repository.save(transaction);
      })
      .orElseGet(() -> {
        newTransaction.setId(id);
        return repository.save(newTransaction);
      });
  }

  @DeleteMapping("/transactions/{id}")
  void deleteTransaction(@PathVariable Long id) {
    repository.deleteById(id);
  }
}
