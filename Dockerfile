FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

RUN sed -i "s/security.ubuntu.com/mirror.sjtu.edu.cn/g; s/archive.ubuntu.com/mirror.sjtu.edu.cn/g" /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends openssh-server && \
    apt-get install -y sudo vim nano wget curl build-essential git-core unzip screen dialog && \
    useradd -m -s /bin/bash -G sudo user

RUN wget http://192.168.1.10/pkgs/Anaconda3-2022.05-Linux-x86_64.sh -O /tmp/anaconda.sh && \
    sudo -u user bash /tmp/anaconda.sh -b -p /home/user/anaconda && \
    rm /tmp/anaconda.sh && \
    sudo -u user bash -c 'eval "$(/home/user/anaconda/bin/conda shell.bash hook)" && \
    conda init && \
    pip config set global.index-url https://mirror.sjtu.edu.cn/pypi/web/simple'

COPY --chown=user:user condarc /home/user/.condarc

RUN sudo -u user bash -c 'eval "$(/home/user/anaconda/bin/conda shell.bash hook)" && \
    pip install torch torchvision torchaudio tensorflow --extra-index-url https://mirror.sjtu.edu.cn/pytorch-wheels/cu116'

RUN echo "export PATH=\"\$PATH:/usr/local/cuda/bin\"" >> /home/user/.bashrc

COPY entrypoint.sh /

EXPOSE 22
CMD /entrypoint.sh
