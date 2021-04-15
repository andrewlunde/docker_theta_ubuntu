#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:18.04

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
  && apt-get update \
#  && apt -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true update \
  && echo "..."

RUN \
  apt-get -y upgrade \
  && echo "..."

RUN \
  apt-get install -y build-essential \
  && echo "..."

RUN \
  apt-get install -y software-properties-common \
  && apt-get install -y byobu curl git htop man unzip vim wget jq bzr lsof \
  && apt-get install -y screen tmux \
  && echo "..."

#RUN \
#  rm -rf /var/lib/apt/lists/*

# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts

RUN \
  echo '' >> /root/.bashrc \
  && echo '#New PS1' >> /root/.bashrc \
  && echo 'export PS1="/\$(basename \w) \$ "' >> /root/.bashrc \

  && echo '' >> /root/.bashrc \
  && echo '#THETA DEV' >> /root/.bashrc \
  && echo 'export GOROOT=/usr/local/go' >> ~/.bashrc \
  && echo 'export GOPATH=$HOME/go' >> ~/.bashrc \
  && echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> ~/.bashrc \
  && echo 'export THETA_HOME=$GOPATH/src/github.com/thetatoken/theta' >> ~/.bashrc \
  && echo 'export GO111MODULE=on' >> ~/.bashrc \
  && echo 'echo "Build Theta with the following."' >> ~/.bashrc \
  && echo 'echo "cd \$THETA_HOME ; make install"' >> ~/.bashrc \
  && echo 'echo "Start the Theta Private Net."' >> ~/.bashrc \
  && echo 'echo "cd \$THETA_HOME ; screen -S theta theta start --config=../privatenet/node"' >> ~/.bashrc \
  && echo "..."

RUN \
  wget https://dl.google.com/go/go1.13.15.linux-amd64.tar.gz \
  && tar -C /usr/local -xzf go1.13.15.linux-amd64.tar.gz \
  && echo "..."

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

COPY entrypoint.sh /usr/local/bin/
COPY start_theta.sh /usr/local/bin/

EXPOSE 16888

# Define default command.
#CMD ["bash"]
# Start the entrypoint script upon docker run
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
