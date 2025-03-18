## improvements to do:
 - define s3 bucket for statefile
 - use kms for manage certificates
 - use existing terraform.workspace as env identificator to deploy on varius types of enviroments 
 - use private subnets for ECS and RDS
 - store secrets in parameter store
 - enable autoscaling
 - implement https with custom domain name in route 53
 - for beter HA, enable multi az for RDS and define snapshots or backups od DB
 

## more advanced solution
- build pipelines for code build (containers) 
- build cicd pipelines to deploy new docker version on ecs
- use own ECR
- improve security group rules
- use more granular iam roles
- create monitoring 
- consider resize of resources