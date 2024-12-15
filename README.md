## AWS-Terraform basic + S3
## David Eliason 12/14/2024

This project builds off my previous repo. 

I updated the Data Source for the AMI to point to Amazon Linux 2 AMI, referencing the latest AMI available. This keeps hard-coding from being implemented.
I upded the public key from hard coded to reference the local file for best practices.

Useful video building out AWS services and infrastructure using Terraform: https://www.youtube.com/watch?v=rsct-JvJmKs

$ terraform output --raw public_ip # TF output variable providing the running instance public IP address (config output.tf)
    ex: 52.43.220.176

This is useful so that the user is not required to manually go to the AWS Management Console to obtain the IP address to SSH into the machine.


