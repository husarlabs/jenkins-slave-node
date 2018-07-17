FROM jenkinsci/jnlp-slave

USER root

RUN apt-get update \
    && apt-get install -y curl wget libxss1 libappindicator1 libindicator7 xvfb apt-transport-https build-essential \
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

ENV NEWMAN_VERSION 3.9.3
RUN npm install -g newman@${NEWMAN_VERSION};

ENV DISPLAY :99
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# install k8s cli tools
ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV PATH /opt/google-cloud-sdk/bin:$PATH

RUN curl https://sdk.cloud.google.com | bash && mv google-cloud-sdk /opt
RUN gcloud components install kubectl

# golang
ARG GO_VERSION=1.10.3
RUN wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -xzvf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz \
    && mv go /usr/lib/go

ENV GOROOT=/usr/lib/go
RUN chown -R jenkins ${GOROOT}

ENV GOPATH /home/jenkins/go
RUN mkdir /home/jenkins/go \
    && chown -R jenkins ${GOPATH}

ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

ADD go.pedge.zip ${GOPATH}/src/
RUN unzip -q go/src/go.pedge.zip -d /var/ \
    && rm go/src/go.pedge.zip

# docker
RUN curl -fsSL get.docker.com | bash
RUN usermod -aG docker jenkins

# AWS
RUN curl -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    # && export PATH=/home/jenkins/.local/bin:$PATH \
    && pip install awscli --upgrade

ENV PATH /home/jenkins/.local/bin:$PATH
RUN chown -R jenkins /home/jenkins/

USER jenkins
