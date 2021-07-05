## Introduction:
In this project, we are going to provision one linux vm (ubuntu 14.04) using Terraform automation (IaC), code is added in terraform script to install docker and make it capable for running docker images, and open port 80 and 22 for ssh. Once the vm is provisioned, then next step is to create the docker file for nginx container, then final step is to build and deploy the dockerfile to the provisioned vm


## Terraform automation to provision the vm
#### Pre-requisite
1. Install Terraform for linux
2. Install aws CLI

Craete the file wit name main.tf and write terrfaorm code\
1. define variables for access, secret key and region
```
variable "access_key" {
	default = "<your_access_key>"
}
variable "secret_key" {
	default = "<your_private_key>"
}
variable "region" {
    default = "us-west-2"
}

```
Note: If you dont want to how your access_key, secret_key and region, then you can first export these values on your system, then once you deploy these reosurces, by default these will be deployed on that aws account.

2. Next step is to setup aws provider
```
/* Setup our aws provider */
provider "aws" {
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  region      = "${var.region}"
}
```

3. Create security group for allowing ssh and http
```
resource "aws_security_group" "myInstance-ssh-http" {
        name = "ssh-http-security-group"
        description = "Allowing ssh and http traffic"


        ingress {
                from_port = 22
                to_port   = 22
                protocol  = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
      }

        ingress {
                from_port = 80
                to_port   = 80
                protocol  = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
      }

      egress {
                from_port   = "0"
                to_port     = "0"
                protocol    = "-1"
                cidr_blocks = ["0.0.0.0/0"]
                self        = true
    }
```
4. Create ec2 instance, attach security group to it and write docker installation commands for ubuntu 14.04
```
/*Creating aws ec2 instance */
resource "aws_instance" "myInstance" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.myInstance-ssh-http.name}"]
  key_name = "demo-key-terraform-us-east-2"
  /*user_data     = <<-EOF
                  #!/bin/bash
                  sudo apt-get update
                  sudo apt-get -y install docker.io
                  sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker
                  sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io                   
                  EOF
    */

  tags = {
    Name = "dockervm"
  }
}
```

#### Prerequisites:
1. Resource group for the deployment.

#### To be provided:
1. Resource Group
2. Data Factory Name
3. Storage Account Name
4. Location
5. Option (Yes or No) to deploy or not to deploy SQL Server, SQL Database and SQL sink within the pipeline.
6. If selected **Yes**, please provide

   - SQL Server Name 

   - SQL Database Name
   
   - SQL Server Administrator Username

7. Notification Email
8. Option (Yes or No) to enable Microsoft Teams Notifications
9. Logic App Name
10. Data Share Account Name.
11. Share Name
12. Option (Yes or No) to deploy and use data share.
13. Key Vault Name.
14. Azure User Object Id.


**NOTE** - If you go with SQL sink, the name of the table where data is written is _**USAFacts.curatedTable**_.

Click the following button to deploy all the resources.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Femumba-msft-data-pipelines%2Fjll-one-click-deployments%2Fmain%2Fdatasets%2Fjll%2FUSAFacts-data%2Fpublic%2Ftemplates%2Fazuredeploy.json)


#### Configure Firewall Rule
After deployment, to access the newly created SQL server from your client IP, configure the firewall rule as described in the following GIF:-

![Firewall Rule](./images/firewallRule.gif)


#### Manually Trigger Pipeline

After the deployment, you can go inside your resource group open the ADF **Author and Monitor** section and trigger the pipeline as shown below:-

![Manual Pipeline Trigger](./images/manual-ADF-public-env-trigger.png)
