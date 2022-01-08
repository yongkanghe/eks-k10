. ./setenv.sh

echo '-------Creating a S3 profile secret'
# export AWS_ACCESS_KEY_ID=$(cat awsaccess | head -1)
# export AWS_SECRET_ACCESS_KEY=$(cat awsaccess | tail -1)
kubectl create secret generic k10-s3-secret \
      --namespace kasten-io \
      --type secrets.kanister.io/aws

echo '-------Creating a S3 profile'
cat <<EOF | kubectl apply -f -
apiVersion: config.kio.kasten.io/v1alpha1
kind: Profile
metadata:
  name: $MY_OBJECT_STORAGE_PROFILE
  namespace: kasten-io
spec:
  type: Location
  locationSpec:
    credential:
      secretType: AwsAccessKey
      secret:
        apiVersion: v1
        kind: Secret
        name: k10-s3-secret
        namespace: kasten-io
    type: ObjectStore
    objectStore:
      name: $(cat k10_eks_bucketname)
      objectStoreType: S3
      region: $MY_REGION
EOF
