# Accurate Video on AWS ECS

## Usage

### Prerequisites

- Install [AWS CLI](https://aws.amazon.com/cli/)
- [Configure CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

- Route53 Hosted Zone in which a DNS record pointing to the load balancer will be created [Create Hosted Zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html)
- Certificate stored and validated in CertificateManager which covers the domain name that the load balancer will be given [Create certificate in ACM](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html)

### Configuration

The Frontend, Adapter and Jobs applications currently loads configuration files from an S3 storage that is created by the infrastructure template. We've included templates for these files in the [config directory](./config) that you can use as your base of creating the proper configuration.

Before uploading each configuration file, you need to remove the `_template` suffix from the file name, and replace or set the values that are needed for your deployment.

- `config/frontend/keycloak.json` is needed if you're using Keycloak as your authentication solution, in it you'll need to replace `AV_KEYCLOAK_URL` with the URL of your Keycloak Realm.
- `config/frontend/settings.js` contains the frontend configuration, in it you'll need to replace `AV_LICENSE_KEY` with a valid Accurate Video license key, and configure the behaviour of the application.

After you've renamed and updated the configuration files you'll need to upload them to the configuration bucket that was created by the infrastructure template.

If you're manually applying each template and not using `deploy.sh` you also need to upload the files to the configuration bucket:

```sh
CONFIG_BUCKET=$(aws cloudformation describe-stacks \
    --stack-name "${INFRASTRUCTURE_STACK_NAME}" \
    --query "Stacks[0].Outputs[?OutputKey=='ConfigBucketName'].OutputValue" \
    --output text \
    --region "${REGION}" \
    --profile "${PROFILE}")
    
aws s3 cp ./config/frontend/settings.js s3://${CONFIG_BUCKET}/frontend/settings.js
aws s3 cp ./config/frontend/keycloak.json s3://${CONFIG_BUCKET}/frontend/keycloak.json
```

### Create ECS cluster running Accurate Video

Manually uploading the CloudFormation stacks in the following order:
    - vpc.yaml (optional)
    - infrastructure.yaml
    - adapter.yaml
    - jobs.yaml
    - frontend.yaml
    - analyze.yaml

## Architecture

### Services

![alt text](documentation/services.png)

### VPC

All traffic to and from the internet passes through the Internet Gateway. Access to the internet from the private subnets is done via NAT Gateways placed in both public subnets.
Traffic with an S3 bucket as destination will not be routed over the public internet, but instead via an S3 VPC Endpoint directly over the AWS backbone network.

![alt text](documentation/network.png)

### Security Groups

Security groups are in place to restrict network access to the different resources. The only one that allows direct access from the internet is the public Application Load Balancer (ALB), and this is restricted to TCP traffic on port 80 as we are currently running HTTP.

The Frontend, Analyze and Adapter services allow TCP traffic coming from the public ALB to their respective ports, the Adapter service also allows TCP traffic coming directly from the Jobs service. The RDS database only allows TCP traffic on port 5432 (PostgreSQL) coming from the Adapter service. To allow service discovery and communication with Hazelcast, ports 5699-5702 between Jobs and Adapter service are open both directions.

![alt text](documentation/security-groups.png)

### Auto-deployment of settings file

It is possible to change the Frontend configuration by updating the configuration file in S3. When this file is changed, S3 will send a notification event to an SNS Topic, which in turn will notify a Lambda function that initiates a new deployment of the Frontend service with the latest configuration. The deployment will launch new tasks in Fargate, wait for them to be healthy and then terminate the old tasks.

![alt text](documentation/autodeploy-settings-file.png)
