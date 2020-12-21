#!/usr/bin/env bash

PROFILE="${1}"
REGION="${2}"
STACK_NAME="${3}"
FORCE="${4:-\"false\"}"

if [ -z "${PROFILE}" ] ; then
  read -rp "AWS Profile: " PROFILE
fi

if [ -z "${REGION}" ] ; then
  read -rp "AWS Region: " REGION
fi

if [ -z "${STACK_NAME}" ] ; then
  read -rp "AWS Stack Name: " STACK_NAME
fi

if [ "${FORCE}" != "true" ] ; then
  read -rp "Create '${STACK_NAME}' in '${REGION}' using profile '${PROFILE}'? (n) " q
  if [ "${q}" = "${q#[Yy]}" ]; then
    exit 0
  fi
fi

aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-url https://s3-eu-north-1.amazonaws.com/av-marketplace-cloudformation/main-marketplace.yaml \
  --parameters \
    ParameterKey=AdapterRdsDbClass,ParameterValue="db.t3.small" \
    ParameterKey=ApplicationTag,ParameterValue="accurate-video-marketplace" \
    ParameterKey=CertificateArn,ParameterValue="arn:aws:acm:eu-west-1:653767197116:certificate/181c55eb-e432-4467-890c-8bb14d7dc82d" \
    ParameterKey=HostedZoneId,ParameterValue="Z1GJM9SVODAIRX" \
    ParameterKey=KeycloakRdsDbClass,ParameterValue="db.t3.small" \
    ParameterKey=LoadBalancerDomainName,ParameterValue="marketplace.cmtest.se" \
    ParameterKey=LogsRetention,ParameterValue="14" \
    ParameterKey=PrivateSubnets,ParameterValue=\"subnet-05c0229b5cf088800,subnet-01f037d667825a613\" \
    ParameterKey=PublicSubnets,ParameterValue=\"subnet-0ff5e8f620dd581e8,subnet-0e6cb7ae43947e8f9\" \
    ParameterKey=Vpc,ParameterValue="vpc-037991747cf701ea6" \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
  --profile "${PROFILE}" \
  --region "${REGION}"
