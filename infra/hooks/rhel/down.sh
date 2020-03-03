#!/bin/bash -eE
set -o pipefail

[ "${DEBUG,,}" == "true" ] && set -x

my_file="$(readlink -e "$0")"
my_dir="$(dirname $my_file)"

source "$my_dir/definitions"
source "$WORKSPACE/global.env"
if [[ -e "${WORKSPACE}/vars.${JOB_NAME}-${RANDOM}.env" ]]; then
  source "${WORKSPACE}/vars.${JOB_NAME}-${RANDOM}.env"
fi
if [[ -e "$WORKSPACE/stackrc.$JOB_NAME.env" ]] ; then
  source "$WORKSPACE/stackrc.$JOB_NAME.env"
fi

instance_ip=$1

cat <<EOF | ssh -i $WORKER_SSH_KEY $SSH_OPTIONS $IMAGE_SSH_USER@$instance_ip
[ "${DEBUG,,}" == "true" ] && set -x
sudo subscription-manager unregister
EOF
