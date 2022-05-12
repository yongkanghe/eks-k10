echo '-------Creating a S3 profile secret'
. ./setenv.sh
MY_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')

if [ ! -f hwcaccess ]; then
  echo -n "Enter your Huawei Cloud Access Key ID and press [ENTER]: "
  read AWS_ACCESS_KEY_ID
  echo "" | awk '{print $1}'
  echo $AWS_ACCESS_KEY_ID > hwcaccess
  echo -n "Enter your Huawei Cloud Secret Access Key and press [ENTER]: "
  read AWS_SECRET_ACCESS_KEY
  echo $AWS_SECRET_ACCESS_KEY >> hwcaccess
fi

export MY_REGION=ap-southeast-1
export MY_OBJECT_STORAGE_PROFILE=myobs-migration
export AWS_ACCESS_KEY_ID=$(cat hwcaccess | head -1)
export AWS_SECRET_ACCESS_KEY=$(cat hwcaccess | tail -1)
echo k10migration4yong1 > k10_migration_bucketname

kubectl create secret generic k10-obs-s3-secret \
      --namespace kasten-io \
      --type secrets.kanister.io/aws \
      --from-literal=aws_access_key_id=$AWS_ACCESS_KEY_ID \
      --from-literal=aws_secret_access_key=$AWS_SECRET_ACCESS_KEY

echo '-------Creating an OBS S3 profile'
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
        name: k10-obs-s3-secret
        namespace: kasten-io
    type: ObjectStore
    objectStore:
      name: $(cat k10_migration_bucketname)
      objectStoreType: S3
      region: $MY_REGION
      endpoint: obs.$MY_REGION.myhuaweicloud.com
EOF