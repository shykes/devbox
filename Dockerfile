from ubuntu:12.10

run apt-get update -y
run apt-get install -y mercurial
run apt-get install -y git
run apt-get install -y python
run apt-get install -y curl
run apt-get install -y vim
run apt-get install -y strace

# Install go
run curl https://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz | tar -C /usr/local -zx
env GOROOT /usr/local/go
env PATH /usr/local/go/bin:$PATH

run useradd dev
run mkdir /home/dev && chown -R dev: /home/dev
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
run touch /home/dev/placeholder
run mkdir /home/dev/go
volume /home/dev

user dev
workdir /home/dev
env HOME /home/dev
entrypoint bash
