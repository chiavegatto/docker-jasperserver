FROM tomcat:7

ENV JASPERSERVER_VERSION 6.4.3
ENV JASPER_WEBSERVICE_PLUGIN 1.5
ENV HTMLCOMPONENT_VERSION 5.0.1

RUN wget "https://sourceforge.net/projects/jasperserver/files/JasperServer/JasperReports%20Server%20Community%20Edition%20${JASPERSERVER_VERSION}/TIB_js-jrs-cp_${JASPERSERVER_VERSION}_bin.zip/download" \
         -O /tmp/jasperserver.zip  && \
    unzip /tmp/jasperserver.zip -d /usr/src/ && \
    rm /tmp/jasperserver.zip && \
    mv /usr/src/jasperreports-server-cp-${JASPERSERVER_VERSION}-bin /usr/src/jasperreports-server && \
    rm -r /usr/src/jasperreports-server/samples

ADD wait-for-it.sh /wait-for-it.sh
ADD entrypoint.sh /entrypoint.sh
ADD drivers/db2jcc4.jar /usr/src/jasperreports-server/buildomatic/conf_source/db/app-srv-jdbc-drivers/db2jcc4.jar
ADD drivers/mysql-connector-java-5.1.46-bin.jar /usr/src/jasperreports-server/buildomatic/conf_source/db/app-srv-jdbc-drivers/mysql-connector-java-5.1.46-bin.jar
ADD web.xml /usr/local/tomcat/conf/
ADD validation.properties /validation.properties


RUN chmod a+x /entrypoint.sh && \
    chmod a+x /wait-for-it.sh && \
    wget https://d2553lapexsdrl.cloudfront.net/sites/default/files/releases/jaspersoft_webserviceds_v${JASPER_WEBSERVICE_PLUGIN}.zip -O /tmp/jasper.zip && \
    unzip /tmp/jasper.zip -d /tmp/ && \
    wget http://mvn.sonner.com.br/~maven/net/sf/jasperreports/jasperreports-htmlcomponent/${HTMLCOMPONENT_VERSION}/jasperreports-htmlcomponent-${HTMLCOMPONENT_VERSION}.jar -O /tmp/jasperreports-htmlcomponent-${HTMLCOMPONENT_VERSION}.jar

VOLUME ["/jasperserver-import"]

ENV JAVA_OPTS="-Xms1024m -Xmx2048m -XX:PermSize=32m -XX:MaxPermSize=512m -Xss2m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled"

ENTRYPOINT ["/entrypoint.sh"]


#https://community.jaspersoft.com/questions/541509/error-has-occurred-6632-sql-validation-stored-procedure-45-breaks-all-report