# Config Server

Config Server created through spring cloud config to manage configuarions in a centralized manner.

How to make Config server secure
================================
1. Download Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files 8.
2. Replace the 2 policy files in the JRE lib/security directory with the ones that you downloaded.
3. Create an RSA key pair
4. Set the properties in bootstarp.yaml
    
Config Server
-------------
1. Create keypairs for config-server
 keytool -genkeypair -alias config-server -keyalg RSA -keysize 2048 -storetype pkcs12 -keystore config-server.jks
 Password: config-server
2. Create public certificate
 keytool -export -alias config-server -file config-server.crt -keystore config-server.jks
3. Import einwohner certificate into config-server trust store
 keytool -import -alias einwohner -file einwohner.crt -keystore config-server.jks
4. Create RSA pair for encryption and decryption
  keytool -genkeypair -alias config-server-crypto -keyalg RSA -keysize 2048 -storetype pkcs12 -keystore config-server-crypto.jks
  Password: config-server-crypto

How to run Config-server Application
=====================================
1. Copy all files in resources/keystore to any directory
2. And Change bootstrap.yml with path e.g. key-store:
3. Run ConfigServerApplication with following parameters -Dspring.config.location=file:/home/raman/programs/servers/app-conf/config-server/config-server-vault-application.yml

How to run executable jar
=========================
1. Eithe do export JAVA_OPTS="-Dspring.config.location=file:/home/raman/programs/servers/app-conf/config-server/config-server-vault-application.yml"
2. Or make a file with jarName.conf e.g. config-server-1.0-SNAPSHOT.conf with above java opts JAVA_OPTS="-Dpropertykey=propvalue" 
5. And then run ./build/libs/config-server-1.0-SNAPSHOT.jar

How to build and run Docker image
=================================
1. sudo docker build --tag=ramansharma/config-server:v1.0.0 .
2. sudo apparmor_parser -r -W config-server-apparmor
3. sudo docker run -p 8888:8888 --security-opt "apparmor=config-server-apparmor" --name config-server --mount type=bind,src=/home/raman/programs/servers/app-conf/config-server/secrets,destination=/home/config-server/secrets,readonly --mount type=bind,src=/home/raman/programs/servers/host.properties,destination=/home/config-server/host/host.properties,readonly --mount type=bind,src=/home/raman/programs/servers/app-logs/config-server,destination=/home/config-server/app-logs --rm ramansharma/config-server:v1.0.0
4. https://localhost:8888/einwohner-1.0-SNAPSHOT/dev, https://localhost:8888/actuator/health

Push Image to repo
==================
1. sudo docker login
2. sudo docker push ramansharma/config-server:v1.0.0


Working of Config Server
========================

Config server is a spring boot application, which is responsible for providing properties to other application. So all other applications will store thier
environment (dev/test/prod) specific properties in Hashi corp vault. And during the startup of application, these applications will load their configuration
properties from config-server. Config server will contact Hashhi-corp vault and send back the related configuration over secured https channel in encrypted form.

So here are the basic features
1. Return application specific properties over https vai REST API.
2. Encrypt or decrypt the string over REST API using Hashicorp's encryption and decryption methods.

Config server is a docker containerized application, which just need the environment e.g. dev/test/prod. When you start the container you need to mount
two directories and one file e.g.

- host.properties (which contains a key value pair e.g. env=dev, based upon which container knows what kind of environment is it.)
- logs directory (where config server will store logs)
- secrets directory (where secret or passwords are stored. It is recommended to mount it using tmpfs rather than using physical directory on host machine)

Step by step startup procedure
==============================
1. Check the environment
2. Build up the application properties with values from secrets
3. Start the java application
4. Remove all the application properties and secrets, after application is ready so that nobody can see the prperties even if somebody hack the container.

Steps taken to make it secure
=============================
1. All the communication is done via Two way SSL. Any Host want to access config-server should be in it's trust store.
2. Secret information is encrypted in rest-api response with crypto keys from Hashi corp vault
3. All the sensitive information gets removed automatically from container after it is ready.
4. Intercation between Hashi corp vault and java application is done through ssl keys via vault-cert-authentication method.
5. To access any Rest-API basic authentication is required.
6. Container's security is tightened through App Armor, to restrict access to any unwanted directories and so on.
7. secrets to application container are passed through tmpfs. 

