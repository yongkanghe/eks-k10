echo '-------Creating an EKS Cluster (typically about 20 mins)'
starttime=$(date +%s)
. setenv.sh
EKS_CLUSTER_NAME=$MY_CLUSTER-$(date +%s)
EKS_BUCKET_NAME=$MY_BUCKET-$(date +%s)
echo $EKS_CLUSTER_NAME > eks_clustername
echo $EKS_BUCKET_NAME > eks_bucketname

eksctl create cluster \
  --name $EKS_CLUSTER_NAME \
  --version $MY_K8S_VERSION \
  --nodegroup-name workers4yong1 \
  --nodes 1 \
  --nodes-min 1 \
  --nodes-max 3 \
  --node-type $MY_INSTANCE_TYPE \
  --ssh-public-key ~/.ssh/id_rsa.pub \
  --region $MY_REGION \
  --ssh-access \
  --managed

echo '-------Install K10'
kubectl create ns kasten-io
helm repo add kasten https://charts.kasten.io
helm install k10 kasten/k10 --namespace=kasten-io \
  --set global.persistence.metering.size=1Gi \
  --set prometheus.server.persistentVolume.size=1Gi \
  --set global.persistence.catalog.size=1Gi \
  --set global.persistence.jobs.size=1Gi \
  --set global.persistence.logging.size=1Gi \
  --set secrets.awsAccessKeyId="${AWS_ACCESS_KEY_ID}" \
  --set secrets.awsSecretAccessKey="${AWS_SECRET_ACCESS_KEY}" \
  --set auth.tokenAuth.enabled=true \
  --set externalGateway.create=true  

echo '-------Set the default ns to k10'
kubectl config set-context --current --namespace kasten-io

echo '-------Deploying a PostgreSQL database'
kubectl create namespace postgresql
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install --namespace postgresql postgres bitnami/postgresql --set persistence.size=1Gi

echo '-------Output the Cluster ID'
clusterid=$(kubectl get namespace default -ojsonpath="{.metadata.uid}{'\n'}")
echo "" | awk '{print $1}' > eks-token
echo My Cluster ID is $clusterid >> eks-token

echo '-------Extract the token for k10-k10 admin'
sa_secret=$(kubectl get serviceaccount k10-k10 -o jsonpath="{.secrets[0].name}" --namespace kasten-io)
kubectl get secret $sa_secret --namespace kasten-io -ojsonpath="{.data.token}{'\n'}" | base64 --decode > $HOME/k8s/eks-token
sed -i -e '$a\' $HOME/k8s/eks-token

echo '-------Creating a S3 profile secret'
kubectl create secret generic k10-s3-secret \
      --namespace kasten-io \
      --type secrets.kanister.io/aws \
      --from-literal=aws_access_key_id=$AWS_ACCESS_KEY_ID \
      --from-literal=aws_secret_access_key=$AWS_SECRET_ACCESS_KEY

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
      name: $EKS_BUCKET_NAME
      objectStoreType: S3
      region: $MY_REGION
EOF

echo '------Create backup policies'
cat <<EOF | kubectl apply -f -
apiVersion: config.kio.kasten.io/v1alpha1
kind: Policy
metadata:
  name: postgresql-backup
  namespace: kasten-io
spec:
  comment: ""
  frequency: "@hourly"
  actions:
    - action: backup
      backupParameters:
        profile:
          namespace: kasten-io
          name: $MY_OBJECT_STORAGE_PROFILE
    - action: export
      exportParameters:
        frequency: "@hourly"
        migrationToken:
          name: ""
          namespace: ""
        profile:
          name: $MY_OBJECT_STORAGE_PROFILE
          namespace: kasten-io
        receiveString: ""
        exportData:
          enabled: true
      retention:
        hourly: 0
        daily: 0
        weekly: 0
        monthly: 0
        yearly: 0
  retention:
    hourly: 4
    daily: 1
    weekly: 1
    monthly: 0
    yearly: 0
  selector:
    matchExpressions:
      - key: k10.kasten.io/appNamespace
        operator: In
        values:
          - postgresql
EOF

sleep 3

echo '-------Kickoff the on-demand backup job'
sleep 2
cat <<EOF | kubectl create -f -
apiVersion: actions.kio.kasten.io/v1alpha1
kind: RunAction
metadata:
  generateName: run-backup-
spec:
  subject:
    kind: Policy
    name: postgresql-backup
    namespace: kasten-io
EOF

echo '-------Accessing K10 UI'
cat eks-token

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"