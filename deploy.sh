#!/usr/bin/env bash
read -rp "AWS Profile: " PROFILE
read -rp "AWS Region: " REGION
read -rp "AWS Stack Name: " STACK_NAME

aws s3 sync \
  --profile "${PROFILE}" \
  --exclude ".git/*" \
  --exclude ".gitignore" \
  --exclude "*.md" \
  --exclude "docs/*" \
  --exclude "deploy.sh" \
  . s3://av-marketplace-cloudformation

aws cloudformation update-stack \
  --stack-name ${STACK_NAME} \
  --template-url https://s3-eu-north-1.amazonaws.com/av-marketplace-cloudformation/main.yaml \
  --parameters \
    ParameterKey=AdapterRdsDbClass,UsePreviousValue=true \
    ParameterKey=ApplicationTag,UsePreviousValue=true \
    ParameterKey=CertificateArn,UsePreviousValue=true \
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
