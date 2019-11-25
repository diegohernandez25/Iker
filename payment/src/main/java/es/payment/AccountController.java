package es.payment;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
class AccountController {

  private final AccountRepository repository;

  AccountController(AccountRepository repository) {
    this.repository = repository;
  }

  // Aggregate root

  @GetMapping("/accounts")
  List<Account> all() {
    return repository.findAll();
  }

  @PostMapping("/accounts")
  Account newAccount(@RequestBody Account newAccount) {
    return repository.save(newAccount);
  }

  // Single item

  @GetMapping("/accounts/{id}")
  Account one(@PathVariable long globalID) {

    return repository.findById(globalID)
      .orElseThrow(() -> new AccountNotFoundException(globalID));
  }

  @PutMapping("/accounts/{id}")
  Account replaceAccount(@RequestBody Account newAccount, @PathVariable long globalID) {

    return repository.findById(globalID)
      .map(account -> {
        account.setGlobalID(newAccount.getGlobalID());
        account.setName(newAccount.getName());
        account.setName(newAccount.getName());
        account.setBalance(newAccount.getBalance());
        account.setPassword(newAccount.getPassword());
        account.setEmail(newAccount.getEmail());
        return repository.save(account);
      })
      .orElseGet(() -> {
        newAccount.setId(globalID);
        return repository.save(newAccount);
      });
  }

  @DeleteMapping("/account/{id}")
  void deleteAccount(@PathVariable long globalID) {
    repository.deleteById(globalID);
  }

  // Single item

  @GetMapping("/account_search")
  Account emailSearch(@RequestParam String email){

    List<Account> all_accounts = repository.findAll();
    for (int i = 0; i < all_accounts.size(); i++) {
         if(email.equals(all_accounts.get(i).getEmail())){
           return all_accounts.get(i);
         }
    }
    return null;
  }
}
