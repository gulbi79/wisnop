package wi.com.wisnop;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

//@ComponentScan(nameGenerator = CustomBeanNameGenerator.class)
//@EnableAutoConfiguration
//@ComponentScan(excludeFilters = { @Filter(type = FilterType.CUSTOM, classes = TypeExcludeFilter.class),
//		@Filter(type = FilterType.CUSTOM, classes = AutoConfigurationExcludeFilter.class) })
@SpringBootApplication
public class WisnopApplication {

	public static void main(String[] args) {
		SpringApplication.run(WisnopApplication.class, args);
	}

}
