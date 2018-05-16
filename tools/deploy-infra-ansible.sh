#!/bin/bash

# The script will clone the infra repos and upload them to your artifactory
# You can provide a destination directory to which project should be cloned.
# If not provided will use a temporary directory.
#
# Examples:
#   $ ./tools/deploy-infra.sh
#   $ ./tools/deploy-infra.sh ../repos/pivotal/
#

set -o errexit

if [[ $# -lt 1 ]]; then
	DEST_DIR="$( mktemp -d )"
else
	DEST_DIR="$1"
fi

POTENTIAL_DOCKER_HOST="$( echo "$DOCKER_HOST" | cut -d ":" -f 2 | cut -d "/" -f 3 )"
if [[ -z "${POTENTIAL_DOCKER_HOST}" ]]; then
    POTENTIAL_DOCKER_HOST="localhost"
fi

# It's just a pseudo code, mainly to get the idea
function deploy_project {
	local ansible_playbook="$1"

	# Verify if vagrant is up using global-status
	if [vagrant is up]; then
	  ansible-playbook ansible_playbook
	else
	  vagrant up && ansible-playbook ansible_playbook
	fi

}

echo "Using Docker running at [${POTENTIAL_DOCKER_HOST}]"
echo "Destination directory to clone the apps is [${DEST_DIR}]"
echo "Artifactory ID [${ARTIFACTORY_ID}]"

deploy_project "ansible/eureka-setup.yml"

echo "DONE!"
