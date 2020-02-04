sudo yum install -y epel-release curl git nano
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum -y install nodejs
git clone https://github.com/cloudsploit/scans.git
cd scans/
npm install