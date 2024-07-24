output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "The ID of the Subnet"
  value       = aws_subnet.main.id
}

output "security_group_id" {
  description = "The ID of the Security Group"
  value       = aws_security_group.jenkins_sg.id
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.jenkins.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.jenkins.public_ip
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.jenkins_repo.repository_url
}
