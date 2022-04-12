echo '-------Creating an EKS Cluster + K10 (typically about 20 mins)'
starttime=$(date +%s)

#Create an EKS cluster
./eks-deploy.sh

#Deploy K10 + sample DB + backup policy 
./k10-deploy.sh

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time for EKS+K10 deployment is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
