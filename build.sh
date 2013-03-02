#!/bin/sh

set -x

IMG=base:e9cb4ad9173245ac
DEST=_tmp/devbox

# Print the most recently created conntainer
# (warning this is a hack susceptible to race conditions)
# We need because 'docker run' can't inject stdin and return the container ID at the same time
# (solution: implement that)
last() { docker ps -a -q | head -n 1; }

run_and_commit() { docker run $4 -a $1 /bin/sh -c "touch /tmp/$RANDOM; $2"; docker commit $(last) $3; }

# This is a hack (what I really want is an image copy)
copy() { run_and_commit $1 /bin/true $2; }

# Inject an executable file
# eg.  inject_executable myimage ./cmd /usr/local/bin/cmd
inject_executable() { run_and_commit $1 "cat > $3; chmod +x $3" $1 -i < $2; }

TMP=_tmp/$RANDOM

if [ -z "$DEST" ]; then
	echo "Usage: $0 dest"
	exit 1
fi

copy $IMG $TMP

# Update sources.list
run_and_commit $TMP "echo 'deb http://archive.ubuntu.com/ubuntu quantal main universe multiverse' > /etc/apt/sources.list" $TMP

# Update sources.list
run_and_commit $TMP "apt-get update" $TMP

# Install packages
run_and_commit $TMP "DEBIAN_FRONTEND=noninteractive apt-get install -y -q git curl golang s3cmd" $TMP

# Install git-wrapper
inject_executable $TMP git-wrapper /usr/local/bin/git

# Install s3cmd config
inject_executable $TMP s3cfg /.s3cfg

# Save final image
copy $TMP $DEST
