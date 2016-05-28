FROM monkeywrench-base

ADD roles/ssh /roles/ssh
RUN /roles/ssh/install.sh

ADD roles/ansible /roles/ansible
RUN /roles/ansible/install.sh
