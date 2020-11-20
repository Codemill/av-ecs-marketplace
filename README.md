# Accurate Video on AWS Marketplace

## Step-by-step

### Step 1: Subscribe on AWS Marketplace

TODO: Insert link button to product

### Step 2: Setup HostedZone and CertificateManager

[Create a Hosted Zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html) with a valid domain name, and [Create a certificate in ACM](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html) for your Hosted Zone in the region that you want to run in.

TODO: Show where to get the Certificate ARN for a later step.

### Step 3: Create a new VPC (optional)

If you already have a VPC that you want to re-use, skip to step 4.

Click the button below to create a new VPC:

[<img src="docs/assets/cloudformation-launch-stack.png">](https://console.aws.amazon.com/cloudformation/home?#/stacks/quickcreate?templateUrl=https://av-marketplace-cloudformation.s3.eu-north-1.amazonaws.com/vpc.yaml)

### Step 4: Launch the Accurate Video stacks

Click the button below to create a new deployment:

[<img src="docs/assets/cloudformation-launch-stack.png">](https://console.aws.amazon.com/cloudformation/home?#/stacks/quickcreate?templateUrl=https://av-marketplace-cloudformation.s3.eu-north-1.amazonaws.com/main.yaml)

### Uninstall

1. Disable deletion protection on the Keycloak and Accurate Video RDS instances
2. Delete the main stack, which will delete the child stacks automatically
3. Delete the VPC stack
4. Unsubscribe on marketplace
