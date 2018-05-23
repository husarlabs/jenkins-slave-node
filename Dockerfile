FROM jenkinsci/jnlp-slave

USER root

RUN apt-get update \
    && apt-get install -y curl wget libxss1 libappindicator1 libindicator7 xvfb \
    && apt-get -y autoclean

# nvm environment variables
ENV NVM_DIR /usr/local/nvm

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

RUN apt-get install nodejs

ENV DISPLAY :99
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

USER jenkins