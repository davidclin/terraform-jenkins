# jenkins_automation
  Terraform files to deploy jenkins and automation scripts for post configuration
## prerequisites
   * terraform 
   * GHE Web Uri and GHE API Uri
   * GHE Client ID and Client Secret for autherization
   * Valid Apache cert (copy to your system)

### Resources Deployed in AWS
   * Folder object S3 bucket
   * IAM policy for S3 bucket - Folder
   * IAM role for EC2 instance - attached to S3 policy
   * EC2 instance with IAM Role
   * Security Group for EC2
   * Route53 for DNS

### Usage
   * terraform init --> to set AWS provider info(initial one time step)
   * terraform validate --> to validate the tf files
   * terraform plan --output <planfilename> --> to see the plan of resources add/changed/destroyed
   * terraform apply <planfilename> --> to apply the above plan
   * terraform destroy --> to destory entire stack.


### variables need to execute terraform script
   * admin_email --> email address of jenkins server admin
   * admin_user_anme --> user name from GHE (multiple names can be given separated by comma), Only admin will have privilages for Secuirty settings
   * bucket_name --> Name of the bucket where back up will be stored.
   * cert_file_path --> Apache Valid certificate full path
   * disk_size --> default 300 GB, EBS volume attahced to Jenkins
   * ghe_api_uri --> valid api url of GHE e.g: https://github.domain.com/api/v3
   * ghe_client_id --> client ID of organization from which Jenkins authenticate Users
   * ghe_client_secret --> client secret of organization from which Jenkins authenticate Users
   * ghe_web_uri --> Valid Web url of GHE e.g: https://github.domain.com
   * instance_type --> Jenkins instance type e.g: r4.large
   * key_pair --> Name of the key pair present in AWS and you have PEM file ( User must create one if not present)
   * pem_file --> PEM file location, Needed for Post-Configuration of Jenkins
   * pretty_name --> pretty name to configure for DNS

