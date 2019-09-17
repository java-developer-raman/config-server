FROM alpine:3.10.2
RUN apk update && apk upgrade && apk add bash
COPY build/libs/config-server-1.0-SNAPSHOT.jar config-server.jar
CMD ["/config-server.jar"]
#COPY build/libs/config-server-*.jar config-server.jar
#ENTRYPOINT ["java", "-Dspring.config.location=file:/home/app-conf/config-server-vault-application.yml", "-jar", "config-server.jar"]