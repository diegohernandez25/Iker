package es.payment;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;
import java.util.List;

@Controller
class ShopController {

    // TODO: Páginas de erro para dar redirect para lá
    private final TransactionRepository transaction_repo;
    private final AccountRepository account_repo;

    ShopController(AccountRepository account_repo, TransactionRepository transaction_repo) {
      this.account_repo = account_repo;
      this.transaction_repo = transaction_repo;
    }


    // Sign In

    @GetMapping("/sign_in")
    public String sign_in(@RequestParam(name="token", required=true, defaultValue="Invalid") String name, @RequestParam(name="error", required=true, defaultValue="false") String error, Model model) {
        Optional<Transaction> o_transaction_info = transaction_repo.findById(Long.parseLong(name));
        if(!o_transaction_info.isPresent()){
          // Error screen com transaction inválida
          System.out.println("Found empty tokens");
          return "redirect:/invalid";
        }
        Transaction transaction_info = o_transaction_info.get();
        if(!(transaction_info.getStatus().equals("Pending"))){
          // Error screen com transaction inválida
          System.out.println("Found wrong token status");
          return "redirect:/invalid";
        }
        if(error.equals("true")){
          model.addAttribute("error", "Account not found or password invalid");
        }
        model.addAttribute("login", new Login());
        model.addAttribute("token_value", name);
        model.addAttribute("token_value2", "/sign_up?token=" + name);
        return "log";
    }

    @PostMapping("/sign_in")
    public String sign_inSubmit(@ModelAttribute Login login, RedirectAttributes redirectAttributes) {
        boolean found = false;
        List<Account> all_accounts = account_repo.findAll();
        Account account_info = all_accounts.get(0);
        for (int i = 0; i < all_accounts.size(); i++) {
			       if(login.getId().equals(all_accounts.get(i).getEmail())){
               found = true;
               account_info = all_accounts.get(i);
               break;
             }
		    }
        if(found == false || !(account_info.getPassword().equals(login.getPass()))){
          System.out.println("Account or password incorrect");
          redirectAttributes.addAttribute("token", login.getTtoken());
          redirectAttributes.addAttribute("error", "true");
          return "redirect:/sign_in";
        }

        redirectAttributes.addAttribute("token", login.getTtoken());
        redirectAttributes.addAttribute("account", account_info.getId());
        return "redirect:/confirm";
    }

    // Confirmation
    @GetMapping("/confirm")
    public String confirm(@RequestParam(name="token", required=true, defaultValue="Invalid") String name, @RequestParam(name="account", required=true, defaultValue="Invalid") String id, Model model) {
        Optional<Transaction> o_transaction_info = transaction_repo.findById(Long.parseLong(name));
        Transaction transaction_info = o_transaction_info.get();
        model.addAttribute("price", transaction_info.getAmount() + "€");
        model.addAttribute("token_value", name);
        model.addAttribute("account_id", id);
        return "confirm";
    }

    @PostMapping("/confirm")
    public String confirmSubmit(@ModelAttribute Login login, RedirectAttributes redirectAttributes) {
        redirectAttributes.addAttribute("token", login.getTtoken());
        redirectAttributes.addAttribute("account", login.getId());
        return "redirect:/done";
    }

    // Final
    @GetMapping("/done")
    public String done(@RequestParam(name="token", required=true, defaultValue="Invalid") String name, @RequestParam(name="account", required=true, defaultValue="Invalid") String id, Model model) {
        Optional<Transaction> o_transaction_info = transaction_repo.findById(Long.parseLong(name));
        Transaction transaction_info = o_transaction_info.get();
        Account account_i = account_repo.findById(Long.parseLong(id)).get();
        transaction_info.setStatus("Completed");
        transaction_info.setSourceID(account_i.getEmail());
        transaction_repo.save(transaction_info);

        // TODO: Adicionar/Retirar do amount das contas
        boolean found = false;
        List<Account> all_accounts = account_repo.findAll();
        Account account_info = all_accounts.get(0);
        // Taking money out
        for (int i = 0; i < all_accounts.size(); i++) {
             if(transaction_info.getSourceID().equals(all_accounts.get(i).getEmail())){
               found = true;
               account_info = all_accounts.get(i);
               break;
             }
        }
        if(found == true){
          account_info.setBalance(account_info.getBalance() - transaction_info.getAmount());
        }
        found = false;
        // Receiving money in
        for (int i = 0; i < all_accounts.size(); i++) {
             if(transaction_info.getTargetID().equals(all_accounts.get(i).getEmail())){
               found = true;
               account_info = all_accounts.get(i);
               break;
             }
        }
        if(found == true){
          account_info.setBalance(account_info.getBalance() + transaction_info.getAmount());
        }

        transaction_repo.save(transaction_info);


        return "final";
    }

    // Sign Up
    @GetMapping("/sign_up")
    public String sign_up(@RequestParam(name="token", required=true, defaultValue="Invalid") String name, Model model) {
        model.addAttribute("login", new Login());
        model.addAttribute("token_value", name);
        return "register";
    }

    @PostMapping("/sign_up")
    //TODO: Verify if account already exists and improve the checkboxes values
    public String sign_upButton(@ModelAttribute Login login, RedirectAttributes redirectAttributes) {
      account_repo.save(new Account(login.getUser(), login.getId(), login.getPass(), login.getAddress(), 0));
      redirectAttributes.addAttribute("token", login.getTtoken());
      return "redirect:/sign_in";
    }


    // Error screen
    @GetMapping("/invalid")
    public String invalid(@RequestParam(name="token", required=true, defaultValue="Invalid") String name, Model model) {
        return "invalid";
    }

}
