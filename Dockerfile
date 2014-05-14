from ubuntu:12.10

run apt-get update -y
run apt-get install -y mercurial
run apt-get install -y git
run apt-get install -y python
run apt-get install -y curl
run apt-get install -y vim
run apt-get install -y strace
run apt-get install -y diffstat

# Install go
run curl https://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz | tar -C /usr/local -zx
env GOROOT /usr/local/go
env PATH /usr/local/go/bin:$PATH


# Setup home environment
run useradd dev
run mkdir /home/dev && chown -R dev: /home/dev
run mkdir /home/dev/go

# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
run mkdir /var/shared/
run touch /var/shared/placeholder
run chown -R dev:dev /var/shared
volume /var/shared

workdir /home/dev
env HOME /home/dev
add vimrc /home/dev/.vimrc
add bash_profile /home/dev/.bash_profile
add gitconfig /home/dev/.gitconfig
run chown -R dev:dev /home/dev

# Link in shared parts of the home directory
run ln -s /var/shared/.ssh
run ln -s /var/shared/.bash_history

user dev

entrypoint bash
