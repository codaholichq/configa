package configa;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

@SpringBootApplication
@EnableConfigServer
//@ConditionalOnProperty(value = "spring.thread-executor", havingValue = "virtual")
public class Application {

//	@Bean
//	public AsyncTaskExecutor asyncTaskExecutor() {
//		return new TaskExecutorAdapter(Executors.newVirtualThreadPerTaskExecutor());
//	}
//
//	@Bean
//	public TomcatProtocolHandlerCustomizer<?> protocolHandlerCustomizer() {
//		return protocolHandler -> protocolHandler.setExecutor(Executors.newVirtualThreadPerTaskExecutor());
//	}

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

}
