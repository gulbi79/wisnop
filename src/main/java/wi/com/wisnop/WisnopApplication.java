package wi.com.wisnop;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

import wi.com.wisnop.config.CustomBeanNameGenerator;

@SpringBootApplication
@ComponentScan(nameGenerator = CustomBeanNameGenerator.class)
public class WisnopApplication {

	public static void main(String[] args) {
		SpringApplication.run(WisnopApplication.class, args);
	}

}
