#!/usr/bin/env bash

PROFILE="${1}"
BUCKET="${2}"
VERSION="${3:-latest}"

if [ -z "${PROFILE}" ] ; then
  read -rp "AWS Profile: " PROFILE
fi

if [ -z "${BUCKET}" ] ; then
  read -rp "Template bucket: " BUCKET
fi

if [ -z "${VERSION}" ] ; then
  read -rp "Template version: " VERSION
fi

aws s3 sync \
  --profile "${PROFILE}" \
  --exclude ".DS_Store" \
  --exclude "scripts/*" \
  --exclude ".git/*" \
  --exclude ".gitignore" \
  --exclude "*.md" \
  --exclude "docs/*" \
  . "s3://${BUCKET}/${VERSION}"
