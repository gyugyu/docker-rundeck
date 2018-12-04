FROM openjdk:8

ENV RUNDECK_VERSION 3.0.9.20181127-1.201811291844
ENV RUNDECK_SLACK_INCOMING_WEBHOOK_PLUGIN_VERSION 0.6

COPY system-requirements.txt /root/system-requirements.txt
RUN  \
    apt-get update && \
    xargs apt-get -y -q install < /root/system-requirements.txt && \
    apt-get clean && \
    wget -q http://dl.bintray.com/rundeck/rundeck-deb/rundeck_${RUNDECK_VERSION}_all.deb -P /tmp/ && \
    dpkg -i /tmp/rundeck_${RUNDECK_VERSION}_all.deb && \
    wget -q https://github.com/higanworks/rundeck-slack-incoming-webhook-plugin/releases/download/v$RUNDECK_SLACK_INCOMING_WEBHOOK_PLUGIN_VERSION.dev/rundeck-slack-incoming-webhook-plugin-$RUNDECK_SLACK_INCOMING_WEBHOOK_PLUGIN_VERSION.jar -P /var/lib/rundeck/libext/

COPY requirements.txt /root/requirements.txt
RUN pip install -r /root/requirements.txt

ENV HOME /var/lib/rundeck
ENV SHELL bash
ENV WORKON_HOME /var/lib/rundeck
WORKDIR /var/lib/rundeck

VOLUME /data

COPY conf /root/rundeck-config
COPY conf-templates /root/rundeck-config-templates

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["rundeck"]

EXPOSE 4440
 
