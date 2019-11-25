package es.payment;

import java.util.List;
import java.time.LocalDate;
import java.text.SimpleDateFormat;

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
  private final AccountRepository accounts;

  TransactionController(TransactionRepository repository, AccountRepository accounts) {
    this.repository = repository;
    this.accounts = accounts;
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

  @GetMapping("/transactions/{ttoken}")
  Transaction one(@PathVariable Long ttoken) {

    return repository.findById(ttoken)
      .orElseThrow(() -> new TransactionNotFoundException(ttoken));
  }

  @PutMapping("/transactions/{ttoken}")
  Transaction replaceTransaction(@RequestBody Transaction newTransaction, @PathVariable Long ttoken) {

    return repository.findById(ttoken)
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
        newTransaction.setTtoken(ttoken);
        return repository.save(newTransaction);
      });
  }

  @DeleteMapping("/transactions/{ttoken}")
  void deleteTransaction(@PathVariable Long ttoken) {
    repository.deleteById(ttoken);
  }

  // Real usage

  @PostMapping("/delayedPayment")
  Transaction newFromPay(@RequestBody Transaction newTransaction) {
    newTransaction.setSourceID(-1);
    newTransaction.setStatus("Pending");
    newTransaction.setDate(LocalDate.now());
    return repository.save(newTransaction);
  }

  @PostMapping("/completePayment")
  Transaction newGetPay(@RequestBody Transaction newTransaction) {
    newTransaction.setStatus("Complete");
    newTransaction.setDate(LocalDate.now());
    boolean found = false;
    // TODO: Adicionar/Retirar do amount das contas
    List<Account> all_accounts = accounts.findAll();
    Account account_info = all_accounts.get(0);
    // Taking money out
    for (int i = 0; i < all_accounts.size(); i++) {
         if(newTransaction.getSourceID() == all_accounts.get(i).getId()){
           found = true;
           account_info = all_accounts.get(i);
           break;
         }
    }
    if(found == true){
      account_info.setBalance(account_info.getBalance() - newTransaction.getAmount());
    }
    found = false;
    // Receiving money in
    for (int i = 0; i < all_accounts.size(); i++) {
         if(newTransaction.getTargetID() == all_accounts.get(i).getId()){
           found = true;
           account_info = all_accounts.get(i);
           break;
         }
    }
    if(found == true){
      account_info.setBalance(account_info.getBalance() + newTransaction.getAmount());
    }

    return repository.save(newTransaction);
  }
}
