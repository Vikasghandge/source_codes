aws s3api create-bucket \
    --bucket my-s3-bucket \
    --region ap-south-1 \
    --create-bucket-configuration LocationConstraint=ap-south-1
