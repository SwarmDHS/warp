DOCKER=docker

DEPLOY_DIR=deploy

CONTAINER_NAME=${CONTAINER_NAME:-warp_build}
IMAGE_NAME=${IMAGE_NAME:-pimod_warp}

PRESERVE_CONTAINER=${PRESERVE_CONTAINER:-0}
CLEAN=${CLEAN:-0}

CONTAINER_EXISTS=$(${DOCKER} ps -a --filter name="${CONTAINER_NAME}" -q)
CONTAINER_RUNNING=$(${DOCKER} ps --filter name="${CONTAINER_NAME}" -q)

if [ "${CONTAINER_RUNNING}" != "" ]; then
	echo "The build is already running in container ${CONTAINER_NAME}. Aborting."
	exit 1
fi

if [ "${CONTAINER_EXISTS}" != "" ] && [ "${CLEAN}" != "1" ]; then
	echo "Container ${CONTAINER_NAME} already exists and you did not specify CLEAN=1. Aborting."
	echo "You can delete the existing container like this:"
	echo "  ${DOCKER} rm -v ${CONTAINER_NAME}"
    echo "Or you can run a clean build like this:"
    echo "  CLEAN=1 ./build.sh"
	exit 1
fi

if [[ "${CLEAN}" == "1" ]]; then
    echo "Attempting to remove container and previous images."
    ${DOCKER} rm -v "${CONTAINER_NAME}"
    rm -rf ${DEPLOY_DIR}
fi

mkdir -p ${DEPLOY_DIR}

# Build the container
docker build -t ${IMAGE_NAME} .

# Run the container
docker run --name ${CONTAINER_NAME} --privileged -v $PWD:/build ${IMAGE_NAME}

if [[ "${PRESERVE_CONTAINER}" == "0" ]]; then
    ${DOCKER} rm -v "${CONTAINER_NAME}"
fi

printf "\n\nDone!\n"
