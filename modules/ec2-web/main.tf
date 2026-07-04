data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "web" {
  name_prefix = "${var.project_name}-${var.environment}-web-sg-"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-sg"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  user_data_replace_on_change = true

  user_data = <<-CLOUDCONFIG
#cloud-config
package_update: true
packages:
  - nginx

write_files:
  - path: /var/www/html/index.html
    permissions: '0644'
    content: |
      <!DOCTYPE html>
      <html>
      <head>
        <title>Terraform Nginx Working</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            background: #0f172a;
            color: white;
            text-align: center;
            padding-top: 100px;
          }
          .box {
            background: #1e293b;
            padding: 40px;
            border-radius: 14px;
            width: 65%;
            margin: auto;
          }
          h1 {
            color: #22c55e;
          }
        </style>
      </head>
      <body>
        <div class="box">
          <h1>Hello Arsal!</h1>
          <h2>Nginx is working now</h2>
          <p>Environment: ${var.environment}</p>
          <p>This server was created using Terraform production structure.</p>
        </div>
      </body>
      </html>

  - path: /var/www/html/health.html
    permissions: '0644'
    content: |
      OK

runcmd:
  - systemctl enable nginx
  - systemctl restart nginx
  - systemctl status nginx --no-pager || true
CLOUDCONFIG

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-server"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
