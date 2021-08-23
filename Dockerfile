FROM ubuntu:18.04

ENV DEFAULT_TERRAFORM_VERSION 1.0.5
ENV DEFAULT_ANSIBLE_VERSION 2.5.0
COPY setup-scripts ~/setup-scripts
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update \ 
    && apt-get install -y software-properties-common \
    && echo "------------------------------------------------------ Common Packages" \
    && apt-get install -y sudo git curl wget telnet htop git unzip\
    && echo "------------------------------------------------------ Python" \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get install -y python3.9 \ 
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.9 10 \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 10 \
    && apt-get install -y python3-distutils \
    && apt-get install -y python3.9-distutils \
    && apt-get install -y python3-pip \
    && apt-get install python3.9-venv \
    && pip3 install --upgrade pip \
    && pip3 install --upgrade setuptools \
    && pip3 install --upgrade distlib \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 \
    && echo "------------------------------------------------------ TFenv" \
    && git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
    && ln -s ~/.tfenv/bin/* /usr/local/bin \
    && tfenv install ${DEFAULT_TERRAFORM_VERSION} \
    && tfenv use ${DEFAULT_TERRAFORM_VERSION} \
    && echo "------------------------------------------------------ Ansible" \
    && pip install ansible==${DEFAULT_ANSIBLE_VERSION} \
    && echo "------------------------------------------------------ Clean" \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && apt-get -y autoclean
