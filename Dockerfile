# Stage 1: Build Stage
# Changed from openjdk:11 to eclipse-temurin:11
FROM eclipse-temurin:11-jdk AS BUILD_IMAGE
RUN apt update && apt install maven -y
COPY ./ vprofile-project
RUN cd vprofile-project && mvn install 

# Stage 2: Deployment Stage
# Changed from tomcat:9-jre11 to tomcat:9-jdk11-temurin (more reliable)
FROM tomcat:9-jdk11-temurin
LABEL "Project"="Vprofile"
LABEL "Author"="Imran"

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD_IMAGE vprofile-project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
