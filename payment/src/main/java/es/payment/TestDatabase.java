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
      log.info("Preloading " + account_repository.save(new Account("Diogo Pinho", "dogopinho@uff.pt", "1234", "Rua Ciudad Rodrigo, nº 1327", 2310.50)));
      log.info("Preloading " + account_repository.save(new Account("Frederico Pereira", "fradboy@senpai.jp","1234", "Avenida das Tílias, nº 20", 4201.20)));
      log.info("Preloading " + transaction_repository.save(new Transaction("dogopinho@uff.pt", "fradboy@senpai.jp", "Ovos", 2310.50, "Completed", LocalDate.now())));
      log.info("Preloading " + transaction_repository.save(new Transaction("fradboy@senpai.jp", "dogopinho@uff.pt", "Bananas", 4201.20, "Pending", LocalDate.now())));
    };
  }
}
