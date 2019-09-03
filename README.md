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
3. Run ConfigServerApplication