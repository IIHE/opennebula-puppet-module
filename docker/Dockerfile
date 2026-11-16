FROM almalinux:9

ENV container=oci
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV PATH="${PATH}:/opt/puppetlabs/bin"

RUN dnf install -y epel-release dnf-plugins-core \
    && dnf config-manager --set-enabled crb \
    && dnf install -y \
        hostname \
        iproute \
        openssh-server \
        procps-ng \
        rubygem-nokogiri \
        sudo \
        systemd \
        tar \
        https://yum.puppet.com/puppet8-release-el-9.noarch.rpm \
    && dnf install -y puppet-agent \
    && dnf clean all \
    && ssh-keygen -A \
    && ln -sf /usr/lib/systemd/system/sshd.service /etc/systemd/system/multi-user.target.wants/sshd.service

RUN puppet module install puppetlabs-stdlib --version 8.6.0 \
    && puppet module install puppetlabs-inifile --version 5.4.1 \
    && puppet module install puppetlabs-yumrepo_core --version 2.1.0 \
    && puppet module install puppetlabs-cron_core --version 1.3.0

COPY hiera/hiera.yaml /etc/puppetlabs/code/environments/production/hiera.yaml
COPY hiera/docker.yaml /etc/puppetlabs/code/environments/production/data/docker.yaml

EXPOSE 22

STOPSIGNAL SIGRTMIN+3
CMD ["/usr/sbin/init"]
