# Taking only JRE, As alpine image for JDK is heavier,
FROM openjdk:8-jre-alpine
RUN adduser -D config-server
USER config-server
EXPOSE 8888
COPY build/libs/config-server-*.jar config-server.jar
CMD ["java", "-Dspring.config.location=file:/home/config-server/app-conf/config-server-vault-application.yml", "-Dlogging.config=/home/config-server/app-conf/logback.xml", "-jar", "/config-server.jar"]
