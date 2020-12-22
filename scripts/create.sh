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
  --template-url https://s3-eu-north-1.amazonaws.com/av-marketplace-cf/latest/main.yaml \
  --parameters \
    ParameterKey=AdapterRdsDbClass,ParameterValue="db.t3.small" \
    ParameterKey=ApplicationTag,ParameterValue="accurate-video-marketplace" \
    ParameterKey=CapacityProvider,ParameterValue="FARGATE_SPOT" \
    ParameterKey=AdapterImageTag,ParameterValue="4.5.3" \
    ParameterKey=AnalyzeImageTag,ParameterValue="4.5.3" \
    ParameterKey=JobsImageTag,ParameterValue="4.5.3" \
    ParameterKey=FrontendImageTag,ParameterValue="4.5.3" \
    ParameterKey=KeycloakImageTag,ParameterValue="4.5.3" \
    ParameterKey=HostedZoneId,ParameterValue="Z1GJM9SVODAIRX" \
    ParameterKey=KeycloakRdsDbClass,ParameterValue="db.t3.small" \
    ParameterKey=LoadBalancerDomainName,ParameterValue="marketplace.cmtest.se" \
    ParameterKey=LogsRetention,ParameterValue="14" \
    ParameterKey=PrivateSubnets,ParameterValue=\"subnet-0bc3b8d0a063848cd,subnet-051a9153b9e4b3c3d\" \
    ParameterKey=PublicSubnets,ParameterValue=\"subnet-02261967f8d210269,subnet-03256aa80d6ef70f8\" \
    ParameterKey=Vpc,ParameterValue="vpc-072963b73493d01b8" \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
  --profile "${PROFILE}" \
  --region "${REGION}"
