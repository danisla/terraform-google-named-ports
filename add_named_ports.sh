#!/bin/bash -ex

# Extract JSON args into shell variables
JQ=$(command -v jq || true)
[[ -z "${JQ}" ]] && echo "ERROR: Missing command: 'jq'" >&2 && exit 1

eval "$(${JQ} -r '@sh "INSTANCE_GROUP=\(.instance_group) NAME=\(.name) PORT=\(.port)"')"

TMP_FILE=$(mktemp)
function cleanup() {
  rm -f "${TMP_FILE}"
}
trap cleanup EXIT

if [[ ! -z ${GOOGLE_CREDENTIALS+x} && ! -z ${GOOGLE_PROJECT+x} ]]; then
  echo "${GOOGLE_CREDENTIALS}" > ${TMP_FILE}
  export GOOGLE_APPLICATION_CREDENTIALS=${TMP_FILE}
  gcloud config set project "${GOOGLE_PROJECT}"
fi

RES=$(gcloud compute instance-groups set-named-ports ${INSTANCE_GROUP} --named-ports=${NAME}:${PORT} --format=json)
FINGERPRINT=$(jq '.[]|.fingerprint' <<<${RES})
ID=$(jq '.[]|.id' <<<${RES})

# Output results in JSON format.
jq -n --arg fingerprint "${FINGERPRINT}" --arg id "${ID}" '{"fingerprint":$fingerprint, "id":$id}'