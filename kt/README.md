# keytool -list -v -keystore release.jks
# CN=wangli, OU=orangda, O=orangda, L=Guangzhou, ST=Guangdong, C=CN
keytool -genkey -keyalg RSA -alias orangda -keystore release.jks -storepass orangda -keypass orangda -validity 20000 -keysize 2048
# 

 keytool -exportcert -alias orangda -keystore release.jks | openssl sha1 -binary | openssl base64

