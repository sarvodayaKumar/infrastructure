provider "aws" {
  region = var.aws_region # Specifies the AWS region to deploy resources in.
  
  # Debugging log
  lifecycle {
    postcondition {
      condition     = var.aws_region != ""
      error_message = "AWS region must be specified."
    }
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH"
  
  # Allow SSH access from anywhere (Not recommended for production use)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = var.ami_id  # Amazon Machine Image ID for the EC2 instance
  instance_type = var.instance_type  # Instance type (e.g., t2.micro)
  key_name      = var.key_name  # Name of the SSH key pair for accessing the instance
  security_groups = [aws_security_group.web_sg.name]  # Attach the security group

  user_data = file("nginx.sh") # Bootstrap script to install Nginx and configure the server

  # Debugging log
  lifecycle {
    postcondition {
      condition     = var.ami_id != ""
      error_message = "AMI ID must be specified."
    }
  }

  tags = {
    Name = "${var.environment}-nginx-server" # Assign a tag to identify the instance
  }
}

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web.public_ip # Outputs the public IP for easy access
  
  # Debugging log
  lifecycle {
    postcondition {
      condition     = aws_instance.web.public_ip != ""
      error_message = "Public IP must be available after deployment."
    }
  }
}
