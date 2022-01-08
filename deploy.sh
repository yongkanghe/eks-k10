echo '-------Creating an EKS Cluster (typically about 20 mins)'
starttime=$(date +%s)

#Create an EKS cluster
./eks-deploy.sh

#Deploy K10 + sample DB + backup policy 
./k10-deploy.sh

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time for EKS+k10 deployment is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang"
echo "-------Email me if any suggestions or issues he@yongkang.cloud"
echo "" | awk '{print $1}'