starttime=$(date +%s)
. ./setenv.sh

clusterid=$(kubectl get namespace default -ojsonpath="{.metadata.uid}{'\n'}")
# eksctl delete cluster --name $(cat k10_eks_clustername) --region $MY_REGION

echo '-------Deleting Cassandra and Kasten K10'

helm uninstall cassandra -n k10-cassandra
helm uninstall k10 -n kasten-io
kubectl delete ns k10-cassandra
kubectl delete ns kasten-io

# echo '-------Deleting EBS Volumes'
# aws ec2 describe-volumes --region $MY_REGION --query "Volumes[*].{ID:VolumeId}" --filters Name=tag:eks:cluster-name,Values=$(cat k10_eks_clustername) | grep ID | awk '{print $2}' > ebs.list
# aws ec2 describe-volumes --region $MY_REGION --query "Volumes[*].{ID:VolumeId}" --filters Name=tag:kubernetes.io/cluster/$(cat k10_eks_clustername),Values=owned | grep ID | awk '{print $2}' >> ebs.list
# for i in $(sed 's/\"//g' ebs.list);do echo $i;aws ec2 delete-volume --volume-id $i;done

echo '-------Deleting snapshots'
aws ec2 describe-snapshots --owner self --query "Snapshots[*].{ID:SnapshotId}" --filters Name=tag:kanister.io/clustername,Values=$clusterid --region $MY_REGION | grep ID | awk '{print $2}' > ebssnap.list
for i in $(sed 's/\"//g' ebssnap.list);do echo $i;aws ec2 delete-snapshot --snapshot-id $i;done

echo '-------Deleting objects from the bucket'
aws s3 rb s3://$(cat k10_eks_bucketname) --force
aws s3 rb s3://$(cat k10_migration_bucketname) --force

# echo '-------Deleting kubeconfig for this cluster'
# kubectl config delete-context $(kubectl config get-contexts | grep $(cat eks_clustername) | awk '{print $2}')

echo "" | awk '{print $1}'
endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'
