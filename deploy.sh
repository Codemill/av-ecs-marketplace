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
  --template-url https://s3-eu-north-1.amazonaws.com/av-marketplace-cloudformation/main-marketplace.yaml \
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

# aws cloudformation create-stack \
#   --stack-name ${STACK_NAME} \
#   --template-url https://s3-eu-north-1.amazonaws.com/av-marketplace-cloudformation/main-marketplace.yaml \
#   --parameters \
#     ParameterKey=AdapterRdsDbClass,ParameterValue="db.t3.small" \
#     ParameterKey=ApplicationTag,ParameterValue="accurate-video-marketplace" \
#     ParameterKey=CertificateArn,ParameterValue="arn:aws:acm:eu-west-1:653767197116:certificate/181c55eb-e432-4467-890c-8bb14d7dc82d" \
#     ParameterKey=HostedZoneId,ParameterValue="Z1GJM9SVODAIRX" \
#     ParameterKey=KeycloakRdsDbClass,ParameterValue="db.t3.small" \
#     ParameterKey=LoadBalancerDomainName,ParameterValue="av-marketplace.cmtest.se" \
#     ParameterKey=LogsRetention,ParameterValue="14" \
#     ParameterKey=PrivateSubnets,ParameterValue=\"subnet-0387157eb524052db,subnet-0cd1578fd52130980\" \
#     ParameterKey=PublicSubnets,ParameterValue=\"subnet-00dfad3aa0036eaf1,subnet-0604c6efce04b1bf7\" \
#     ParameterKey=Vpc,ParameterValue="vpc-0efb3957cf16aeceb" \
#   --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
#   --profile "${PROFILE}" \
#   --region "${REGION}"
