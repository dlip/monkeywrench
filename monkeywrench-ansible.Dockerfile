FROM monkeywrench-base

ADD roles/ansible /roles/ansible
RUN /roles/ansible/install.sh
