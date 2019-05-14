FROM ubuntu
MAINTAINER tme520@gmail.com
RUN apt update && apt upgrade -y && apt-get install -y apt-transport-https curl gnupg apt-utils iputils-ping netcat && apt autoremove && apt autoclean
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt update && apt-get install -y kubectl
EXPOSE 80 443 22
ADD appLifecycleMgr.sh /
ADD config /
ENTRYPOINT ["/appLifecycleMgr.sh"]
CMD []
