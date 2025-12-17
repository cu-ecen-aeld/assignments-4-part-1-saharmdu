#!/bin/sh
# Tester script for assignment 1 and assignment 2
# Author: Siddhant Jajoo

set -e
set -u

NUMFILES_DEFAULT=10
WRITESTR_DEFAULT="AELD_IS_FUN"
WRITEDIR_BASE="/tmp/aeld-data"

CONF_DIR="/etc/finder-app/conf"
USERNAME_FILE="${CONF_DIR}/username.txt"
ASSIGNMENT_FILE="${CONF_DIR}/assignment.txt"

NUMFILES="${NUMFILES_DEFAULT}"
WRITESTR="${WRITESTR_DEFAULT}"
WRITEDIR="${WRITEDIR_BASE}"

# Optional args:
#   $1 = NUMFILES
#   $2 = WRITESTR
#   $3 = subdirectory name under /tmp/aeld-data (e.g., username)
if [ $# -ge 1 ]; then NUMFILES="$1"; fi
if [ $# -ge 2 ]; then WRITESTR="$2"; fi
if [ $# -ge 3 ]; then WRITEDIR="${WRITEDIR_BASE}/$3"; fi

username="$(cat "${USERNAME_FILE}")"
assignment="$(cat "${ASSIGNMENT_FILE}")"

echo "User: ${username}"
echo "Assignment: ${assignment}"
echo "Writing ${NUMFILES} files containing '${WRITESTR}' to ${WRITEDIR}"

rm -rf "${WRITEDIR}"
mkdir -p "${WRITEDIR}"

i=1
while [ "${i}" -le "${NUMFILES}" ]; do
  writer "${WRITEDIR}/${i}.txt" "${WRITESTR}"
  i=$((i+1))
done

# Run finder and capture output (required by assignment)
RESULT="$(finder.sh "${WRITEDIR}" "${WRITESTR}")"
echo "${RESULT}" > /tmp/assignment4-result.txt
echo "${RESULT}"

EXPECTED="The number of files are ${NUMFILES} and the number of matching lines are ${NUMFILES}"
if [ "${RESULT}" != "${EXPECTED}" ]; then
  echo "ERROR: Unexpected finder output"
  echo "Expected: ${EXPECTED}"
  echo "Got:      ${RESULT}"
  exit 1
fi

echo "PASS"
