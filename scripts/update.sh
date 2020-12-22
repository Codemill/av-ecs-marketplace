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

aws cloudformation update-stack \
  --stack-name ${STACK_NAME} \
  --template-url https://s3-eu-north-1.amazonaws.com/av-marketplace-cf/latest/main.yaml \
  --parameters \
    ParameterKey=AdapterRdsDbClass,UsePreviousValue=true \
    ParameterKey=ApplicationTag,UsePreviousValue=true \
    ParameterKey=CapacityProvider,UsePreviousValue=true \
    ParameterKey=AdapterImageTag,UsePreviousValue=true \
    ParameterKey=AnalyzeImageTag,UsePreviousValue=true \
    ParameterKey=JobsImageTag,UsePreviousValue=true \
    ParameterKey=FrontendImageTag,UsePreviousValue=true \
    ParameterKey=KeycloakImageTag,UsePreviousValue=true \
    ParameterKey=HostedZoneId,UsePreviousValue=true \
    ParameterKey=KeycloakRdsDbClass,UsePreviousValue=true \
    ParameterKey=LoadBalancerDomainName,UsePreviousValue=true \
    ParameterKey=LogsRetention,UsePreviousValue=true \
    ParameterKey=PrivateSubnets,UsePreviousValue=true \
    ParameterKey=PublicSubnets,UsePreviousValue=true \
    ParameterKey=Vpc,UsePreviousValue=true \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
  --profile "${PROFILE}" \
  --region "${REGION}"
