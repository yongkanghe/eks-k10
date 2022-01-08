echo '-------Creating an EKS Cluster only (typically about 15 mins)'
starttime=$(date +%s)
. ~/.bashrc
. ./setenv.sh

echo $MY_CLUSTER-$(date +%s) > k10_eks_clustername
# echo $MY_BUCKET-$(date +%s) > k10_eks_bucketname
export AWS_ACCESS_KEY_ID=$(cat awsaccess | head -1)
export AWS_SECRET_ACCESS_KEY=$(cat awsaccess | tail -1)

eksctl create cluster \
  --name $(cat k10_eks_clustername) \
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

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time to build an EKS cluster is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'