FROM jenkins/jenkins:lts

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

USER root

RUN apt-get update \
    && apt-get install --yes git \
    && cd /usr/local/share \
    && git clone --depth=1 https://github.com/coreycb/bom-jjb-config.git \
    && cd bom-jjb-config \
    && cp config.xml /usr/share/jenkins/ref/config.xml \
    && cp proxy.xml /usr/share/jenkins/ref/proxy.xml \
    && cp security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy \
    && cp plugins.txt /usr/share/jenkins/ref/plugins.txt
    #&& cp proxy.xml /var/jenkins_home/proxy.xml \

USER jenkins

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER root

RUN cp /usr/local/share/bom-jjb-config/config.xml /var/jenkins_home/config.xml

USER jenkins
