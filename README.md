# cloudsploit-ec2-terraform
PoC for provisioning ec2 instance with installed Node.JS and Cloudsploit code for scan cloud account for vulnerabilities.

Repository with Cloudsploit code and settings explanation 
https://github.com/cloudsploit/scans

Initial plan (we should have AWS account with already provisioned VPC)
Modify the variables before launch!

Have done:
1. Create cloudsploit IAM user with attached policy (native AWS security-audit) for further scan (read it here https://github.com/cloudsploit/scans#aws)

2. Provision of ec2 instance (CentOS7 linux on ami-192a9460) in eu-west-1 area with elastic IP with hardcoded VPC and subnet ID (in variables.tf)

3. Install Node.JS and cloudsploit code in /scans folder

WIP (work in progress):
4. provisioning of template file index.js with generated credentials for account scan

5. Run scan (can be done as command calling bash file after provisioning) with full standard, HIPAA and PCI reports with further output inside of /scans folder

???
6. Send report to account owner with SES - need to save report to attached s3 bucket

What next:
A. Containerization of app and run it as Jenkins job with step 4,5,6
B. Integration of Azure, Github and Google CP for scanning

P.S. DON'T FORGET TO CREATE credentials.tfvars BEFORE FIRST RUN!
