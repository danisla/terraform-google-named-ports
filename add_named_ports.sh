#!/bin/bash -ex

# Extract JSON args into shell variables
JQ=$(command -v jq || true)
[[ -z "${JQ}" ]] && echo "ERROR: Missing command: 'jq'" >&2 && exit 1

eval "$(${JQ} -r '@sh "INSTANCE_GROUP=\(.instance_group) NAME=\(.name) PORT=\(.port)"')"

TMP_DIR=$(mktemp -d)
function cleanup() {
  rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

if [[ ! -z ${GOOGLE_CREDENTIALS+x} && ! -z ${GOOGLE_PROJECT+x} ]]; then
  export CLOUDSDK_CONFIG=${TMP_DIR}
  gcloud auth activate-service-account --key-file - <<<"${GOOGLE_CREDENTIALS}"
  gcloud config set project "${GOOGLE_PROJECT}"
fi

RES=$(gcloud compute instance-groups set-named-ports ${INSTANCE_GROUP} --named-ports=${NAME}:${PORT} --format=json)
FINGERPRINT=$(jq '.[]|.fingerprint' <<<${RES})
ID=$(jq '.[]|.id' <<<${RES})

# Output results in JSON format.
jq -n --arg fingerprint "${FINGERPRINT}" --arg id "${ID}" '{"fingerprint":$fingerprint, "id":$id}'