# Define a variable for the project ID
GCP_PROJECT ?= $(error GCP_PROJECT  is not set. Please set the environment variable.)

default: help

##@ Utility
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

btcreate: ## Spin up a single node BigTable 
	@echo "GCP_PROJECT is set to: $(GCP_PROJECT)"
	@gcloud bigtable instances create structerdkeys --display-name="structerdkeys BigTable" --cluster-config=zone=us-west2-a,nodes=1,id=structerdkeys-cluster
	@gcloud bigtable instances tables create mydata --instance structerdkeys --project $(GCP_PROJECT) --column-families=data --no-deletion-protection
	@gcloud beta bigtable tables update mydata --instance=structerdkeys --project $(GCP_PROJECT) --row-key-schema-definition-file=schemadef.json --row-key-schema-pre-encoded-bytes

btload: ## load csv data into the BigTable
	@cbt  -instance structerdkeys -project $(GCP_PROJECT)  import mydata data.csv column-family=data

btdelete: ## Shutdown the BigTable 
	@echo "Y" | gcloud bigtable instances delete structerdkeys

