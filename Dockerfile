FROM jenkins:1.651.1
MAINTAINER Lenming Yeung (lenming.yeung@gmail.com)
USER root

# download wget
RUN apt-get install -y wget

# download apache-maven-3.3.9
RUN wget --no-verbose -O /tmp/apache-maven-3.3.9.tar.gz http://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
RUN echo "516923b3955b6035ba6b0a5b031fbd8b /tmp/apache-maven-3.3.9.tar.gz" | md5sum -c
RUN mkdir -p /opt/maven
RUN tar xzf /tmp/apache-maven-3.3.9.tar.gz -C /opt/maven
RUN rm -rf /opt/maven/maven-3.3.9
RUN mv /opt/maven/apache-maven-3.3.9 /opt/maven/maven-3.3.9
RUN rm -f /usr/local/bin/mvn
RUN ln -s /opt/maven/maven-3.3.9/bin/mvn /usr/local/bin/mvn
RUN rm -f /tmp/apache-maven-3.3.9.tar.gz
ENV MAVEN_HOME /opt/maven/maven-3.3.9

ENV java_version 1.8.0_91
ENV jdk_filename jdk-8u91-linux-x64.tar.gz
ENV downloadlink http://download.oracle.com/otn-pub/java/jdk/8u91-b14/$jdk_filename
RUN wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O /tmp/$jdk_filename $downloadlink 
ENV java_oracle_path /opt/java-oracle
RUN echo $java_oracle_path
RUN mkdir -p $java_oracle_path && tar -zxf /tmp/$jdk_filename -C $java_oracle_path/
RUN chown -R "root:root" $java_oracle_path/jdk$java_version
ENV JAVA_HOME $java_oracle_path/jdk$java_version
ENV PATH $JAVA_HOME/bin:$PATH
RUN update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 20000 && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 20000

#RUN mkdir -p /var/jenkins_home
#RUN chown -R "jenkins:jenkins" /var/jenkins_home

USER jenkins
