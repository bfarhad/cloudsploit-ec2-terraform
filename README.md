# AWS cloud environment security scanners with Cloudsploit and Flan scanner

This repo and code placed here describe idea how to use the slave ec2 instances for producing scan of AWS account with Cloudsploit and flan scan for obtaining clear picture regarding security lacks inside and ouside of account. 

Requirements:
- Centos ec2 instance ID (we used AMI ID for Ireland area - hardcoded in main.tf)
- Already provisioned VPC with public subnet (Default also can be used)
- AWS account with administrative credentials
- Jenkins instance with pre-installed aws cli and terraform
Also you'll need manually modify Jenkins file for adding variables and add JenkinsCiCd key (with using CloudBees AWS credentials plugin);

Repository with Cloudsploit and flan scanner code and settings explanation
https://github.com/cloudsploit/scans
https://github.com/cloudflare/flan

Application procedure

1. Clone or fork this repo and modify settings in Jenkins file;
2. Create the Jenkins pipeline and input the URL of your repo;
3. During initial build select apply and get the results of scan;
4. Run pipe one more time and select destroy for removing the scanner instances;

Terraform plan which will be launched by Jenkins will do the next:
1. Provisioning of 2 x ec2 instance (t2.medium type) with generation of access keys in AWS account with preesented credentials. 1st instance name will be Scanner sploit nad second one Scanner Flan.
2. Install NodeJS 10.x by using userd_data on Scanner sploit and docker with python environment for running flan scanner.
3. Passing inputed creddentials as shell env. and using them for scanning your account.
4. Packing of results of scan and sent it with mailx on mail inputed as variables in Jenkins file.

What next:
A. Containerization of app and run it as Jenkins job with step 4,5,6
B. Integration of Azure, Github and Google CP for scanning

P.S. DON'T FORGET TO CREATE credentials.tfvars and proper S3 bucket for state in place where it will be run BEFORE FIRST RUN!
