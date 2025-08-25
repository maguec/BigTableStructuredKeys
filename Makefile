default: help

##@ Utility
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

btcreate: ## Spin up a single node BigTable 
	@gcloud bigtable instances create structerdkeys --display-name="structerdkeys BigTable" --cluster-config=zone=us-west1-a,nodes=1,id=structerdkeys-cluster
	@gcloud bigtable instances tables create mydata --instance structerdkeys --project mague-tf --column-families=data --no-deletion-protection
	@gcloud beta bigtable tables update mydata --instance=structerdkeys --project mague-tf --row-key-schema-definition-file=schemadef.json --row-key-schema-pre-encoded-bytes

btload: ## load csv data into the BigTable
	@cbt  -instance structerdkeys -project mague-tf  import mydata data.csv column-family=data

btdelete: ## Shutdown the BigTable 
	@echo "Y" | gcloud bigtable instances delete structerdkeys

