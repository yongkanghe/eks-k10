#This is the script for you to verify the backup and export status of the k10- namespace
#Run ./k10status, shortly, the backup and and export status will be reported.

my_namespace=$(kubectl get ns | grep k10- | awk '{print $1}')
kubectl get backupactions.actions.kio.kasten.io -n $my_namespace | grep -v NAME | head -1 | awk '{print $1}' > backupname
echo "The backup job status is $(kubectl get backupactions.actions.kio.kasten.io -n $my_namespace $(cat backupname) -ojsonpath="{.status.state}{'\n'}")"
kubectl get exportactions.actions.kio.kasten.io -n $my_namespace | grep -v NAME | head -1 | awk '{print $1}' > exportname
echo "The export job status is $(kubectl get exportactions.actions.kio.kasten.io -n $my_namespace $(cat exportname) -ojsonpath="{.status.state}{'\n'}")"
echo '' | awk '{print $1}'
