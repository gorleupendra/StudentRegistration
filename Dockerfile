# Use an official Tomcat 10.1 image with JDK 17
FROM tomcat:10.1-jdk17-temurin

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy custom server.xml to disable shutdown port
COPY server.xml /usr/local/tomcat/conf/server.xml

# Copy your WAR file and rename it to ROOT.war
COPY StudentRegistration.war /usr/local/tomcat/webapps/ROOT.war

# Expose the standard Tomcat port
EXPOSE 8080

# The base image already has the CMD to start Tomcat