resource "aws_instance" "instance" {
    count = var.count1
    ami = var.ami
    instance_type = var.ins_type
    associate_public_ip_address = var.public_id
    subnet_id = var.subnet_ids[count.index]
    vpc_security_group_ids = [aws_security_group.web.id]
    key_name = var.key_name
    user_data = file("./scripts/httpd.sh")
    user_data_replace_on_change = true
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name 
    tags = {
     Name = "EC2-${count.index + 1}"

     }
 
}

# Create SG for EC2

resource "aws_security_group" "web" {
    name = "Allow Traffic for Web"
    description = "Allow Inbond Traffic"
    vpc_id = var.vpc_id
    dynamic "ingress" {
        for_each=var.web_ingress_rules
        content{
            description = "Some Decription"
            from_port=ingress.value.port
            to_port=ingress.value.port
            protocol=ingress.value.protocol
            cidr_blocks=ingress.value.cidr_blocks
        }   
    }
        egress{
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
        ipv6_cidr_blocks=["::/0"]
    }
    tags={
        Name="ec2_security_rules"
    }
}

resource "aws_iam_role" "ec2_role" {
  name = "s3-role"
  
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}
resource "aws_iam_policy" "ec2_instance_policy" {
  name        = "s3-role"
  description = "An example IAM policy for S3 access"
  
  # Remove leading spaces from the policy document
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::bucket-name-sharath",
        "arn:aws:s3:::bucket-name-sharath/*"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_policy_attachment" "example_policy_attachment" {
  name       = "ec2_instance_role_attachment"  # Specify a name for the attachment
  policy_arn = aws_iam_policy.ec2_instance_policy.arn
  roles      = [aws_iam_role.ec2_role.name]
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "s3-role"
    role = aws_iam_role.ec2_role.name
}