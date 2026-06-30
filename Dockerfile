# Etapa 1: Construcción (Build) con Maven y Java 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copiamos el pom.xml y descargamos dependencias
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiamos el código fuente y compilamos
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Servidor (Despliegue) con Tomcat
FROM tomcat:10.1-jdk21

# Limpiamos apps por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiamos el WAR a ROOT para que abra en la página principal
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Configuramos Tomcat para que asuma HTTPS en todo momento, y confíe en el proxy de Railway
RUN sed -i 's/<Connector port="8080" protocol="HTTP\/1.1"/<Connector port="8080" protocol="HTTP\/1.1" scheme="https" secure="true" proxyPort="443"/g' /usr/local/tomcat/conf/server.xml
RUN sed -i 's/<\/Host>/<Context docBase="\/app\/uploads" path="\/uploads" \/><Valve className="org.apache.catalina.valves.RemoteIpValve" remoteIpHeader="x-forwarded-for" protocolHeader="x-forwarded-proto" \/><\/Host>/g' /usr/local/tomcat/conf/server.xml

# Creamos el directorio de uploads
RUN mkdir -p /app/uploads && chmod 777 /app/uploads

EXPOSE 8080
CMD ["catalina.sh", "run"]