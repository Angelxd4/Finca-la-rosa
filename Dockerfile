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

# Configuramos Tomcat para que confíe en el proxy HTTPS de Railway (Soluciona el error de redirección a HTTP)
RUN sed -i 's/<\/Host>/<Valve className="org.apache.catalina.valves.RemoteIpValve" remoteIpHeader="x-forwarded-for" protocolHeader="x-forwarded-proto" \/><\/Host>/g' /usr/local/tomcat/conf/server.xml

EXPOSE 8080
CMD ["catalina.sh", "run"]