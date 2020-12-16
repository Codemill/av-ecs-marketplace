//DeployToStage Alternative 1 - One pipeline
  //Manual
  git push (adapter, analyze, keycloak, jobs, frontend, cloudformation-templates)

  //Gitlab pipes
  s3 sync cf-templats
  ecr push images
  cloudformation update-stack --parameter-override KEY=KeycloakVersion,VALUE=1.0.0


//DeployToStage Alternative 2 - Six different pipelines
  // SERVICE REPO
    git push ${SERVICE_X} ${TAG}

    //Gitlab pipes
    ecr push ${SERVICE_X}-${TAG}
    aws ecs register-taskdefinition ${SERVICE_X}
    aws ecs deploy-taskdefinition ${SERVICE_X}

  // CLOUDFORMATION_REPO
    git push av-ecs-marketplace

    //Gitlab pipes
    cloudformation update-stack --parameter-override KEY=KeycloakVersion,VALUE=1.0.0


//DeployToSellerAccount
  s3 sync cf-templates
  ecr push image
