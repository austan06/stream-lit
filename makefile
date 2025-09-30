# Makefile for AWS App Runner deployment

# Configurable variables
AWS_REGION ?= us-west-2
ACCOUNT_ID ?= 451658920213
ECR_REPO_NAME ?= jira-flow-metrics
IMAGE_NAME ?= jira-flow-metrics
TAG ?= latest-1
SERVICE_NAME ?= jira-flow-metrics-service

ECR_URI = $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPO_NAME):$(TAG)

# Build Docker image locally
build:
	docker build --platform linux/amd64 -t $(IMAGE_NAME):$(TAG) .

# Create ECR repo if it doesn't exist
create-repo:
	aws ecr describe-repositories --repository-names $(ECR_REPO_NAME) --region $(AWS_REGION) || \
	aws ecr create-repository --repository-name $(ECR_REPO_NAME) --region $(AWS_REGION) --profile saml

# Authenticate Docker with ECR
login:
	aws ecr get-login-password --region $(AWS_REGION) --profile saml | docker login --username AWS --password-stdin $(ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

# Tag image for ECR
tag:
	docker tag $(IMAGE_NAME):$(TAG) $(ECR_URI)

# Push image to ECR
push:
	docker push $(ECR_URI)

# Create a new App Runner service
create-service:
	aws apprunner create-service \
    --service-name jira-flow-metrics-service \
    --source-configuration file://policy.json \
    --region us-west-2 --profile saml



update-service: push
	aws apprunner update-service \
		--service-arn arn:aws:apprunner:$(AWS_REGION):$(ACCOUNT_ID):service/$(SERVICE_NAME)/YOUR_SERVICE_ID \
		--source-configuration ""{
			\"ImageRepository\": {
				\"ImageIdentifier\": \"$(ECR_URI)\",
				\"ImageRepositoryType\": \"ECR\",
				\"ImageConfiguration\": {
					\"Port\": \"8501\"
				}
			}
		}" \
		--region $(AWS_REGION)"

# Full pipeline (build → push → create-service)
release: create-service
