FROM ubuntu
MAINTAINER tme520@gmail.com
RUN apt update && apt upgrade -y && apt autoremove && apt autoclean
EXPOSE 80 443 22
ADD appLifecycleMgr.sh /
ENTRYPOINT exec /appLifecycleMgr.sh
