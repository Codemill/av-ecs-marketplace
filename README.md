# Accurate.Video Validate on AWS Marketplace

## Step-by-step instructions

### Step 1: Subscribe

[Subscribe to Accurate.Video Validate](https://aws.amazon.com/marketplace/pp/B08R5F7FCJ/)

### Step 2: Setup HostedZone (optional)

If you already have a hosted Zone in Route53 that you want to use, skip to the next step.

[Register a domain](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html) and
[create a hosted zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html).

### Step 3: Create a new VPC (optional)

If you already have a VPC that you want to re-use, skip to the next step.

Create a new VPC:

[<img src="docs/assets/cloudformation-launch-stack.png">](https://console.aws.amazon.com/cloudformation/home?#/stacks/quickcreate?templateUrl=https://av-marketplace-cf.s3.eu-north-1.amazonaws.com/latest/vpc.yaml)

### Step 4: Deploy

Create a new deployment:

[<img src="docs/assets/cloudformation-launch-stack.png">](https://console.aws.amazon.com/cloudformation/home?#/stacks/quickcreate?templateUrl=https://av-marketplace-cf.s3.eu-north-1.amazonaws.com/latest/main.yaml)

### Uninstall

1. Disable deletion protection on the Keycloak and Accurate Video RDS instances
2. Delete the main stack, which will delete the child stacks automatically
3. Delete the VPC stack
4. Unsubscribe on marketplace
