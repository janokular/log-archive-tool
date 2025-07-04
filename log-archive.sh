#!/bin/bash

# This script archives logs
# By compressing them and storing them in a new directory

LOG_DIR='/var/log'
ARCHIVE_DIR="${HOME}/archive"
DATE=$(date +%Y%m%d)
TIME=$(date +%H%M%S)
ARCHIVE_FILE="logs_archive_${DATE}_${TIME}.tar.gz"

usage() {
  echo "Usage: ${0} [LOG_DIR]"
  echo "Archive logs from provided directory: default ${LOG_DIR}"
  exit 1
}

# Check if script was run with sudo privileges
if [[ "${UID}" -ne 0 ]]
then
  echo -e 'Please run with sudo or as a root' >&2
  exit 1
fi

# Check if user provided LOG_DIR
if [[ "${#}" -gt 1 ]]
then
  echo -e 'Please provide up to one parameter' >&2
  usage
elif [[ "${#}" -eq 1 ]]
then
  LOG_DIR="${1}"
fi

# Check if LOG_DIR exists and is a directory
if [[ ! -d "${LOG_DIR}" ]]
then
  echo -e 'Provided parameter is not a directory or does not exist' >&2
  exit 1
fi

# Check if ARCHIVE_DIR exists
if [[ ! -d "${ARCHIVE_DIR}" ]]
then
  mkdir ${ARCHIVE_DIR}
fi

tar -zcf ${ARCHIVE_DIR}/${ARCHIVE_FILE} ${LOG_DIR} &> /dev/null

# Check the status of the tar command
if [[ "${?}" -ne 0 ]]
then
  echo -e "The ${LOG_DIR} was NOT archived" >&2
  exit 1
else
  echo "The ${LOG_DIR} was archived as a ${ARCHIVE_FILE}"
  exit 0
fi
