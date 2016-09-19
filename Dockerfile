FROM tomcat:jre8

MAINTAINER Jimmy Shen <shendepu@hotmail.com>

ADD mysql-connector-java-5.1.38-bin.jar $CATALINA_HOME/lib/mysql-connector-java-5.1.38-bin.jar

RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends libtcnative-1 xmlstarlet netcat \
    && apt-get clean

ADD java /usr/local/java
ADD moqui-plus-runtime.war $CATALINA_HOME/webapps/ROOT.war

RUN set -x \
		&& cd $CATALINA_HOME/webapps \
		&& rm -Rf ROOT \
		&& unzip -q -d ROOT ROOT.war

COPY "docker-entrypoint.sh" "/"
COPY "wait" "/"

ENV JAVA_HOME /usr/local/java

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8080 8081
CMD ["catalina.sh", "run"]
