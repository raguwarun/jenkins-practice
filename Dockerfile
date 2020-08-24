FROM centos

RUN yum -y install passwd
RUN yum -y install openssh-server

RUN useradd remote_user && \
    echo 'remote_user:1234' | chpasswd && \
    mkdir /home/remote_user/.ssh && \
    chmod 700 /home/remote_user/.ssh

COPY remote-key.pub /home/remote_user/.ssh/authorized_keys

RUN chown remote_user:remote_user -R /home/remote_user/.ssh && \
    chmod 600 /home/remote_user/.ssh/authorized_keys

RUN /usr/bin/ssh-keygen -A
EXPOSE 22
RUN rm -rf /run/nologin

RUN yum -y install mysql
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip3 install awscli --upgrade

CMD /usr/sbin/sshd -D