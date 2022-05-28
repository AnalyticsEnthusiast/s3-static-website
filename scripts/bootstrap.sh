#!/bin/bash
#
# Create a public bucket in us-east-1 that is set up for static website hosting
#
# I took inspiration from this blog post -> https://sammeechward.com/aws-cli-s3-static-website/
################

ARG="$1"

PROFILE_NAME="UdacityAdmin"
REGION="us-east-1"
BUCKET_NAME="static-blog-df-001"
HOME_DIR="/home/dfoley/Documents/Udacity/project_static_website/static_website"


create_bucket() {

	aws s3 mb\
		"s3://${BUCKET_NAME}"\
		--region "${REGION}"\
		--profile "${PROFILE_NAME}"

	aws s3api put-public-access-block \
		--bucket "${BUCKET_NAME}" \
		--public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"\
		--profile "${PROFILE_NAME}"

	aws s3api put-bucket-policy\
	       	--bucket "${BUCKET_NAME}"\
		--profile "${PROFILE_NAME}"\
		--policy file://policy.json

	aws s3 website "s3://${BUCKET_NAME}"\
		--index-document index.html\
		--error-document error.html\
		--profile "${PROFILE_NAME}"

	aws s3 sync "${HOME_DIR}"\
		"s3://${BUCKET_NAME}/"\
	       --profile "${PROFILE_NAME}"	

}

delete_bucket() {

	aws s3 rb "s3://${BUCKET_NAME}"\
		--profile "${PROFILE_NAME}"

}


main() {
	[ "${ARG^^}" = "DELETE" ] && delete_bucket

	[ "${ARG^^}" = "CREATE" ] && create_bucket

}

main
