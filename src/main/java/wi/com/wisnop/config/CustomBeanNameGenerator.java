package wi.com.wisnop.config;

import org.springframework.beans.factory.annotation.AnnotatedBeanDefinition;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.BeanNameGenerator;

public class CustomBeanNameGenerator implements BeanNameGenerator {

	@Override
	public String generateBeanName(BeanDefinition definition, BeanDefinitionRegistry registry) {
		
		final String result;
		result = generateFullBeanName((AnnotatedBeanDefinition)definition);
		System.out.println(result);
		return result;
	}
	
	private String generateFullBeanName(final AnnotatedBeanDefinition definition) {
		return definition.getMetadata().getClassName();
	}
	
}