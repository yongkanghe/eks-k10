#### Follow [@YongkangHe](https://twitter.com/yongkanghe) on Twitter, Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

I just want to build an EKS Cluster to play with the various Data Management capabilities e.g. Backup/Restore, Disaster Recovery and Application Mobility. 

It is challenging to create an EKS cluster from AWS Cloud if you are not familiar to it. After the EKS Cluster is up running, we still need to install Kasten, create a sample DB, create policies etc.. The whole process is not that simple.

![image](https://blog.kasten.io/hs-fs/hubfs/Blog%20Cross-Cluster%20Application%20Migration%20and%20Disaster%20Recovery%20for%20AWS%20EKS%20Using%20Kasten%20K10%20by%20Michael%20Cade%205.png?width=406&name=Blog%20Cross-Cluster%20Application%20Migration%20and%20Disaster%20Recovery%20for%20AWS%20EKS%20Using%20Kasten%20K10%20by%20Michael%20Cade%205.png)

This script based automation allows you to build a ready-to-use Kasten K10 demo environment running on EKS in about about 20 minutes with deploy.sh. For simplicity and cost optimization, the EKS cluster will have only one worker node and create a separate vpc and subnets. This is bash shell based scripts which might only work on Cloud Shell. Linux and MacOS terminal may work as well, but I haven't tested it yet. 

If you already have an EKS cluster running, you only need 3 minutes to protect containers on EKS cluster by k10-deploy.sh from the section 2. 

# Here're the prerequisities. 

1. Go to AWS Cloud Shell
2. Clone the github repo, run below command
````
git clone https://github.com/yongkanghe/eks-k10.git
````
3. Install the required tools (eksctl, kubectl, helm) and input AWS Access Credentials
````
cd eks-k10;./awsprep.sh;. ./setenv.sh
````
4. Optionally, you can customize the clustername, instance-type, zone, region, bucketname
````
vi setenv.sh
````

# Do you have an EKS cluster up running? 
If yes, please go directly to the section 2. Otherwise, follow the guide on the section 1 and ignore section 2. 

# Section 1, build the labs including EKS cluster, run 
````
./deploy.sh
````
1. Create an EKS Cluster from CLI
2. Install Kasten K10
3. Deploy a Cassandra NoSQL database
4. Create a location profile
5. Create a backup policy
6. Kick off an on-demand backup job

# To delete the labs including EKS cluster, run 
````
./destroy.sh
````
1. Remove the EKS Kubernetes Cluster
2. Remove all the relevant disks
3. Remove all the relevant snapshots
4. Remove the S3 storage bucket

# Section 2, build the labs having an EKS cluster, run 
````
./k10-deploy.sh
````
1. Install Kasten K10
2. Deploy a Cassandra NoSQL database
3. Create a location profile
4. Create a backup policy
5. Kick off an on-demand backup job

# To delete the labs excluding EKS cluster, run 
````
./k10-destroy.sh
````
1. Remove all the relevant disks
2. Remove all the relevant snapshots
3. Remove the S3 storage bucket

# Learn how to build an EKS cluster via Web UI
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/d0vhf_ggnko/0.jpg)](https://www.youtube.com/watch?v=d0vhf_ggnko)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# Learn how to protect containers on EKS cluster
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/27sIjUbxgFk/0.jpg)](https://www.youtube.com/watch?v=27sIjUbxgFk)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# Learn how to build an EKS cluster + K10 via Automation
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/v_Aks8GFBVA/0.jpg)](https://www.youtube.com/watch?v=v_Aks8GFBVA)
#### Subscribe [K8s Data Management](https://www.youtube.com/channel/UCm-sw1b23K-scoVSCDo30YQ?sub_confirmation=1) Youtube Channel

# For more details about EKS Backup and Restore
https://blog.kasten.io/cross-cluster-application-migration-and-dr-for-aws-eks-using-kasten-k10


# Kasten - No. 1 Kubernetes Backup
https://kasten.io 

# Kasten - DevOps tool of the month July 2021
http://k10.yongkang.cloud

# Contributors

#### Follow [Yongkang He](http://yongkang.cloud) on LinkedIn, Join [Kubernetes Data Management](https://www.linkedin.com/groups/13983251) LinkedIn Group


| Don't have an EKS cluster | Already have an EKS cluster | Deploy everything   |
|---------------------------|-----------------------------|---------------------|
| EKS only deploy           | K10 only deploy             | EKS+K10 deploy      |
| ``` ./eks-deploy.sh ```   | ``` ./k10-deploy.sh ```     | ``` ./deploy.sh ``` |
