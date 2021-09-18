echo "Install eksctl"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C ~/eks-k10

echo "Install kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod 755 kubectl

echo "Install helm"
wget https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz
tar -zxvf helm-v3.7.0-linux-amd64.tar.gz
mv linux-amd64/helm .
rm helm-v3.7.0-linux-amd64.tar.gz
rm -rf linux-amd64
echo "export PATH=$PATH:~/eks-k10" >> ~/.bashrc
echo "alias k=kubectl" >> ~/.bashrc
. ~/.bashrc

echo "Generate ssh public key"
ssh-keygen -q -f ~/.ssh/id_rsa -N ""

echo "Configure AWS Access Key ID and Secret Access Key"

