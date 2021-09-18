echo "Install eksctl"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

echo "Generate ssh public key"
ssh-keygen -q -f ~/.ssh/id_rsa -N ""

echo "Configure AWS Access Key ID and Secret Access Key"
export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"         #Update with your access key
export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY" #Update with your secret key