# Taking only JRE, As alpine image for JDK is heavier,
FROM openjdk:8-jre-alpine
EXPOSE 8888
COPY build/libs/config-server-*.jar config-server.jar
CMD ["java", "-Dspring.config.location=file:/home/app-conf/config-server-vault-application.yml", "-jar", "/config-server.jar"]
