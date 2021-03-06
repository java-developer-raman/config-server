server:
  port: 8888
  ssl:
    enabled: true
    # If client auth is set to need, then and client which will connect to config server will also provide it's certificate already shared by config server with him
    #client-auth: need
    key-store: file:/home/config-server/app-conf/config-server-tls.jks
    # config-server
    key-store-password: <ssl-key-store-password>
    key-alias: config-server
    key-store-type: pkcs12
    # trust store will be used by config server to trust the client which can access it.
    # In my trust store I have added a trusted certificate of some another application
    trust-store: /home/config-server/app-conf/config-server-trust-store.jks
    # config-server
    trust-store-password: <ssl-trust-store-password>
    trust-store-type: pkcs12
# these settings are required to encrypt or decrypt data written in backend
encrypt:
  keyStore:
    #Path to key store files, Please copy all the files in resources/keystore directoryto some location and give full path here
    location: file:/home/config-server/app-conf/config-server-crypto.jks
    # config-server-crypto
    password: <encrypt-password>
    alias: config-server-crypto
    # config-server-crypto
    secret: <encrypt-secret>
spring:
  main:
    allow-bean-definition-overriding: true
  application:
    name: config-server
  security:
    #basic:
    #  enabled: true
    user:
      name: admin
      # plain password is : admin (Created via config-server-crypto.jks)
      password: '{cipher}AQAzxH9TduAAv9V365PJFAuzThf7H0idjbBPRnTrxg3DxN7MYVByMwq+GQ+X5vcrQ9hHJgetj9qI42LAJBr/1/hPC4c2k2ghO1TT2v6a5iECvwREZc6OveXiphOoi0fSvFJ9mU70QJLV7O3uFCG/8s1Qq/jPH9kZCkWv3EEIZVdQepX4NwL1oxBSLydO5bhxCx12fl3SdtHXLTl1xnx5nk8vazA/pXumdi4cj4yt2Ekwt9uytpkldWiKjVzOAJ30y+zMbCcwqbrFOOVm32lo0+qwS8eC+EJVVXCt5q975/vUhPcsc56h7t3q6LxOFlm53I8hgtB+DMaXda7fIsJv7anQnhp/U73zbhfZllHyq2xd439jtfQ21SebGhvizREmt3g='
  profiles:
    active: vault
  # settings for spring vault library to create connection with vault
  cloud:
    vault:
      port: 8300
      host: vault
      scheme: https
      authentication: CERT
      backend: secret
      ssl:
        # This keystore contains both private key and certificate required to login into VAULT via CERT
        #Path to vault-cert.pkcs12, Please copy all the files in resources/keystore directoryto some location and give full path here
        key-store: file:/home/config-server/app-conf/vault-cert.pkcs12
        # vault-cert
        key-store-password: <vault-key-store-password>
        cert-auth-path: cert
      kv-version: 1
    # settings for config server to connect to create connection with vault and authenticating via CERT
    config:
      server:
        vault:
          port: 8300
          host: vault
          scheme: https
          authentication: CERT
          backend: secret
          ssl:
            # This keystore contains both private key and certificate required to login into VAULT via CERT
            key-store: file:/home/config-server/app-conf/vault-cert.pkcs12
            key-store-password: <vault-key-store-password>
            cert-auth-path: cert
          kv-version: 1