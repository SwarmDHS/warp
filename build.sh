DOCKER=docker

BUILD_DIR=build
DEPLOY_DIR=deploy

CONTAINER_NAME=${CONTAINER_NAME:-warp_build}
IMAGE_NAME=${IMAGE_NAME:-pimod_warp}

PRESERVE_CONTAINER=${PRESERVE_CONTAINER:-0}
CONTINUE=${CONTINUE:-0}
CLEAN=${CLEAN:-0}

CONTAINER_EXISTS=$(${DOCKER} ps -a --filter name="${CONTAINER_NAME}" -q)
CONTAINER_RUNNING=$(${DOCKER} ps --filter name="${CONTAINER_NAME}" -q)

if [ "${CONTAINER_RUNNING}" != "" ]; then
	echo "The build is already running in container ${CONTAINER_NAME}. Aborting."
	exit 1
fi

if [[ "${CLEAN}" == "1" ]]; then
    echo "Attempting to remove container and previous images."
    ${DOCKER} rm -v "${CONTAINER_NAME}"
    rm -rf ${DEPLOY_DIR}
fi

if [ "${CONTAINER_EXISTS}" != "" ] && [ "${CONTINUE}" != "1" ]; then
	echo "Container ${CONTAINER_NAME} already exists and you did not specify CONTINUE=1. Aborting."
	echo "You can delete the existing container like this:"
	echo "  ${DOCKER} rm -v ${CONTAINER_NAME}"
    echo "Or run a clean build like this:"
    echo "  CLEAN=1 ./build.sh"
	exit 1
fi

mkdir -p ${BUILD_DIR}
mkdir -p ${DEPLOY_DIR}

source credentials

# Build the container
docker build -t ${IMAGE_NAME} .

if [ "${CONTAINER_EXISTS}" != "" ]; then
    trap 'echo "got CTRL+C... please wait 5s" && ${DOCKER} stop -t 5 ${CONTAINER_NAME}_cont' SIGINT SIGTERM
    ${DOCKER} run \
        --rm \
        --name "${CONTAINER_NAME}_cont" \
        --volumes-from="${CONTAINER_NAME}" \
        --env "BOOTSTRAP_WPA_SSID=$BOOTSTRAP_WPA_SSID" \
        --env "BOOTSTRAP_WPA_PASSPHRASE=$BOOTSTRAP_WPA_PASSPHRASE" \
        --privileged \
        -v $PWD:/build \
        ${IMAGE_NAME}
    wait "$!"
else
    trap 'echo "got CTRL+C... please wait 5s" && ${DOCKER} stop -t 5 ${CONTAINER_NAME}_cont' SIGINT SIGTERM
    ${DOCKER} run \
        --name ${CONTAINER_NAME} \
        --env "BOOTSTRAP_WPA_SSID=$BOOTSTRAP_WPA_SSID" \
        --env "BOOTSTRAP_WPA_PASSPHRASE=$BOOTSTRAP_WPA_PASSPHRASE" \
        --privileged \
        -v $PWD:/build ${IMAGE_NAME}
    wait "$!"
fi

# Run the container


if [[ "${PRESERVE_CONTAINER}" == "0" ]]; then
    ${DOCKER} rm -v "${CONTAINER_NAME}"
fi

printf "\n\nDone!\n"
