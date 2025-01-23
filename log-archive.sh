#!/bin/bash
#
# This script archives logs
# By compressing them and storing them in a new directory

LOG_DIR='/var/log/'
ARCHIVE_DIR='archive/'
DATE=$(date +%Y%m%d)
TIME=$(date +%H%M%S)
ARCHIVE_FILE="${ARCHIVE_DIR}logs_archive_${DATE}_${TIME}.tar.gz"

# Colors for error messages
RED='\033[0;31m'
NC='\033[0m'

usage() {
  echo "Usage: ${0} [LOG_DIR]"
  echo "Archive logs from provided directory"
  echo "If no directory is provided archive /var/log/"
  exit 1
}

error_only_one_param() {
 echo -e "${RED}Please provide up to one parameter${NC}"
 usage
}

error_not_a_dir() {
  echo -e "${RED}Provided parameter is not a directory or does not exist${NC}"
  usage
}

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
    echo "mkdir ${ARCHIVE_DIR}"
  fi
  echo "tar -zcf ${ARCHIVE_FILE} ${LOG_DIR}"
else
  error_not_a_dir
fi

exit 0
