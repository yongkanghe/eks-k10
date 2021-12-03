#This is the script for you to verify the backup and export status of a specific namespace
#Run ./k10status and input the namespace, the backup and and export status will be reported.

echo -n "Enter your namespace and press [ENTER]: "
read my_namespace
kubectl get backupactions.actions.kio.kasten.io -n $my_namespace | grep -v NAME | head -1 | awk '{print $1}' > backupname
echo "The backup job status is $(kubectl get backupactions.actions.kio.kasten.io -n $my_namespace $(cat backupname) -ojsonpath="{.status.state}{'\n'}")"
echo '' | awk '{print $1}'
kubectl get exportactions.actions.kio.kasten.io -n $my_namespace | grep -v NAME | head -1 | awk '{print $1}' > exportname
echo "The export job status is $(kubectl get exportactions.actions.kio.kasten.io -n $my_namespace $(cat exportname) -ojsonpath="{.status.state}{'\n'}")"


