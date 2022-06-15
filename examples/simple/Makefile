build-aws_lambda_function_4b9415293b:
	terraform apply -target module.lambda_function.sammetadata_metadata.functions_metadata[0] -auto-approve
	terraform show -json | jq '.values.root_module.child_modules| .[].resources | .[] | select(.address=="module.lambda_function.sammetadata_metadata.functions_metadata[0]") | .values.built_path_property' | xargs -I{} unzip -o {} -d $(ARTIFACTS_DIR)
build-aws_lambda_function_056b1a911b:
	terraform apply -target module.lambda_function_2.sammetadata_metadata.functions_metadata[0] -auto-approve
	terraform show -json | jq '.values.root_module.child_modules| .[].resources | .[] | select(.address=="module.lambda_function_2.sammetadata_metadata.functions_metadata[0]") | .values.built_path_property' | xargs -I{} unzip -o {} -d $(ARTIFACTS_DIR)
build-aws_lambda_layer_version_ad03a6365f:
	terraform apply -target module.lambda_layer_local.sammetadata_metadata.layers_metadata[0] -auto-approve
	terraform show -json | jq '.values.root_module.child_modules| .[].resources | .[] | select(.address=="module.lambda_layer_local.sammetadata_metadata.layers_metadata[0]") | .values.built_path_property' | xargs -I{} unzip -o {} -d $(ARTIFACTS_DIR)
