# An ARG declared before a FROM is outside of a build stage, so it can’t be used in any instruction after a FROM, And also it should be the first instruction
ARG JDK_VERSION=8-jre-alpine
# Taking only JRE, As alpine image for JDK is heavier,
FROM openjdk:${JDK_VERSION}

# User docker inspect <container id> to view labels
LABEL "author"="Raman Sharma"
LABEL "App Name"="config-server"


RUN apk --no-cache add curl

RUN adduser --disabled-password config-server

USER config-server

EXPOSE 8888

# With build argument we can decide which config server jar needs to be copied
ARG CONFIG_SERVER_VERSION

# Creating environment variable so that we can inspect, what is the version of config server running in container
# Making it same as build argument, If at build time variable is not set it's default value will be taken.
ENV CONFIG_SERVER_VERSION=${CONFIG_SERVER_VERSION:-1.0.0-SNAPSHOT}
# Making prompt bit nicer
ENV PS1="\h:\w# " PS2=">> "

WORKDIR /home/config-server

RUN mkdir -p ./app-conf/test \
    && mkdir -p ./app-conf/dev

COPY docker/*.sh ./
COPY docker/config-server-vault-application.yml.tpl ./app-conf/


COPY docker/test/* ./app-conf/test/
COPY docker/dev/* ./app-conf/dev/

COPY build/libs/config-server-${CONFIG_SERVER_VERSION:-1.0.0-SNAPSHOT}.jar ./config-server.jar
CMD ["./main-process.sh"]
#CMD ["java", "-Dspring.config.location=file:/home/config-server/app-conf/config-server-vault-application.yml", "-Dlogging.config=/home/config-server/app-conf/logback.xml", "-jar", "/home/config-server/config-server.jar"]

# Disabling health check, because we will use spring-boot actualtors to do health check
# HEALTHCHECK --interval=1m --timeout=3s CMD curl -f https://localhost:8888/ || exit 1

# Create image
# sudo docker build --tag=ramansharma/config-server:v1.0.0 --build-arg CONFIG_SERVER_VERSION=1.0.0-SNAPSHOT .

# Push image
# sudo docker push ramansharma/config-server:v1.0.0

# Run container
# sudo docker run -p 8888:8888 --mount type=bind,src=/home/raman/programs/servers/app-conf/config-server,destination=/home/config-server/app-conf,readonly --rm ramansharma/config-server:v1.0.0

# Load apparmor profile
# sudo apparmor_parser -r -W config-server-apparmor

# Run container with apparmor profile
# sudo docker run -p 8888:8888 --security-opt "apparmor=config-server-apparmor" --mount type=bind,src=/home/raman/programs/servers/app-conf/config-server,destination=/home/config-server/app-conf,readonly --rm ramansharma/config-server:v1.0.0

# Check config server
# https://localhost:8888/einwohner-1.0-SNAPSHOT/dev