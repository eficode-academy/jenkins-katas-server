FROM jenkins/jenkins:lts
LABEL maintainer="sofus.albertsen@eficode.com"

USER root
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
RUN usermod -aG docker jenkins
RUN  curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
ENV JENKINS_HOME=/var/jenkins_home
ARG JAVA_OPTS
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"
#Env for JCasc
ENV CASC_JENKINS_CONFIG=/var/jenkins_config
COPY casc-config /var/jenkins_config
USER jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
EXPOSE 8080
EXPOSE 50000
