#!/bin/bash

# This script archives logs
# By compressing them and storing them in a new directory

LOG_DIR='/var/log'
ARCHIVE_DIR='./archive'
DATE=$(date +%Y%m%d)
TIME=$(date +%H%M%S)
ARCHIVE_FILE="logs_archive_${DATE}_${TIME}.tar.gz"

# Colors for error messages
RED='\033[0;31m'
NC='\033[0m'

usage() {
  echo "Usage: ${0} [LOG_DIR]"
  echo "Archive logs from provided directory"
  echo "If no directory is provided archive ${LOG_DIR}"
  exit 1
}

error_only_one_param() {
 echo -e "${RED}Please provide up to one parameter${NC}" >&2
 usage
}

error_not_a_dir() {
  echo -e "${RED}Provided parameter is not a directory or does not exist${NC}" >&2
  usage
}

# Check if script was run with sudo privliges
if [[ "${UID}" -ne 0 ]]
then
  echo -e "${RED}Pleas run with sudo or as a root${NC}" >&2
  exit 1
fi

# Check if user provided directory for archivization
if [[ "${#}" -gt 1 ]]
then
  error_only_one_param
elif [[ "${#}" -eq 1 ]]
then
  LOG_DIR="${1}"
fi

# Check if provided parameter exists and is a directory
if [[ -d "${LOG_DIR}" ]]
then
  # Check if ARCHIVE_DIR exists
  if [[ ! -d "${ARCHIVE_DIR}" ]]
  then
    mkdir ${ARCHIVE_DIR}
  fi
    tar -zcf ${ARCHIVE_DIR}/${ARCHIVE_FILE} ${LOG_DIR} &> /dev/null
    
    # Check to see if the tar command succeeded
    if [[ "${?}" -ne 0 ]]
    then
      echo -e "${RED}The ${LOG_DIR} was NOT archived${NC}" >&2
      exit 1
      fi
    echo "The ${LOG_DIR} was archived as a ${ARCHIVE_FILE}"
else
  error_not_a_dir
fi

exit 0
