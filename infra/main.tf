resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "jenkins_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins" {
  ami           = "ami-00cf59bc9978eb266" # Amazon Linux 2 AMI
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 25 # Size in GB (change to your desired size)
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y git docker
              amazon-linux-extras install -y java-openjdk11
              curl -fsSL https://get.docker.com/ | sh
              service docker start
              usermod -aG docker ec2-user

              # Install Jenkins
              wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo
              rpm --import http://pkg.jenkins.io/redhat/jenkins.io.key
              yum install -y jenkins
              systemctl start jenkins
              systemctl enable jenkins
              usermod -aG docker jenkins

              # Install kubectl
              curl -o /usr/local/bin/kubectl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              chmod +x /usr/local/bin/kubectl
              chown jenkins:jenkins /usr/local/bin/kubectl

              # Install kind
              curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
              chmod +x ./kind
              mv ./kind /usr/local/bin/kind
              chown jenkins:jenkins /usr/local/bin/kind

              # Install helm
              curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
              chown jenkins:jenkins /usr/local/bin/helm

              # Give Jenkins user access to all tools
              echo 'jenkins ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
              EOF

  tags = {
    Name = "JenkinsServer"
  }
}

resource "aws_ecr_repository" "jenkins_repo" {
  name = "jenkins-repo"
}
