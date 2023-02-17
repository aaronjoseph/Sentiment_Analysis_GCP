plan: ## Runs terraform plan on $PROJECT. F.E. `make project=${PROJECT} bucket=${bucket} plan`
	@rm -rf .terraform && \
	    terraform init -backend-config="prefix=${project}" -backend-config="bucket=${project}-tfstates" && \
		terraform plan \
			-out=${planname}.tfplan \
			-var-file=project_configuration/${project}/variables.tfvars.json \
			-var-file=project_configuration/${project}/terraform.auto.tfvars \
			-var="project_id=${project}"


apply: ## Runs terraform apply on $PROJECT. F.E. `make project=${PROJECT} apply`
	@rm -rf .terraform && \
		terraform init -backend-config="prefix=${project}" -backend-config="bucket=${project}-tfstates" && \
		terraform apply -input=false ${planname}.tfplan
				-var-file=project_configuration/${project}/variables.tfvars.json \
				-var-file=project_configuration/${project}/terraform.auto.tfvars
