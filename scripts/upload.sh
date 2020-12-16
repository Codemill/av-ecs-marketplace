#!/usr/bin/env bash

PROFILE="${1}"
BUCKET="${2}"
FORCE="${3:-\"false\"}"

if [ -z "${PROFILE}" ] ; then
  read -rp "AWS Profile: " PROFILE
fi

if [ -z "${BUCKET}" ] ; then
  read -rp "Template bucket: " BUCKET
fi

if [ "${FORCE}" != "true" ] ; then
  read -rp "Upload templates to '${BUCKET}' using profile '${PROFILE}'? (n) " q
  if [ "${q}" = "${q#[Yy]}" ]; then
    exit 0
  fi
fi

aws s3 sync \
  --profile "${PROFILE}" \
  --exclude ".git/*" \
  --exclude ".gitignore" \
  --exclude "*.md" \
  --exclude "docs/*" \
  --exclude "deploy.sh" \
  . "s3://${BUCKET}"
