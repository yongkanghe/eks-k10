echo "Install eksctl"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

echo "Install kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "Install helm"
export VERIFY_CHECKSUM=false
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

echo "Generate ssh public key"
ssh-keygen -q -f ~/.ssh/id_rsa -N ""

echo "Configure AWS Access Key ID and Secret Access Key"
export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"         #Update with your access key
export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY" #Update with your secret key