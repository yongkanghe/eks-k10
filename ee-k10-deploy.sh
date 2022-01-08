echo '-------Deploying Kasten K10 and Cassandra'
starttime=$(date +%s)
. ~/.bashrc
. ./setenv.sh

# echo $MY_CLUSTER-$(date +%s) > k10_eks_clustername
echo $MY_BUCKET-$(date +%s) > k10_eks_bucketname

echo '-------Enable OpenID Connect for the EKS cluster'
eksctl utils associate-iam-oidc-provider --cluster $(cat k10_eks_clustername) --approve
myid=$(aws iam list-open-id-connect-providers | grep Arn | awk '{print $2}' | sed -e 's/"//g' | sed -e 's/^.*id\///g')
myaccountid=$(aws sts get-caller-identity | grep Account | awk '{print $2}' | sed -e 's/\"//g' | sed -e 's/\,//g')
cat trust-policy.json | sed -e "s/id\/B823A14A8A7B1ADCD481718B762CF9F5/id\/$myid/g" | sed -e "s/911598032234/$myaccountid/g" > trust-policy4yong1.json 

echo '-------Create IAM policy and role for K10'
aws iam create-role --role-name k10-iam-role4yong1 --assume-role-policy-document file://trust-policy4yong1.json
aws iam put-role-policy --role-name k10-iam-role4yong1 --policy-name k10-iam-policy4yong1 --policy-document file://k10-iam-policy4yong1.json
export AWS_IAM_ROLE_ARN=arn:aws:iam::$myaccountid:role/k10-iam-role4yong1

echo '-------Install K10'
kubectl create ns kasten-io
helm repo add kasten https://charts.kasten.io
helm repo update

#For Production, remove the lines ending with =1Gi from helm install
#For Production, remove the lines ending with airgap from helm install
helm install k10 kasten/k10 --namespace=kasten-io \
  --set global.persistence.metering.size=1Gi \
  --set prometheus.server.persistentVolume.size=1Gi \
  --set global.persistence.catalog.size=1Gi \
  --set global.persistence.jobs.size=1Gi \
  --set global.persistence.logging.size=1Gi \
  --set global.persistence.grafana.size=1Gi \
  --set secrets.awsIamRole="${AWS_IAM_ROLE_ARN}" \
  --set auth.tokenAuth.enabled=true \
  --set externalGateway.create=true \
  --set metering.mode=airgap 

echo '-------Set the default ns to k10'
kubectl config set-context --current --namespace kasten-io

echo '-------Deploying a Cassandra database'
kubectl create ns k10-cassandra
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install cassandra bitnami/cassandra -n k10-cassandra --set persistence.size=1Gi

echo '-------Output the Cluster ID'
clusterid=$(kubectl get namespace default -ojsonpath="{.metadata.uid}{'\n'}")
echo "" | awk '{print $1}' > eks-token
echo My Cluster ID is $clusterid >> eks-token

echo '-------Wait for 1 or 2 mins for the Web UI IP and token'
kubectl wait --for=condition=ready --timeout=180s -n kasten-io pod -l component=jobs
k10ui=http://$(kubectl get svc gateway-ext | awk '{print $4}'|grep -v EXTERNAL)/k10/#
echo -e "\nCopy/Paste the link to browser to access K10 Web UI -->> $k10ui" >> eks-token
echo "" | awk '{print $1}' >> eks-token
sa_secret=$(kubectl get serviceaccount k10-k10 -o jsonpath="{.secrets[0].name}" --namespace kasten-io)
echo "Copy/Paste the token below to Signin K10 Web UI" >> eks-token
echo "" | awk '{print $1}' >> eks-token
kubectl get secret $sa_secret --namespace kasten-io -ojsonpath="{.data.token}{'\n'}" | base64 --decode | awk '{print $1}' >> eks-token
echo "" | awk '{print $1}' >> eks-token

echo '-------Waiting for K10 services are up running in about 1 or 2 mins'
kubectl wait --for=condition=ready --timeout=300s -n kasten-io pod -l component=catalog

#Create a S3 location profile
./ee-s3-location.sh

#Create a Cassandra backup policy
./cassandra-policy.sh

echo '-------Accessing K10 UI'
cat eks-token

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time for K10+DB+Policy is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
echo "" | awk '{print $1}'