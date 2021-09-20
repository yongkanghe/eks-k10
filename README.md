I just want to build an EKS Cluster to play with the various Data Management capabilities e.g. Backup/Restore, Disaster Recovery and Application Mobility. 

It is challenging to create an EKS cluster from AWS Cloud if you are not familiar to it. After the EKS Cluster is up running, we still need to install Kasten, create a sample DB, create policies etc.. The whole process is not that simple.

![image](https://blog.kasten.io/hs-fs/hubfs/Blog%20Cross-Cluster%20Application%20Migration%20and%20Disaster%20Recovery%20for%20AWS%20EKS%20Using%20Kasten%20K10%20by%20Michael%20Cade%205.png?width=406&name=Blog%20Cross-Cluster%20Application%20Migration%20and%20Disaster%20Recovery%20for%20AWS%20EKS%20Using%20Kasten%20K10%20by%20Michael%20Cade%205.png)

This script based automation allows you to build a ready-to-use Kasten K10 demo environment running on EKS in about about 20 minutes. For simplicity and cost optimization, the EKS cluster will have only one worker node and create a separate vpc and subnets. This is bash shell based scripts which might only work on Cloud Shell. Linux and MacOS terminal may work as well, but I haven't tested it yet. 

# Here're the prerequisities. 

1. Go to AWS Cloud Shell
2. Clone the github repo, run below command
````
git clone https://github.com/yongkanghe/eks-k10.git
````
3. Install the required tools (eksctl, kubectl, helm) and input AWS Access Credentials
````
cd eks-k10;./awsprep.sh
````
4. Optionally, you can customize the clustername, instance-type, zone, region, bucketname
````
vi setenv.sh
````
# To build the labs, run 
````
./deploy.sh
````
1. Create an EKS Cluster from CLI
2. Install Kasten K10
3. Deploy a Cassandra NoSQL database
4. Create a location profile
5. Create a backup policy
6. Kick off an on-demand backup job

# To delete the labs, run 
````
./destroy.sh
````
1. Remove the EKS Kubernetes Cluster
2. Remove all the relevant disks
3. Remove all the relevant snapshots
4. Remove the S3 storage bucket

# Cick my picture to watch the how-to video.
[![IMAGE ALT TEXT HERE](https://media-exp1.licdn.com/dms/image/C5622AQFFvnbYckYuEw/feedshare-shrink_2048_1536/0/1632117949616?e=1634774400&v=beta&t=Z4RMzo7gnPj7V52Jmi-0sYeVLIL_IYo9FYrGdIw3Tqs)](https://www.youtube.com/watch?v=v_Aks8GFBVA)

# For more details about EKS Backup and Restore
https://blog.kasten.io/cross-cluster-application-migration-and-dr-for-aws-eks-using-kasten-k10


# Kasten - No. 1 Kubernetes Backup
https://kasten.io 

# Kasten - DevOps tool of the month July 2021
http://k10.yongkang.cloud

# Contributors

### [Yongkang He](http://yongkang.cloud)
