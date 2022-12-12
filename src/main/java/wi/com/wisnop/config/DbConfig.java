package wi.com.wisnop.config;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

@Configuration
@MapperScan(basePackages="wi.com.wisnop.dao", sqlSessionFactoryRef="sqlSessionFactory1", nameGenerator = CustomBeanNameGenerator.class)/*멀티DB사용시 mapper클래스파일 스켄용 basePackages를 DB별로 따로설정*/
@EnableTransactionManagement
public class DbConfig {

    @Bean(name="dataSource1")
    @Primary
    @ConfigurationProperties(prefix="spring.datasource1") //appliction.properties 참고.
    public DataSource db1DataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name="sqlSessionFactory1")
    @Primary
    public SqlSessionFactory sqlSessionFactory(@Qualifier("dataSource1") DataSource dataSource, ApplicationContext applicationContext) throws Exception{
        final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);
        sessionFactory.setConfigLocation(applicationContext.getResource("classpath:mybatis/config/mybatis-config.xml")); //mybatis config.xml 설정
        sessionFactory.setMapperLocations(applicationContext.getResources("classpath:mybatis/query/**/*.xml")); //쿼리작성용 mapper.xml위치 설정.
        return sessionFactory.getObject();
    }

    @Bean(name="mySqlsqlSessionTemplate")
    @Primary
    public SqlSessionTemplate sqlSessionTemplate(@Qualifier("sqlSessionFactory1") SqlSessionFactory sqlSessionFactory) throws Exception{
        return new SqlSessionTemplate(sqlSessionFactory);
    }

    @Bean(name = "transactionManager1")
    @Primary
    public PlatformTransactionManager transactionManager(@Qualifier("dataSource1") DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }
}