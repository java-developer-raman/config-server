package com.sharma.config.server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.env.YamlPropertySourceLoader;
import org.springframework.cloud.config.server.EnableConfigServer;
import org.springframework.core.env.MapPropertySource;
import org.springframework.core.env.PropertySource;
import org.springframework.core.io.UrlResource;

import java.io.IOException;
import java.util.List;
import java.util.Map;
@EnableConfigServer
@SpringBootApplication
public class ConfigServerApplication {

    public static void main(String[] args) throws IOException {
        setUpTrustStoreForApplication();
        SpringApplication.run(ConfigServerApplication.class, args);
    }

    /**
     * In spring application trust store information is set via properties javax.net.ssl.trustStore rather than from server.ssl.trust-store available in application properties
     * So there are two options to set these properties
     * 1.either via -Djavax.net.ssl.trustStore during application run
     * 2. or via this second option I made it specially
     * 3. Or may be there is some another way in spring to do that, only condition is to load ssl config before application loads trustore
     * <p>
     * Reason of not taking first option is to avoid sharing password at the time of creating docker image
     *
     * @throws IOException
     */
    private static void setUpTrustStoreForApplication() throws IOException {
        YamlPropertySourceLoader loader = new YamlPropertySourceLoader();
        List<PropertySource<?>> applicationYamlPropertySource = loader.load(
                "config-application-properties", new UrlResource(System.getProperty("spring.config.location")));
        Map<String, Object> source = ((MapPropertySource) applicationYamlPropertySource.get(0)).getSource();
        System.setProperty("javax.net.ssl.trustStore", source.get("server.ssl.trust-store").toString());
        System.setProperty("javax.net.ssl.trustStorePassword", source.get("server.ssl.trust-store-password").toString());
    }
}
