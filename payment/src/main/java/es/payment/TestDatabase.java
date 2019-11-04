package es.payment;

import lombok.extern.slf4j.Slf4j;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDate;

@Configuration
@Slf4j
class TestDatabase{

  @Bean
  CommandLineRunner initDatabase(AccountRepository account_repository, TransactionRepository transaction_repository) {
    return args -> {
      log.info("Preloading " + account_repository.save(new Account(1, "Diogo Pinho", "Rua Ciudad Rodrigo, nº 1327", 2310.50)));
      log.info("Preloading " + account_repository.save(new Account(2, "Frederico Pereira", "Avenida das Tílias, nº 20", 4201.20)));
      log.info("Preloading " + transaction_repository.save(new Transaction(1, 2, "Ovos", 2310.50, "Completed", LocalDate.now())));
      log.info("Preloading " + transaction_repository.save(new Transaction(2, 1, "Bananas", 4201.20, "Completed", LocalDate.now())));
    };
  }
}
