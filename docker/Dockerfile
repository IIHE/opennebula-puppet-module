FROM centos:8

ENV HOSTNAME localhost
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV FACTER_operatingsystemmajrelease="8"
ENV FACTER_operatingsystemrelease="8"
ENV FACTER_lsbmajdistrelease="8"

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum -y install http://yum.puppetlabs.com/puppet/puppet-release-el-8.noarch.rpm epel-release
RUN yum makecache && yum -y install puppet-agent tar hostname openssh-server

ENV PATH="${PATH}:/opt/puppetlabs/bin"

RUN puppet module install puppetlabs-inifile
RUN puppet module install puppetlabs-stdlib
RUN puppet module install puppetlabs-concat
RUN puppet module install puppetlabs-mysql
RUN puppet module install puppetlabs-apache
RUN puppet module install puppetlabs-corosync
RUN puppet module install rodjek-logrotate

COPY hiera/hiera.yaml /etc/puppet/
COPY hiera/docker.yaml /etc/puppet/data/
