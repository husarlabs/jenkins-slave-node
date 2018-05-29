FROM jenkinsci/jnlp-slave

USER root

RUN apt-get update \
    && apt-get install -y curl wget libxss1 libappindicator1 libindicator7 xvfb apt-transport-https \
    && apt-get -y autoclean

#Add yarn to apt
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# nvm environment variables
ENV NVM_DIR /usr/local/nvm

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

# install chrome for UI testing
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

RUN apt-get update \
    && apt-get install nodejs \
    && apt-get install --no-install-recommends yarn

ENV DISPLAY :99
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

USER jenkins