set -x
set -e
IMAGE=colomoto/colomoto-docker:$TAG
mkdir -p $TAG && cd $TAG
docker pull ${IMAGE}
docker run --rm ${IMAGE} apt list --installed > debian-installed-${TAG}.txt
docker run --rm ${IMAGE} conda env export > conda-environment-${TAG}-strict.yml
docker run --rm ${IMAGE} conda env export -c conda-forge -c colomoto --from-history > conda-environment-${TAG}.yml||true
docker rmi ${IMAGE}
