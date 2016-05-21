FROM centos:7.2.1511

ENV http_proxy=http://172.17.0.1:3128
ENV https_proxy=http://172.17.0.1:3128

RUN yum -y update && yum clean all
RUN yum -y install epel-release

RUN mkdir -p /local_environment\
  && mkdir -p /scripts/remote_environment\
  && mkdir -p /remote_environment\
  && mkdir -p /scripts/setup

ADD roles/base /roles/base

ADD roles/confd /roles/confd
RUN /roles/confd/install.sh

WORKDIR /mnt/workdir

ENTRYPOINT ["/roles/base/entrypoint.sh"]
